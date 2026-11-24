"""Chronological quantile regression and split conformal ETA experiment."""
from dataclasses import dataclass
import json
import math
import numpy as np
from sklearn.ensemble import GradientBoostingRegressor

@dataclass(frozen=True)
class Window:
    x: np.ndarray
    y: np.ndarray

def simulate(n=2400, seed=21):
    if n < 100:
        raise ValueError("At least 100 observations required")
    rng = np.random.default_rng(seed)
    t = np.arange(n) / n
    distance = rng.uniform(1, 25, n)
    traffic = rng.uniform(0, 1, n)
    stops = rng.integers(1, 6, n)
    rain = rng.binomial(1, .2, n)
    x = np.column_stack([distance, traffic, stops, rain])
    noise = rng.normal(0, 2 + .3 * distance + 4 * traffic)
    y = np.maximum(1, 8 + distance * (2.2 + traffic) + stops * 3
                   + rain * 5 + 3 * t + noise)
    a, b = int(n * .6), int(n * .8)
    return Window(x[:a], y[:a]), Window(x[a:b], y[a:b]), Window(x[b:], y[b:])

def finite_quantile(scores, alpha):
    scores = np.asarray(scores, dtype=float)
    if scores.ndim != 1 or not len(scores) or not np.isfinite(scores).all() or not 0 < alpha < 1:
        raise ValueError("Invalid calibration scores or alpha")
    k = math.ceil((len(scores) + 1) * (1 - alpha))
    return float(np.sort(scores)[k-1]) if k <= len(scores) else float("inf")

class ETAIntervals:
    def __init__(self, alpha=.1):
        if not 0 < alpha < 1:
            raise ValueError("alpha must be between zero and one")
        self.alpha = alpha
        self.models = [GradientBoostingRegressor(loss="quantile", alpha=q,
            n_estimators=100, max_depth=3, random_state=42)
            for q in (alpha/2, .5, 1-alpha/2)]
        self.radius = None

    def fit(self, train):
        for model in self.models:
            model.fit(train.x, train.y)
        self.radius = None
        return self

    def raw(self, x):
        a, mid, b = (m.predict(x) for m in self.models)
        lo, hi = np.minimum(a, b), np.maximum(a, b)
        return lo, np.clip(mid, lo, hi), hi

    def calibrate(self, window):
        lo, _, hi = self.raw(window.x)
        scores = np.maximum(0, np.maximum(lo-window.y, window.y-hi))
        self.radius = finite_quantile(scores, self.alpha)
        return self

    def predict(self, x):
        if self.radius is None:
            raise RuntimeError("Calibrate before predicting")
        lo, mid, hi = self.raw(x)
        return np.maximum(0, lo-self.radius), np.maximum(0, mid), hi+self.radius

def metrics(y, lo, mid, hi):
    return {"coverage": float(np.mean((y >= lo) & (y <= hi))),
            "mean_width_minutes": float(np.mean(hi-lo)),
            "median_absolute_error": float(np.median(np.abs(y-mid)))}

def experiment():
    train, cal, test = simulate()
    model = ETAIntervals().fit(train).calibrate(cal)
    mid = float(np.median(train.y))
    width = finite_quantile(np.abs(cal.y-mid), .1)
    pred = np.full(len(test.y), mid)
    return {"dataset": "synthetic", "sizes": [len(w.y) for w in (train,cal,test)],
            "quantile_conformal": metrics(test.y,*model.predict(test.x)),
            "historical_baseline": metrics(test.y,np.maximum(0,pred-width),pred,pred+width)}

if __name__ == "__main__":
    print(json.dumps(experiment(), indent=2))
