import 'package:flutter_test/flutter_test.dart';
import 'package:investment_wallet/domain/money.dart';

void main() {
  group('Money', () {
    test('parses whole dirhams and decimal fils exactly', () {
      expect(Money.tryParseInput('10'), const Money(1000));
      expect(Money.tryParseInput(' 0.1 '), const Money(10));
      expect(Money.tryParseInput('0.01'), const Money(1));
      expect(Money.tryParseInput('1000000.00'), Money.maxInput);
      expect(
        Money.tryParseInput('0.10')! + Money.tryParseInput('0.20')!,
        const Money(30),
      );
    });

    test('rejects ambiguous and out-of-range amounts', () {
      for (final input in [
        '',
        '.',
        '1.',
        '1.001',
        '-1',
        '1,000',
        '1e2',
        '1000000.01',
      ]) {
        expect(Money.tryParseInput(input), isNull, reason: input);
      }
    });

    test('formats signs, digits, and trailing zeroes', () {
      expect(const Money(2053400).format(), 'AED 20,534.00');
      expect(const Money(7).format(), 'AED 0.07');
      expect(const Money(-100001).format(), '−AED 1,000.01');
    });
  });
}
