# Nearby Offers Recommender
AI-assisted portfolio lab, November 2026. A hybrid retrieval/ranking experiment for a synthetic location-aware offers catalog, inspired by the earlier geofencing FYP. Filter active offers by Haversine distance and availability, rank candidates using a learned pairwise logistic preference model, and compare with distance-only and heuristic ranking. Evaluate held-out users, separately for returning and cold-start users, using NDCG@5 and recall@5. Relevance labels are simulated, not observed clicks; this is not evidence of production recommendation performance.
```sh
python -m pip install -r ../ai-lab-requirements.txt
python evaluate.py
python -m unittest discover -v
```
Architecture: domain objects and candidate selection, learned ranking, offline evaluation. No external data or API keys.