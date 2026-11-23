"""HTTP routes for a local, human-reviewed returns workspace."""

import hmac
import secrets
from io import BytesIO
from uuid import uuid4

from flask import (
    Flask, abort, flash, redirect, render_template, request,
    send_file, session, url_for,
)

from .config import Settings
from .images import MAX_UPLOAD, InvalidPhoto, normalize_photo
from .models import InspectionReport, OUTCOMES, VIEWS
from .store import ReviewStore
from .vision import OpenAIVision, VisionUnavailable


def create_app(settings: Settings | None = None, *, vision: OpenAIVision | None = None) -> Flask:
    settings = settings or Settings.from_environment()
    app = Flask(__name__)
    app.config.update(
        SECRET_KEY=settings.secret_key or secrets.token_hex(32),
        MAX_CONTENT_LENGTH=3 * MAX_UPLOAD + 128 * 1024,
        MAX_FORM_PARTS=12,
        SESSION_COOKIE_SAMESITE="Strict",
        TRUSTED_HOSTS=["127.0.0.1", "localhost", "[::1]"],
    )

    store = ReviewStore(settings.database)
    store.initialize()
    with app.open_resource("sample/parcel.jpg") as sample:
        demo_photo = normalize_photo("front-right", sample.read())
    store.add_case("RT-1842", "Unbranded cardboard carton", [demo_photo], sample_report=InspectionReport.model_validate({
        "summary": "The staged front-right photo shows a folded corner and rolled cardboard fibers.",
        "findings": [{
            "view": "front-right",
            "verdict": "possible_damage",
            "observation": "Corner compression at the lower-right edge of the carton.",
            "box": {"x": 0.59, "y": 0.58, "width": 0.13, "height": 0.25},
        }],
    }))

    provider = vision or (OpenAIVision(settings.api_key, settings.model) if settings.api_key else None)
    app.jinja_env.globals.update(vviews=VIEWS, outcomes=OUTCOMES)

    @app.before_request
    def protect_forms():
        if request.method == "POST":
            expected = session.get("csrf", "")
            supplied = request.form.get("csrf", "")
            if not expected or not hmac.compare_digest(expected.encode(), supplied.encode()):
                abort(400, "Reload the workspace before submitting the form.")

    @app.after_request
    def protect_evidence(response):
        response.headers["Cache-Control"] = "no-store"
        response.headers["X-Content-Type-Options"] = "nosniff"
        response.headers["Referrer-Policy"] = "no-referrer"
        return response

    @app.errorhandler(413)
    def too_large(_error):
        flash("Upload up to three photos, each no larger than 5 MB.", "error")
        return render_queue(), 413

    def render_queue(case=None, views=(), report=None, selected=None):
        if "csrf" not in session:
            session["csrf"] = secrets.token_urlsafe(32)
        return render_template(
            "workspace.html", cases=store.list_cases(), case=case,
            views=views, report=report, selected=selected,
            finding=next((f for f in report.findings if f.view == selected), None) if report else None,
            vision_enabled=provider is not None, csrf=session["csrf"],
        )

    @app.get("/")
    def queue():
        cases = store.list_cases()
        return redirect(url_for("case_view", case_id=cases[0]["id"]))

    @app.get("/returns/<case_id>")
    def case_view(case_id):
        case, views = store.get_case(case_id)
        if case is None:
            abort(404)
        selected = request.args.get("view")
        if selected not in views:
            selected = next((view for view in VIEWS if view in views), None)
        report = InspectionReport.model_validate_json(case["report"]) if case["report"] else None
        return render_queue(case, views, report, selected)

    @app.get("/returns/<case_id>/photos/<view>")
    def case_photo(case_id, view):
        photo = store.get_photo(case_id, view)
        if photo is None:
            abort(404)
        return send_file(BytesIO(photo), mimetype="image/jpeg", conditional=False)

    @app.post("/returns")
    def create_return():
        item = request.form.get("item", "").strip()
        if not 1 <= len(item) <= 100:
            flash("Enter an item name up to 100 characters.", "error")
            return render_queue(), 400
        photos = []
        for view, label in VIEWS.items():
            file = request.files.get(view)
            if file and file.filename:
                try:
                    photos.append(normalize_photo(view, file.stream.read(MAX_UPLOAD + 1)))
                except InvalidPhoto as error:
                    flash(f"{label} photo. {error}", "error")
                    return render_queue(), 400
        if not photos:
            flash("Choose at least one photo to create a return.", "error")
            return render_queue(), 400
        case_id = f"RT-{uuid4().hex[:10].upper()}"
        store.add_case(case_id, item, photos)
        flash("Return added to the review queue.", "success")
        return redirect(url_for("case_view", case_id=case_id), code=303)

    @app.post("/returns/<case_id>/analyze")
    def analyze(case_id):
        case, _ = store.get_case(case_id)
        if case is None:
            abort(404)
        if provider is None:
            flash("Set OPENAI_API_KEY and restart to enable analysis.", "error")
            return redirect(url_for("case_view", case_id=case_id), code=303)
        token = secrets.token_hex(16)
        if not store.claim_analysis(case_id, token):
            flash("This return is already assessed, reviewed, or being analyzed.", "error")
            return redirect(url_for("case_view", case_id=case_id), code=303)

        report = None
        try:
            report = provider.inspect(store.get_photos(case_id))
        except VisionUnavailable:
            flash("Analysis was unavailable. Your photos are saved. Retry or review them manually.", "error")
        finally:
            saved = store.finish_analysis(case_id, token, report)
        if report and saved:
            flash("AI observations are ready for review.", "success")
        elif report:
            flash("This case changed during analysis. Check its current review state.", "error")
        return redirect(url_for("case_view", case_id=case_id), code=303)

    @app.post("/returns/<case_id>/review")
    def review(case_id):
        case, _ = store.get_case(case_id)
        if case is None:
            abort(404)
        outcome = request.form.get("outcome", "")
        note = request.form.get("note", "").strip()
        if outcome not in OUTCOMES or len(note) > 500:
            flash("Choose an outcome and keep notes under 500 characters.", "error")
        elif store.record_review(case_id, outcome, note):
            flash("Review saved.", "success")
        else:
            flash("A review has already been recorded for this return.", "error")
        return redirect(url_for("case_view", case_id=case_id), code=303)

    return app
