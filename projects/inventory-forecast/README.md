# Inventory demand forecasting
AI-assisted portfolio lab, November 2026. A small rolling-origin time-series experiment using synthetic daily demand, not M5 or real retailer records. An autoregressive gradient boosting model predicts seven daily values recursively. Each origin fits only earlier observations and compares a seasonal-naive baseline. Evaluate MAE and WAPE across non-overlapping horizons, then compute illustrative reorder quantities using on-hand stock, inbound units and a safety buffer.
```sh
python -m pip install -r ../ai-lab-requirements.txt
python backtest.py
python -m unittest discover -v
```
Architecture: independent data simulation, feature/model layer and backtesting orchestration. No demand censoring, stockout model or operational deployment. Safety buffer is a simple empirical heuristic, not a guaranteed service level.