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

import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/prescriptionModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

class MedicineCourseProvider extends BaseProvider {
  // // final int _totalCourses = 0;
  // int get totalCourses => _totalCourses;

  List<Prescription> _courseList = [];
  List<Prescription> get courseList => _courseList;
  set setCourseList(List listData) {
    _courseList = listData;
  }

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _courseList = [];
  }

  Future<void> fetchData() async {
    try {
      final userId = LocatorService.userProvider().user.uid;

      final result = await FirestoreService.getUserPrescriptions(userId);

      if (result.isEmpty) {
        log('No data', name: 'MCP');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      }

      final list = <Prescription>[];
      for (final elem in result) {
        final obj = {'uid': elem.id, ...elem.data()};

        final Prescription prescription = Prescription.fromMap(obj);
        list.add(prescription);
      }

      // Sort them in desc order.
      list.sort((b, a) {
        return a.timestamp.compareTo(b.timestamp);
      });

      _courseList = list;
      notifyState(ViewState.DATA);
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }
}
