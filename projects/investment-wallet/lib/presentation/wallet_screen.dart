import 'package:material_ui/material_ui.dart';

import '../application/wallet_controller.dart';
import '../domain/wallet.dart';
import 'wallet_action_dialog.dart';

const _ink = Color(0xff193631);
const _olive = Color(0xff55625b);
const _hero = Color(0xff173e38);
const _line = Color(0xffdbe3d9);
const _mint = Color(0xffceebd9);

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required this.controller});

  final WalletController controller;

  Future<void> _showAction(
    BuildContext context, {
    required bool allocation,
    String? positionId,
  }) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => WalletActionDialog(
        controller: controller,
        isAllocation: allocation,
        initialPositionId: positionId,
      ),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            allocation ? 'Demo allocation recorded.' : 'Demo funds added.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, child) {
            final wallet = controller.wallet;
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1060),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandHeader(),
                      const SizedBox(height: 32),
                      Semantics(
                        header: true,
                        child: Text(
                          'Your investment wallet',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: _ink,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.8,
                              ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Available cash, sukuk holdings, and recent activity',
                        style: TextStyle(color: _olive),
                      ),
                      const SizedBox(height: 20),
                      _BalanceCard(
                        wallet: wallet,
                        addFunds: () => _showAction(context, allocation: false),
                        allocate: () => _showAction(context, allocation: true),
                      ),
                      const SizedBox(height: 20),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final holdings = _HoldingsPanel(
                            wallet: wallet,
                            select: (id) => _showAction(
                              context,
                              allocation: true,
                              positionId: id,
                            ),
                          );
                          final activity = _ActivityPanel(wallet: wallet);
                          if (constraints.maxWidth < 780) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                holdings,
                                const SizedBox(height: 16),
                                activity,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 6, child: holdings),
                              const SizedBox(width: 16),
                              Expanded(flex: 5, child: activity),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Fictional holdings and simulated funds. Changes last for this session.',
                        style: TextStyle(color: _olive),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 20,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: _hero,
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.pie_chart_outline_rounded, color: _mint),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: Text(
                'Crescent Ledger',
                style: Theme.of(context).textTheme.titleLarge
                    ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        const Text('Portfolio demo', style: TextStyle(color: _olive)),
      ],
    );
  }
}

class _BalanceCard extends StatelessWidget {
  const _BalanceCard({
    required this.wallet,
    required this.addFunds,
    required this.allocate,
  });

  final Wallet wallet;
  final VoidCallback addFunds;
  final VoidCallback allocate;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [_hero, Color(0xff205b4e)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Total wallet value',
            style: TextStyle(color: _mint, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 4),
          Text(
            wallet.totalValue.format(),
            key: const Key('total-wallet-value'),
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 34,
            runSpacing: 12,
            children: [
              _BalanceMetric(
                label: 'Available balance',
                value: wallet.cash.format(),
              ),
              _BalanceMetric(
                label: 'Holdings value',
                value: wallet.marketValue.format(),
              ),
              _BalanceMetric(
                label: 'Unrealized gain',
                value: wallet.gain.format(),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                key: const Key('add-demo-funds'),
                onPressed: addFunds,
                style: FilledButton.styleFrom(
                  backgroundColor: _mint,
                  foregroundColor: _ink,
                ),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add demo funds'),
              ),
              OutlinedButton.icon(
                key: const Key('allocate-funds'),
                onPressed: allocate,
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: _mint),
                ),
                icon: const Icon(Icons.arrow_outward_rounded),
                label: const Text('Allocate funds'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BalanceMetric extends StatelessWidget {
  const _BalanceMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: '$label, $value',
      excludeSemantics: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: _mint)),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  const _Panel({
    required this.title,
    required this.subtitle,
    required this.child,
  });

  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border.all(color: _line),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            header: true,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(color: _ink, fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: _olive)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

extension on InvestmentKind {
  Color get color => switch (this) {
    InvestmentKind.government => const Color(0xff327e6a),
    InvestmentKind.corporate => const Color(0xff79613a),
    InvestmentKind.infrastructure => const Color(0xff58748a),
  };

  IconData get icon => switch (this) {
    InvestmentKind.government => Icons.account_balance_outlined,
    InvestmentKind.corporate => Icons.business_outlined,
    InvestmentKind.infrastructure => Icons.construction_rounded,
  };
}

class _HoldingsPanel extends StatelessWidget {
  const _HoldingsPanel({required this.wallet, required this.select});

  final Wallet wallet;
  final ValueChanged<String> select;

  @override
  Widget build(BuildContext context) {
    final total = wallet.marketValue.minorUnits;
    return _Panel(
      title: 'Portfolio holdings',
      subtitle:
          '${wallet.positions.length} investments · ${wallet.invested.format()} principal',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (total > 0) ...[
            ExcludeSemantics(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: SizedBox(
                  height: 8,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final position in wallet.positions)
                        if (position.marketValue.minorUnits > 0)
                          Expanded(
                            flex: position.marketValue.minorUnits,
                            child: ColoredBox(color: position.kind.color),
                          ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          for (final position in wallet.positions) ...[
            _HoldingRow(
              position: position,
              total: total,
              allocate: () => select(position.id),
            ),
            if (position != wallet.positions.last) const Divider(color: _line),
          ],
        ],
      ),
    );
  }
}

class _HoldingRow extends StatelessWidget {
  const _HoldingRow({
    required this.position,
    required this.total,
    required this.allocate,
  });

  final Position position;
  final int total;
  final VoidCallback allocate;

  @override
  Widget build(BuildContext context) {
    final share = total == 0
        ? '0'
        : (100 * position.marketValue.minorUnits / total).toStringAsFixed(1);
    final color = position.kind.color;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemIcon(icon: position.kind.icon, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  position.name,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${position.marketValue.format()} · $share% of holdings',
                  style: const TextStyle(color: _olive),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Allocate to ${position.name}',
            onPressed: allocate,
            icon: const Icon(Icons.add_circle_outline, color: _ink),
          ),
        ],
      ),
    );
  }
}

class _ActivityPanel extends StatelessWidget {
  const _ActivityPanel({required this.wallet});

  final Wallet wallet;

  @override
  Widget build(BuildContext context) {
    return _Panel(
      title: 'Recent activity',
      subtitle: '${wallet.transactions.length} transactions · newest first',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final transaction in wallet.transactions) ...[
            _TransactionRow(transaction: transaction),
            if (transaction != wallet.transactions.last)
              const Divider(color: _line),
          ],
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  const _TransactionRow({required this.transaction});

  final WalletTransaction transaction;

  @override
  Widget build(BuildContext context) {
    final isDeposit = transaction.kind == TransactionKind.deposit;
    final date = MaterialLocalizations.of(context)
        .formatMediumDate(transaction.date);
    final sign = isDeposit ? '+' : '−';
    final color = isDeposit ? const Color(0xff286750) : _ink;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ItemIcon(
            icon: isDeposit
                ? Icons.south_west_rounded
                : Icons.north_east_rounded,
            color: color,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: const TextStyle(
                    color: _ink,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 8,
                  runSpacing: 2,
                  children: [
                    Text(date, style: const TextStyle(color: _olive)),
                    Semantics(
                      label:
                          '${isDeposit ? 'Deposit' : 'Allocation'}, ${transaction.amount.format()}',
                      excludeSemantics: true,
                      child: Text(
                        '$sign${transaction.amount.format()}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemIcon extends StatelessWidget {
  const _ItemIcon({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color.withAlpha(25),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 21),
      ),
    );
  }
}
