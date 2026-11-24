# Delivery ETA with prediction intervals
AI-assisted portfolio lab, implemented November 2026. Runnable experiment on simulated delivery data; not a production model.
Train two gradient-boosted quantile regressors on earlier deliveries, calibrate intervals on a separate time window, then assess coverage, mean interval width and median absolute error on later deliveries. Compare against a historical median plus residual-width baseline. No real customer or GPS data.
```sh
python -m pip install -r ../ai-lab-requirements.txt
python eta.py
python -m unittest discover -v
```
The simulation includes a gradual time drift and heteroskedastic noise. Split conformal calibration does not guarantee nominal coverage under distribution shift. The CLI prints actual measured results, not precomputed claims. Architecture: batch experiment with explicit chronological fit/calibrate/test phases. Review code and results before presenting them as your own work.