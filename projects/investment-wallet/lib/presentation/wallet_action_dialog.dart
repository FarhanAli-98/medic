import 'package:material_ui/material_ui.dart';

import '../application/wallet_controller.dart';
import '../domain/money.dart';
import '../domain/wallet.dart';

class WalletActionDialog extends StatefulWidget {
  const WalletActionDialog({
    super.key,
    required this.controller,
    required this.isAllocation,
    this.initialPositionId,
  });

  final WalletController controller;
  final bool isAllocation;
  final String? initialPositionId;

  @override
  State<WalletActionDialog> createState() => _WalletActionDialogState();
}

class _WalletActionDialogState extends State<WalletActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _amount = TextEditingController();
  late String? _positionId = widget.initialPositionId;
  String? _error;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  String? _amountError(String? text) {
    final value = Money.tryParseInput(text ?? '');
    if (value == null || value == Money.zero) {
      return 'Enter AED 0.01 to 1,000,000.00.';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final amount = Money.tryParseInput(_amount.text)!;
    final issue = widget.controller.submit(amount, positionId: _positionId);
    if (issue == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _error = switch (issue) {
        WalletIssue.invalidAmount => 'Enter AED 0.01 to 1,000,000.00.',
        WalletIssue.insufficientFunds => 'This exceeds your available balance.',
        WalletIssue.unknownPosition => 'Choose an available investment.',
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.controller.wallet;
    final colors = Theme.of(context).colorScheme;

    return AlertDialog(
      title: Text(widget.isAllocation ? 'Allocate funds' : 'Add demo funds'),
      scrollable: true,
      content: SizedBox(
        width: 360,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.isAllocation
                    ? 'Available to allocate: ${wallet.cash.format()}'
                    : 'Add simulated cash to your wallet balance.',
              ),
              if (widget.isAllocation) ...[
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  key: const Key('investment-picker'),
                  initialValue: _positionId,
                  decoration: const InputDecoration(labelText: 'Investment'),
                  isExpanded: true,
                  items: [
                    for (final position in wallet.positions)
                      DropdownMenuItem(
                        value: position.id,
                        child: Text(
                          position.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                  onChanged: (value) => setState(() {
                    _positionId = value;
                    _error = null;
                  }),
                  validator: (value) =>
                      value == null ? 'Choose an investment.' : null,
                ),
              ],
              const SizedBox(height: 20),
              TextFormField(
                key: const Key('wallet-amount'),
                controller: _amount,
                autofocus: !widget.isAllocation,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(
                  labelText: 'Amount in AED',
                  hintText: '0.00',
                  prefixText: 'AED ',
                ),
                validator: _amountError,
                onChanged: (_) {
                  if (_error != null) setState(() => _error = null);
                },
                onFieldSubmitted: (_) => _submit(),
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Semantics(
                  liveRegion: true,
                  child: Text(_error!, style: TextStyle(color: colors.error)),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          key: const Key('submit-wallet-action'),
          onPressed: _submit,
          child: Text(widget.isAllocation ? 'Confirm allocation' : 'Add funds'),
        ),
      ],
    );
  }
}
