"""Lag-based forecasting; all features refer only to prior observations."""
import numpy as np
from sklearn.ensemble import HistGradientBoostingRegressor

LAGS = (1,7,14,28)

def features(history, day):
    if len(history) < max(LAGS):
        raise ValueError("Insufficient lag history")
    return [history[-k] for k in LAGS] + [
        np.mean(history[-7:]), np.mean(history[-28:]),
        np.sin(2*np.pi*day/7), np.cos(2*np.pi*day/7), day/365]

def generate(n=420, seed=31):
    rng = np.random.default_rng(seed)
    day = np.arange(n)
    rate = np.maximum(1, 38 + .045*day + 12*np.sin(2*np.pi*day/7)
                      + 4*np.sin(2*np.pi*day/30))
    return rng.poisson(rate).astype(float)

class LagForecaster:
    def fit(self, history):
        history = np.asarray(history, dtype=float)
        if len(history) < 56 or not np.isfinite(history).all() or (history<0).any():
            raise ValueError("Require 56 finite nonnegative daily observations")
        x = [features(history[:i],i) for i in range(28,len(history))]
        self.estimator = HistGradientBoostingRegressor(max_iter=80, max_leaf_nodes=15,
                                                      random_state=42)
        self.estimator.fit(x, history[28:])
        self.history = history.tolist()
        return self

    def predict(self, horizon=7):
        if horizon < 1:
            raise ValueError("Positive horizon required")
        history = self.history.copy()
        predictions = []
        for _ in range(horizon):
            value = max(0.,float(self.estimator.predict([features(history,len(history))])[0]))
            history.append(value)
            predictions.append(value)
        return np.array(predictions)

def seasonal_naive(history, horizon=7):
    if len(history) < 7 or horizon < 1:
        raise ValueError("Require seven days and a positive horizon")
    return np.resize(np.asarray(history[-7:]), horizon)

def reorder(forecast, on_hand, inbound, buffer):
    if min(on_hand,inbound,buffer) < 0 or any(v < 0 for v in forecast):
        raise ValueError("Nonnegative inventory and forecasts required")
    return max(0,int(np.ceil(sum(forecast)+buffer-on_hand-inbound)))
