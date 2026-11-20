"""Synthetic transaction-review model with a time-ordered evaluation."""
import argparse
import json
from dataclasses import asdict, dataclass

import numpy as np
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import average_precision_score, precision_score, recall_score, roc_auc_score
from sklearn.pipeline import make_pipeline
from sklearn.preprocessing import StandardScaler


@dataclass(frozen=True)
class Transaction:
    amount_usd: float
    typical_amount_usd: float
    attempts_last_hour: int
    account_age_days: int
    new_device: bool

    def features(self):
        return [
            np.log1p(self.amount_usd / max(self.typical_amount_usd, 1)),
            np.log1p(self.attempts_last_hour),
            np.log1p(self.account_age_days),
            float(self.new_device),
        ]


FEATURES = ["Amount relative to typical", "Recent attempts", "Account age", "New device"]


def simulate(count=3600, seed=223):
    """Generate chronological examples; the final window has more unfamiliar devices."""
    random = np.random.default_rng(seed)
    rows, labels = [], []
    for index in range(count):
        baseline = float(random.lognormal(4.7, 0.7))
        ratio = float(random.lognormal(0.1, 0.9))
        drift = index / count
        row = Transaction(
            amount_usd=round(baseline * ratio, 2),
            typical_amount_usd=round(baseline, 2),
            attempts_last_hour=int(random.poisson(1.1 + 0.8 * drift)),
            account_age_days=int(random.exponential(320)),
            new_device=bool(random.random() < 0.10 + 0.13 * drift),
        )
        unusual_amount, repeated, age, device = row.features()
        log_odds = -4.9 + 1.15 * unusual_amount + 1.05 * repeated - 0.22 * age + 1.1 * device
        log_odds += 0.9 * (unusual_amount > 1.5 and row.new_device)
        rows.append(row)
        labels.append(int(random.random() < 1 / (1 + np.exp(-log_odds))))
    return np.array([row.features() for row in rows]), np.array(labels)


def fit():
    features, labels = simulate()
    train_end, validation_end = 2160, 2880
    model = make_pipeline(StandardScaler(), LogisticRegression(random_state=223))
    model.fit(features[:train_end], labels[:train_end])

    validation_scores = model.predict_proba(features[train_end:validation_end])[:, 1]
    # Set a review budget on validation, then measure how it transfers to future data.
    threshold = float(np.quantile(validation_scores, 0.88))
    test_scores = model.predict_proba(features[validation_end:])[:, 1]
    test_labels = labels[validation_end:]
    queued = test_scores >= threshold
    metrics = {
        "train_rows": train_end,
        "validation_rows": validation_end - train_end,
        "test_rows": len(test_labels),
        "test_positive_rate": float(test_labels.mean()),
        "average_precision": float(average_precision_score(test_labels, test_scores)),
        "roc_auc": float(roc_auc_score(test_labels, test_scores)),
        "queue_rate": float(queued.mean()),
        "queue_precision": float(precision_score(test_labels, queued, zero_division=0)),
        "queue_recall": float(recall_score(test_labels, queued, zero_division=0)),
        "threshold": threshold,
    }
    return model, metrics


def review(model, threshold, transaction):
    raw = np.asarray(transaction.features())
    scaled = model.named_steps["standardscaler"].transform([raw])[0]
    weights = model.named_steps["logisticregression"].coef_[0]
    score = float(model.predict_proba([raw])[0, 1])
    contributions = sorted(zip(FEATURES, scaled * weights), key=lambda pair: abs(pair[1]), reverse=True)
    return {
        "transaction": asdict(transaction),
        "synthetic_review_score": score,
        "queue": "manual review" if score >= threshold else "standard queue",
        "log_odds_contributions": {name: round(float(effect), 3) for name, effect in contributions},
    }


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    commands = parser.add_subparsers(dest="command", required=True)
    commands.add_parser("evaluate", help="Train and evaluate on separate chronological windows")
    scoring = commands.add_parser("score", help="Score one synthetic transaction")
    scoring.add_argument("--amount", type=float, required=True)
    scoring.add_argument("--typical", type=float, required=True)
    scoring.add_argument("--attempts", type=int, default=0)
    scoring.add_argument("--age", type=int, default=365)
    scoring.add_argument("--new-device", action="store_true")
    arguments = parser.parse_args()
    if arguments.command == "score":
        if not np.isfinite([arguments.amount, arguments.typical]).all():
            parser.error("amount and typical amount must be finite")
        if min(arguments.amount, arguments.typical) <= 0 or min(arguments.attempts, arguments.age) < 0:
            parser.error("amounts must be positive and counts must be nonnegative")

    model, metrics = fit()
    if arguments.command == "evaluate":
        output = metrics
    else:
        sample = Transaction(arguments.amount, arguments.typical, arguments.attempts, arguments.age, arguments.new_device)
        output = review(model, metrics["threshold"], sample)
    print(json.dumps(output, indent=2))


if __name__ == "__main__":
    main()
