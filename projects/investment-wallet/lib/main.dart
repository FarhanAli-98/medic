import 'package:material_ui/material_ui.dart';

import 'application/wallet_controller.dart';
import 'data/demo_wallet.dart';
import 'presentation/wallet_screen.dart';

void main() => runApp(const InvestmentWalletApp());

class InvestmentWalletApp extends StatefulWidget {
  const InvestmentWalletApp({super.key});

  @override
  State<InvestmentWalletApp> createState() => _InvestmentWalletAppState();
}

class _InvestmentWalletAppState extends State<InvestmentWalletApp> {
  late final WalletController _controller = WalletController(
    createDemoWallet(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = ColorScheme.fromSeed(
      seedColor: const Color(0xff20564d),
      surface: const Color(0xfffbfcf8),
    );

    return MaterialApp(
      title: 'Crescent Ledger',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: colors,
        scaffoldBackgroundColor: const Color(0xffeef2eb),
        useMaterial3: true,
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
        ),
      ),
      home: WalletScreen(controller: _controller),
    );
  }
}
