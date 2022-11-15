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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/developer/mock/doctorData.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

class DoctorDataProvider extends BaseProvider {
  // A single store to get all the doctors information
  final Map<String, Doctor> _allDoctors = {};
  void addToAllDoctors(Doctor obj) {
    _allDoctors[obj.uid] = obj;
  }

  // Data stores:
  List<Doctor> _doctorList = [];
  List<Doctor> get doctorList => _doctorList;

  // Ref to last DocumentSnapshot for query results
  DocumentSnapshot _lastDoctorDocument;

  // For home small list
  final List<Doctor> _doctorSmallList = [];
  List<Doctor> get doctorSmallList => _doctorSmallList;

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _allDoctors.clear();
    _doctorList = [];
    _lastDoctorDocument = null;
    _doctorSmallList.clear();
  }

  /// Get doctors for the full screen doctor list.
  Future<void> getDoctors() async {
    try {
      log('Fetch doc', name: 'Doctor data provider');
      final result = await FirestoreService.searchDoctors('');

      if (result.isEmpty && _doctorList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDoctorDocument = result.last;

        final list = <Doctor>[];
        for (final elem in result) {
          final Doctor obj = Doctor.fromMap(elem.data());
          list.add(obj);
        }
        _doctorList = list;
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future<void> getMoreDoctors() async {
    try {
      log('Searching more doctors', name: 'Doctor data provider');
      final result =
          await FirestoreService.searchMoreDoctors(_lastDoctorDocument, '');

      if (result.isEmpty && _doctorList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDoctorDocument = result.last ?? _lastDoctorDocument;

        for (final elem in result) {
          final Doctor obj = Doctor.fromMap(elem.data());
          _doctorList.add(obj);
        }

        notifyState(ViewState.DATA);
      }
    } catch (e) {
      if (_doctorList.isNotEmpty) {
        notifyState(ViewState.DATA);
      } else {
        log('Error $e');
        notifyError(errorText: e.toString());
      }
    }
  }

  /// Get doctors for small list in the home
  Future<void> getDoctorsSmallList() async {
    await Future.delayed(const Duration(seconds: 2));

    const result = MOCK_DOCTOR_DATA;
    final list = <Doctor>[];
    for (final elem in result) {
      final Doctor obj = Doctor.fromMap(elem);
      list.add(obj);

      // add each doctor data to the map for later use
      addToAllDoctors(obj);
    }
    _doctorSmallList.addAll(list);
    notifyListeners();
  }
}
