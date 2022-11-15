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

/// Manages the state of the [view / screen] it is extended to.
/// There are three main states:
///
/// * Loading - shows a loading indicator
/// * Error - shows an error and reload button
/// * Data - show the data it was meant to be shown.
class BaseProvider with ChangeNotifier {
  // Initital value will be loading always.
  ViewState state = ViewState.LOADING;

  String _error = '';
  String get error => _error;

  /// Changes the state of the views
  /// Call this to notify the listners
  void notifyState(ViewState newState) {
    state = newState;
    notifyListeners();
  }

  void notifyError({String errorText = 'Something went wrong'}) {
    _error = errorText;
    notifyState(ViewState.ERROR);
  }

  void notifyLoading() {
    _error = '';
    notifyState(ViewState.LOADING);
  }
}

enum ViewState { ERROR, LOADING, DATA, NO_DATA_AVAILABLE }
