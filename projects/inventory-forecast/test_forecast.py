import unittest
import numpy as np
from forecast import features, generate, LagForecaster, seasonal_naive, reorder
from backtest import evaluate

class ForecastTest(unittest.TestCase):
    def test_lags(self):
        self.assertEqual(features(list(range(28)),28)[:4],[27,21,14,0])
    def test_baseline(self):
        np.testing.assert_array_equal(seasonal_naive(np.arange(10),9),[3,4,5,6,7,8,9,3,4])
    def test_predict(self):
        m = LagForecaster().fit(generate(90))
        result = m.predict(7)
        self.assertEqual(len(result),7)
        self.assertTrue((result>=0).all())
        np.testing.assert_array_equal(result,m.predict(7))
    def test_rolling(self):
        result = evaluate(generate(84),70)
        self.assertEqual(result["origins"],2)
        self.assertGreaterEqual(result["gradient_boosting"]["mae"],0)
    def test_reorder(self):
        self.assertEqual(reorder([10,20],8,4,5),23)
        self.assertEqual(reorder([10],20,0,0),0)
