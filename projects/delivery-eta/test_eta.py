import unittest
import numpy as np
from eta import simulate, ETAIntervals, finite_quantile, metrics

class ETATest(unittest.TestCase):
    def test_split(self):
        train, cal, test = simulate(200)
        self.assertEqual([len(w.y) for w in (train,cal,test)], [120,40,40])
        np.testing.assert_array_equal(train.x, simulate(200)[0].x)
    def test_quantile(self):
        self.assertEqual(finite_quantile(np.arange(1,11), .2), 9)
    def test_interval(self):
        train, cal, test = simulate(300)
        model = ETAIntervals().fit(train)
        with self.assertRaises(RuntimeError):
            model.predict(test.x)
        lo, mid, hi = model.calibrate(cal).predict(test.x)
        self.assertTrue(np.all(lo <= mid) and np.all(mid <= hi))
        self.assertTrue(0 <= metrics(test.y,lo,mid,hi)["coverage"] <= 1)
