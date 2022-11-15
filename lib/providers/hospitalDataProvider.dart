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
import 'package:doctor_consultation/models/hospitalModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';

class HospitalDataProvider extends BaseProvider {
  // A single store to get all the hospitals information
  // final Map<String, Hospital> _allHospitals = {};
  // void addToAllHospitals(Hospital obj) {
  //   _allHospitals[obj.uid] = obj;
  // }

  List<Hospital> _hospitalList = [];
  List<Hospital> get hospitalList => _hospitalList;

  DocumentSnapshot _lastDocument;

  // For home small hospital list
  final List<Hospital> _hospitalSmallList = [];
  List<Hospital> get hospitalSmallList => _hospitalSmallList;

  /// Get doctors for the full screen doctor list.
  Future<void> getHospitals() async {
    try {
      final result = await FirestoreService.getHospitals();
      //log('Fetch doc ${result.toString()} ', name: 'HDP');

      if (result.isEmpty) {
        // if (result.isEmpty && _hospitalList.isEmpty) {
        log('No data in Hospitals');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDocument = result.last;

        final list = <Hospital>[];
        for (final elem in result) {
          final Hospital obj = Hospital.fromMap(elem.data());
          list.add(obj);
        }
        _hospitalList = list;
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future<void> getMoreHospitals() async {
    try {
      log('Searching more doctors', name: 'Doctor data provider');
      final result = await FirestoreService.getMoreHospitals(_lastDocument);

      if (result.isEmpty && _hospitalList.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // set the last document reference
        _lastDocument = result.last ?? _lastDocument;

        for (final elem in result) {
          final Hospital obj = Hospital.fromMap(elem.data());
          _hospitalList.add(obj);
        }
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      if (_hospitalList.isNotEmpty) {
        notifyState(ViewState.DATA);
      } else {
        log('Error $e');
        notifyError(errorText: e.toString());
      }
    }
  }

  /// Get hospitals for small list in the home
  Future<void> getHospitalsSmallList() async {
    // This will get the hospitals
    await getHospitals();

    // now add them to the small blogs list and notifylisteners
    if (_hospitalList.length > 6) {
      for (var i = 0; i < 5; i++) {
        _hospitalSmallList.add(_hospitalList[i]);
      }
    } else {
      _hospitalList.forEach(addToSmallList);
    }
    notifyListeners();
  }

  //***********************************************************
  //  Helper functions to support the main functions
  //***********************************************************

  void addToSmallList(Hospital element) {
    _hospitalSmallList.add(element);
  }
}
