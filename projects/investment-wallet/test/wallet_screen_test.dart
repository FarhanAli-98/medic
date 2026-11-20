import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:investment_wallet/main.dart';

void main() {
  testWidgets('add demo funds through the desktop wallet', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1140, 850));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const InvestmentWalletApp());
    expect(
      tester.widget<Text>(find.byKey(const Key('total-wallet-value'))).data,
      'AED 20,534.00',
    );

    await tester.tap(find.byKey(const Key('add-demo-funds')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('wallet-amount')), '1.01');
    await tester.tap(find.byKey(const Key('submit-wallet-action')));
    await tester.pumpAndSettle();

    expect(find.text('AED 4,251.01'), findsOneWidget);
    expect(find.text('AED 20,535.01'), findsOneWidget);
    expect(find.text('6 transactions · newest first'), findsOneWidget);
  });

  testWidgets('allocation surfaces validation and accepts an exact balance', (
    tester,
  ) async {
    await tester.pumpWidget(const InvestmentWalletApp());
    final holding = find.byTooltip('Allocate to Harbor Government Sukuk');
    await tester.ensureVisible(holding);
    await tester.tap(holding);
    await tester.pumpAndSettle();

    final amount = find.byKey(const Key('wallet-amount'));
    final confirm = find.byKey(const Key('submit-wallet-action'));
    await tester.enterText(amount, '4.251');
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('Enter AED 0.01 to 1,000,000.00.'), findsOneWidget);

    await tester.enterText(amount, '4250.01');
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('This exceeds your available balance.'), findsOneWidget);

    await tester.enterText(amount, '4250.00');
    await tester.tap(confirm);
    await tester.pumpAndSettle();
    expect(find.text('AED 0.00'), findsOneWidget);
    expect(
      tester.widget<Text>(find.byKey(const Key('total-wallet-value'))).data,
      'AED 20,534.00',
    );
    expect(find.text('6 transactions · newest first'), findsOneWidget);
  });

  testWidgets('fits a phone viewport with large text', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    tester.platformDispatcher.textScaleFactorTestValue = 1.8;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await tester.pumpWidget(const InvestmentWalletApp());
    await tester.pumpAndSettle();
    expect(find.text('Your investment wallet'), findsOneWidget);
    await tester.ensureVisible(find.byKey(const Key('allocate-funds')));
    await tester.tap(find.byKey(const Key('allocate-funds')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('investment-picker')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
