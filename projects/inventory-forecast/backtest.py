"""Rolling-origin evaluation on non-overlapping seven-day horizons."""
import json
import numpy as np
from forecast import generate, LagForecaster, seasonal_naive, reorder

def errors(actual,pred):
    actual,pred = np.asarray(actual),np.asarray(pred)
    absolute = np.abs(actual-pred)
    return {"mae": float(absolute.mean()),
            "wape": float(absolute.sum()/actual.sum()) if actual.sum() else None}

def evaluate(series, first=210, horizon=7):
    if first < 56 or horizon < 1 or first+horizon > len(series):
        raise ValueError("Invalid backtest bounds")
    actual, model, baseline = [],[],[]
    for origin in range(first,len(series)-horizon+1,horizon):
        history = series[:origin]
        model.extend(LagForecaster().fit(history).predict(horizon))
        baseline.extend(seasonal_naive(history,horizon))
        actual.extend(series[origin:origin+horizon])
    return {"origins": len(actual)//horizon, "gradient_boosting": errors(actual,model),
            "seasonal_naive": errors(actual,baseline)}

if __name__ == "__main__":
    data = generate()
    result = evaluate(data)
    future = LagForecaster().fit(data).predict()
    result["example_next_7_days"] = future.round(2).tolist()
    result["example_reorder_units"] = reorder(future,110,50,25)
    print(json.dumps(result,indent=2))
