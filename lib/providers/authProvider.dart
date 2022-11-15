// Copyright (c) 2020 Aniket Malik [aniketmalikwork@gmail.com]
// All Rights Reserved.
//
// NOTICE: All information contained herein is, and remains the
// property of Aniket Malik. The intellectual and technical concepts
// contained herein are proprietary to Aniket Malik and are protected
// by trade secret or copyright law.
//
// Dissemination of this information or reproduction of this material
// is strictly forbidden unless prior written permission is obtained from
// Aniket Malik.

import 'package:flutter/foundation.dart';

class UIAuthProvider with ChangeNotifier {
  /// Loading indicator when a social login is performing some work.
  bool _socialLoginLoading = false;
  bool get socialLoginLoading => _socialLoginLoading;

  /// Change the social login loading flag to update the UI
  void changeSocialLoginLoadingStatus(bool value) {
    _socialLoginLoading = value;
    notifyListeners();
  }
}
