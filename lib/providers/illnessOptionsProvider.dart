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

import 'dart:developer';

import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

/// Contains information about the full list of illness provided
/// in the application.
class IllnessOptionsProvider extends BaseProvider {
  List<String> _illnessList = [];
  List<String> get illnessList => _illnessList;

  /// Fetch the full list of illness offered
  Future<void> fetchIllnessData() async {
    log('Fetch illness', name: 'Illness Provider');
    try {
      final List<String> result = await FirestoreService.getIllnessList();

      if (result.isEmpty) {
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      }

      _illnessList = result;
      notifyState(ViewState.DATA);
    } catch (e) {
      log('Fetch illness error $e', name: 'Illness Provider');
      if (_illnessList.isEmpty) {
        notifyError(errorText: e.toString());
      }
    }
  }

  /// Route function
  void next() {
    NavigationController.navigator.pop();
    _routeTo();
  }

  /// set route to a screen specified
  /// Must be a navigation function.s
  Function _routeTo = () {};
  Function get routeTo => _routeTo;

  set setRouteTo(Function fun) {
    _routeTo = fun;
  }
}
