# Transaction Review Lab

A reproducible Python and scikit-learn experiment in prioritizing synthetic wallet activity for manual review. It models a queue with limited capacity and shows which inputs raised or lowered each score.

## Run locally

From this directory with Python 3.11 or 3.12:

```sh
python -m venv .venv
. .venv/bin/activate
python -m pip install -r requirements.txt
python risk_review.py evaluate
python risk_review.py score --amount 1450 --typical 95 --attempts 7 --age 14 --new-device
python -m unittest -v
```

## Evaluation

The simulator produces 3,600 chronologically ordered records with gradual shifts in device novelty and attempt counts. Logistic regression and its scaler fit on the first 2,160 rows. A validation window sets the threshold for a 12% review budget. An untouched final window reports average precision, ROC AUC, queue rate, precision and recall. The contribution report expresses each scaled feature's effect on log-odds.

The labels are generated from an explicit simulation and every result applies to that simulation. A real transaction review model would need independently collected labels, time-aware monitoring, calibration and review by the team responsible for the decisions. This demo routes sample records to a queue and makes no transaction decisions.
