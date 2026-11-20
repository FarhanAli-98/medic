import 'package:flutter/foundation.dart';

import '../domain/money.dart';
import '../domain/wallet.dart';

final class WalletController extends ChangeNotifier {
  WalletController(this._wallet, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  Wallet _wallet;
  final DateTime Function() _clock;

  Wallet get wallet => _wallet;

  WalletIssue? submit(Money amount, {String? positionId}) {
    final issue = _wallet.checkAmount(amount, positionId: positionId);
    if (issue != null) return issue;

    final date = _clock();
    _wallet = positionId == null
        ? _wallet.deposit(amount, date)
        : _wallet.allocate(positionId, amount, date);
    notifyListeners();
    return null;
  }
}
