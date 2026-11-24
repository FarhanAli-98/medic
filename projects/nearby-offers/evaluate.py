"""Offline user-separated evaluation using graded synthetic relevance."""
import json
import numpy as np
from ranker import Offer, User, candidates, Ranker, heuristic

def simulate(seed=17):
    rng=np.random.default_rng(seed)
    offers=[Offer(i,31.5+rng.uniform(-.035,.035),74.35+rng.uniform(-.035,.035),
                  int(rng.integers(0,4)),float(rng.uniform(.05,.6)),bool(rng.random()>.12))
            for i in range(80)]
    sessions=[]
    for i in range(120):
        prefs=rng.dirichlet(np.ones(4)*.5)
        visible=() if i%4==0 else tuple(prefs)
        user=User(i,31.5+rng.uniform(-.012,.012),74.35+rng.uniform(-.012,.012),visible)
        items=[]
        for offer,d in candidates(user,offers):
            score=3*prefs[offer.category]+1.6*offer.discount-.23*d+rng.normal(0,.35)
            relevance=int(np.digitize(score,[.6,1.2,2.]))
            items.append((offer,d,relevance))
        sessions.append((user,items))
    return sessions[:80],sessions[80:]

def dcg(grades,k=5):
    return sum((2**g-1)/np.log2(i+2) for i,g in enumerate(grades[:k]))

def measures(grades,all_grades,k=5):
    ideal=dcg(sorted(all_grades,reverse=True),k)
    relevant=sum(g>=2 for g in all_grades)
    return (float(dcg(grades,k)/ideal) if ideal else 0.,
            sum(g>=2 for g in grades[:k])/relevant if relevant else 0.)

def evaluate():
    train,test=simulate()
    ranker=Ranker().fit(train)
    output={}
    methods={"learned":ranker.rank,"distance":lambda u,items:sorted(items,key=lambda x:x[1]),
             "heuristic":heuristic}
    for group in ("returning","cold_start"):
        output[group]={}
        selected=[(u,items) for u,items in test if bool(u.preferences)==(group=="returning")]
        for name,method in methods.items():
            metrics=[]
            for user,items in selected:
                lookup={o.id:r for o,d,r in items}
                ranked=method(user,[(o,d) for o,d,r in items])
                metrics.append(measures([lookup[o.id] for o,d in ranked],list(lookup.values())))
            averages=np.mean(metrics,axis=0)
            output[group][name]={"ndcg_at_5":float(averages[0]),"recall_at_5":float(averages[1]),"users":len(selected)}
    return output

if __name__=="__main__":
    print(json.dumps(evaluate(),indent=2))
