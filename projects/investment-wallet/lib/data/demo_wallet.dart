import '../domain/money.dart';
import '../domain/wallet.dart';

Wallet createDemoWallet() {
  final positions = [
    const Position(
      id: 'harbor',
      name: 'Harbor Government Sukuk',
      kind: InvestmentKind.government,
      principal: Money(800000),
      marketValue: Money(824000),
    ),
    const Position(
      id: 'orchard',
      name: 'Orchard Corporate Sukuk',
      kind: InvestmentKind.corporate,
      principal: Money(450000),
      marketValue: Money(471600),
    ),
    const Position(
      id: 'atlas',
      name: 'Atlas Infrastructure Sukuk',
      kind: InvestmentKind.infrastructure,
      principal: Money(320000),
      marketValue: Money(332800),
    ),
  ];
  return Wallet(
    cash: const Money(425000),
    positions: positions,
    transactions: [
      WalletTransaction(
        kind: TransactionKind.deposit,
        description: 'Wallet top-up',
        amount: const Money(250000),
        date: DateTime(2026, 11, 14),
      ),
      for (final (index, position) in positions.indexed)
        WalletTransaction(
          kind: TransactionKind.allocation,
          description: position.name,
          amount: position.principal,
          date: DateTime(2026, 11, 11 - index),
        ),
      WalletTransaction(
        kind: TransactionKind.deposit,
        description: 'Opening deposit',
        amount: const Money(1745000),
        date: DateTime(2026, 11, 4),
      ),
    ],
  );
}
