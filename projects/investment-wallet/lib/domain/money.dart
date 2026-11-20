/// AED amounts represented by integer fils.
final class Money implements Comparable<Money> {
  const Money(this.minorUnits);

  static const zero = Money(0);
  static const maxInput = Money(100000000);
  static final _inputPattern = RegExp(r'^([0-9]{1,7})(?:\.([0-9]{1,2}))?$');

  final int minorUnits;

  static Money? tryParseInput(String input) {
    final match = _inputPattern.firstMatch(input.trim());
    if (match == null) return null;
    final whole = int.parse(match.group(1)!);
    final fraction = int.parse((match.group(2) ?? '').padRight(2, '0'));
    final amount = Money(whole * 100 + fraction);
    return amount > maxInput ? null : amount;
  }

  Money operator +(Money other) => Money(minorUnits + other.minorUnits);
  Money operator -(Money other) => Money(minorUnits - other.minorUnits);

  bool operator >(Money other) => compareTo(other) > 0;
  bool operator <(Money other) => compareTo(other) < 0;

  @override
  int compareTo(Money other) => minorUnits.compareTo(other.minorUnits);

  String format() {
    final absolute = minorUnits.abs();
    final whole = (absolute ~/ 100).toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+$)'),
      (match) => '${match[1]},',
    );
    final decimal = (absolute % 100).toString().padLeft(2, '0');
    return '${minorUnits < 0 ? '−' : ''}AED $whole.$decimal';
  }

  @override
  bool operator ==(Object other) =>
      other is Money && minorUnits == other.minorUnits;

  @override
  int get hashCode => minorUnits.hashCode;
}
