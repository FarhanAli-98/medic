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

import 'package:doctor_consultation/developer/mock/appointmentsData.dart';
import 'package:doctor_consultation/developer/mock/searchListData.dart';

abstract class ApiService {
  // Get the data for appointments
  static Future<List<Map<String, dynamic>>> fetchAppointments(
      String uid) async {
    log('called API with uid: $uid');
    await Future.delayed(const Duration(seconds: 2));
    return MOCK_DATA_APPOINTMENTS;
  }

  // Get the data for search query
  static Future<List<Map<String, dynamic>>> searchDoctors(
      String searchTerm) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    print('From API Search - $searchTerm');
    await Future.delayed(const Duration(seconds: 2));
    return DOCTOR_LIST_DATA;
  }

  // Get the data for search query
  static Future<List<Map<String, dynamic>>> searchHospitals(
      String searchTerm) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    print('From API Search - $searchTerm');
    await Future.delayed(const Duration(seconds: 2));
    return HOSPITAL_LIST_DATA;
  }

  // Get the data for search query
  static Future<List<Map<String, dynamic>>> searchSpeciality(
      String searchTerm) async {
    if (searchTerm.isEmpty) {
      return null;
    }
    print('From API Search - $searchTerm');
    await Future.delayed(const Duration(seconds: 2));
    return [];
  }
}
