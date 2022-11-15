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

import 'dart:convert';
import 'dart:developer';

import 'package:currency_picker/currency_picker.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/addressModel.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/models/paymentModel.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

///
/// ## Description
///
/// Provider that handles `Doctor` data in the state.
/// Cares about the Doctor data after it has been loaded into memory from the server.
///
class DoctorProvider with ChangeNotifier {
  // Set the doctorId for the app when the Doctor signup or login.
  String _doctorId = '';
  String currency = '';
  String get doctorId => _doctorId;
  void setdoctorId(String value) {
    _doctorId = value;
    log(value, name: 'DoctorProvider setdoctorId');
  }

  Doctor _doctor;
  Doctor get doctor => _doctor;

  void setDoctor(Map<String, dynamic> json) {
    _doctor = Doctor.fromMap(json);
  }

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _doctorId = '';
    _doctor = null;
  }

  Future<bool> fetchDoctorData(String id) async {
    try {
      log('Fetching doctor data for id $id', name: 'DP');
      final Map<String, dynamic> result =
          await FirestoreService.getDoctorInfo(id);
      if (result != null && result.keys.isNotEmpty) {
        setDoctor(result);

        // Initialize the push notification token stream to track refreshed token
        LocatorService.pushNotificationService().setRefreshedTokenFor(
          doctorId: result['uid'],
        );
        fetchCurrency();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(), name: 'DP');
      return false;
    }
  }

  void updateName(String value) {
    _doctor.name = value;
    notifyListeners();
  }

  void updateImage(String url) {
    _doctor.imageUrl = url;
    notifyListeners();
  }

  void updateDoctorData(Map<String, dynamic> data) {
    final tempDoctor = _doctor.toJson();
    data.forEach((key, value) {
      tempDoctor[key] = value;
    });
    // set Doctor again
    setDoctor(tempDoctor);
    notifyListeners();
  }

  void updateDoctorAddress(Map<String, dynamic> data) {
    _doctor.address = Address.fromMap(data);
    notifyListeners();
  }

  void updatePayment(Map<String, dynamic> data) {
    _doctor.payment = Payment.fromMap(data);
    notifyListeners();
  }

  //Currency

  Future<void> storeCurrency(Currency c) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    currency = '${c.name} : ${c.symbol}';
    prefs.setString('currency', jsonEncode(c));
    notifyListeners();
  }

  Future<void> fetchCurrency() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String selectedCurrency = prefs.getString('currency');
    if (selectedCurrency != null) {
      final Currency c = Currency.from(json: jsonDecode(selectedCurrency));
      currency = '${c.name} : ${c.symbol}';
    } else {
      currency = 'United States Dollar : \$';
    }
    log(currency, name: 'DoctorProvider Currency');
  }
}
