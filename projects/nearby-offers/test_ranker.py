import unittest
from ranker import Offer, User, candidates, distance, Ranker
from evaluate import simulate, measures, evaluate

class RankTest(unittest.TestCase):
    def test_filter(self):
        u=User(1,0,0,())
        offers=[Offer(1,0,.01,0,.3,True),Offer(2,0,.01,0,.4,False),Offer(3,0,1,0,.4,True)]
        self.assertEqual([o.id for o,d in candidates(u,offers,5)],[1])
        self.assertAlmostEqual(distance(0,0,0,1),111.195,places=2)
    def test_metrics(self):
        self.assertEqual(measures([3,2,0],[3,2,0]),(1.,1.))
    def test_separated_users(self):
        train,test=simulate()
        self.assertFalse({u.id for u,_ in train}&{u.id for u,_ in test})
    def test_evaluation(self):
        result=evaluate()
        for group in result.values():
            for row in group.values():
                self.assertTrue(0<=row["ndcg_at_5"]<=1.00000001)
                self.assertTrue(0<=row["recall_at_5"]<=1)
