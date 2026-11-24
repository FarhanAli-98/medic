"""Hybrid geographic retrieval and pairwise learning-to-rank."""
from dataclasses import dataclass
from math import radians, sin, cos, asin, sqrt
import numpy as np
from sklearn.linear_model import LogisticRegression

@dataclass(frozen=True)
class Offer:
    id: int
    lat: float
    lon: float
    category: int
    discount: float
    active: bool

@dataclass(frozen=True)
class User:
    id: int
    lat: float
    lon: float
    preferences: tuple

def distance(lat1,lon1,lat2,lon2):
    dlat,dlon = radians(lat2-lat1),radians(lon2-lon1)
    a = sin(dlat/2)**2+cos(radians(lat1))*cos(radians(lat2))*sin(dlon/2)**2
    return 6371*2*asin(sqrt(min(1,max(0,a))))

def candidates(user, offers, radius=5):
    if radius < 0:
        raise ValueError("radius must be nonnegative")
    return [(o,d) for o in offers if o.active
            for d in [distance(user.lat,user.lon,o.lat,o.lon)] if d <= radius]

def feature(user,offer,d):
    preference = user.preferences[offer.category] if user.preferences else 0.
    return np.array([-d/5,offer.discount,preference],dtype=float)

class Ranker:
    def fit(self, sessions):
        x,y = [],[]
        for user, items in sessions:
            ordered = [(feature(user,o,d), rel) for o,d,rel in items]
            for i,(a,ra) in enumerate(ordered):
                for b,rb in ordered[i+1:]:
                    if ra == rb:
                        continue
                    delta = a-b
                    x.extend([delta,-delta])
                    y.extend([int(ra>rb),int(rb>ra)])
        if not x:
            raise ValueError("No preference pairs")
        self.model = LogisticRegression(fit_intercept=False, max_iter=500).fit(x,y)
        return self

    def rank(self,user,items):
        return sorted(items,key=lambda pair: (-float(feature(user,*pair) @ self.model.coef_[0]),pair[0].id))

def heuristic(user,items):
    return sorted(items,key=lambda pair: (-float(feature(user,*pair) @ np.array([.5,.4,.7])),pair[0].id))
