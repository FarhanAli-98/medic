import 'package:flutter_test/flutter_test.dart';
import 'package:investment_wallet/application/wallet_controller.dart';
import 'package:investment_wallet/data/demo_wallet.dart';
import 'package:investment_wallet/domain/money.dart';
import 'package:investment_wallet/domain/wallet.dart';

void main() {
  test('seeded transaction history reconciles with available cash', () {
    final wallet = createDemoWallet();
    final netActivity = wallet.transactions.fold(
      Money.zero,
      (value, transaction) => transaction.kind == TransactionKind.deposit
          ? value + transaction.amount
          : value - transaction.amount,
    );
    expect(netActivity, wallet.cash);
    expect(wallet.invested, const Money(1570000));
    expect(wallet.gain, const Money(58400));
    expect(wallet.totalValue, const Money(2053400));
  });

  test('deposit updates balance and records the latest dated activity', () {
    final original = createDemoWallet();
    final date = DateTime(2026, 11, 20);
    final wallet = original.deposit(const Money(7), date);
    expect(wallet.cash, const Money(425007));
    expect(wallet.totalValue, original.totalValue + const Money(7));
    expect(wallet.transactions.first.kind, TransactionKind.deposit);
    expect(wallet.transactions.first.amount, const Money(7));
    expect(wallet.transactions.first.date, date);
    expect(wallet.positions, original.positions);
    expect(original.cash, const Money(425000));
  });

  test('allocating the full balance changes the mix and preserves value', () {
    final original = createDemoWallet();
    final wallet = original.allocate('harbor', original.cash, DateTime(2026));
    expect(wallet.cash, Money.zero);
    expect(wallet.positions.first.principal, const Money(1225000));
    expect(wallet.gain, original.gain);
    expect(wallet.totalValue, original.totalValue);
    expect(wallet.transactions.first.kind, TransactionKind.allocation);
    expect(wallet.transactions.first.description, 'Harbor Government Sukuk');
  });

  test('rejected actions do not modify the wallet or notify listeners', () {
    final original = createDemoWallet();
    final controller = WalletController(original, clock: () => DateTime(2026));
    addTearDown(controller.dispose);
    var notifications = 0;
    controller.addListener(() => notifications++);
    expect(controller.submit(Money.zero), WalletIssue.invalidAmount);
    expect(controller.submit(const Money(-1)), WalletIssue.invalidAmount);
    expect(
      controller.submit(const Money(100000001)),
      WalletIssue.invalidAmount,
    );
    expect(
      controller.submit(original.cash + const Money(1), positionId: 'harbor'),
      WalletIssue.insufficientFunds,
    );
    expect(
      controller.submit(const Money(1), positionId: 'missing'),
      WalletIssue.unknownPosition,
    );
    expect(controller.wallet, same(original));
    expect(notifications, 0);
    expect(controller.submit(const Money(1)), isNull);
    expect(notifications, 1);
  });
}
