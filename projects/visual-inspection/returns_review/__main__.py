from .app import create_app
from .config import Settings

settings = Settings.from_environment()
create_app(settings).run(host="127.0.0.1", port=settings.port, debug=False)
