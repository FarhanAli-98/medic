import unittest

import numpy as np

from risk_review import Transaction, fit, review, simulate


class TransactionReviewTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        cls.model, cls.metrics = fit()

    def test_generator_is_repeatable(self):
        first = simulate(35)
        second = simulate(35)
        np.testing.assert_array_equal(first[0], second[0])
        np.testing.assert_array_equal(first[1], second[1])

    def test_ranker_beats_base_rate_on_held_out_window(self):
        self.assertEqual(self.metrics["train_rows"], 2160)
        self.assertEqual(self.metrics["test_rows"], 720)
        self.assertGreater(self.metrics["average_precision"], self.metrics["test_positive_rate"])
        self.assertLess(self.metrics["queue_rate"], 0.25)

    def test_explanation_reconstructs_model_output(self):
        sample = Transaction(1450, 95, 7, 14, True)
        output = review(self.model, self.metrics["threshold"], sample)
        intercept = self.model.named_steps["logisticregression"].intercept_[0]
        log_odds = intercept + sum(output["log_odds_contributions"].values())
        self.assertAlmostEqual(output["synthetic_review_score"], 1 / (1 + np.exp(-log_odds)), places=3)

    def test_review_queue_orders_unusual_activity_higher(self):
        ordinary = review(self.model, self.metrics["threshold"], Transaction(70, 100, 0, 900, False))
        unusual = review(self.model, self.metrics["threshold"], Transaction(1450, 95, 7, 14, True))
        self.assertEqual(ordinary["queue"], "standard queue")
        self.assertEqual(unusual["queue"], "manual review")
        self.assertGreater(unusual["synthetic_review_score"], ordinary["synthetic_review_score"])


if __name__ == "__main__":
    unittest.main()
