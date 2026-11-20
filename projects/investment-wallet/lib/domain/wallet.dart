import 'money.dart';

enum InvestmentKind { government, corporate, infrastructure }

final class Position {
  const Position({
    required this.id,
    required this.name,
    required this.kind,
    required this.principal,
    required this.marketValue,
  });

  final String id;
  final String name;
  final InvestmentKind kind;
  final Money principal;
  final Money marketValue;

  Position allocate(Money amount) => Position(
    id: id,
    name: name,
    kind: kind,
    principal: principal + amount,
    marketValue: marketValue + amount,
  );
}

enum TransactionKind { deposit, allocation }

final class WalletTransaction {
  const WalletTransaction({
    required this.kind,
    required this.description,
    required this.amount,
    required this.date,
  });

  final TransactionKind kind;
  final String description;
  final Money amount;
  final DateTime date;
}

enum WalletIssue { invalidAmount, insufficientFunds, unknownPosition }

final class Wallet {
  Wallet({
    required this.cash,
    required List<Position> positions,
    required List<WalletTransaction> transactions,
  }) : positions = List.unmodifiable(positions),
       transactions = List.unmodifiable(transactions);

  final Money cash;
  final List<Position> positions;
  final List<WalletTransaction> transactions;

  Money get invested => positions.fold(
    Money.zero,
    (value, position) => value + position.principal,
  );

  Money get marketValue => positions.fold(
    Money.zero,
    (value, position) => value + position.marketValue,
  );

  Money get gain => marketValue - invested;
  Money get totalValue => marketValue + cash;

  WalletIssue? checkAmount(Money amount, {String? positionId}) {
    if (amount.minorUnits <= 0 || amount > Money.maxInput) {
      return WalletIssue.invalidAmount;
    }
    if (positionId != null) {
      if (!positions.any((position) => position.id == positionId)) {
        return WalletIssue.unknownPosition;
      }
      if (amount > cash) return WalletIssue.insufficientFunds;
    }
    return null;
  }

  Wallet deposit(Money amount, DateTime date) {
    final issue = checkAmount(amount);
    if (issue != null) throw ArgumentError.value(issue, 'amount');

    return Wallet(
      cash: cash + amount,
      positions: positions,
      transactions: [
        WalletTransaction(
          kind: TransactionKind.deposit,
          description: 'Wallet top-up',
          amount: amount,
          date: date,
        ),
        ...transactions,
      ],
    );
  }

  Wallet allocate(String positionId, Money amount, DateTime date) {
    final issue = checkAmount(amount, positionId: positionId);
    if (issue != null) throw ArgumentError.value(issue, 'allocation');
    final selected = positions.firstWhere(
      (position) => position.id == positionId,
    );

    return Wallet(
      cash: cash - amount,
      positions: [
        for (final position in positions)
          if (position.id == positionId)
            position.allocate(amount)
          else
            position,
      ],
      transactions: [
        WalletTransaction(
          kind: TransactionKind.allocation,
          description: selected.name,
          amount: amount,
          date: date,
        ),
        ...transactions,
      ],
    );
  }
}
