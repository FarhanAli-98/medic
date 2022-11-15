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

import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/searchProvider.dart';

/// Takes care of the functions for search screen
@deprecated
abstract class SearchViewModel {
  static SearchProvider state() {
    return locator<SearchProvider>();
  }

  // search the data in firebase.
  static Future<void> searchDoctors() async {
    await state().searchDoctors();
  }

  // search the data in firebase.
  @deprecated
  static Future<void> searchMoreDoctors() async {
     await state().searchMoreDoctors(0);
    return [];
  }

  // search the data in firebase.
  static Future<void> searchHospitals() async {
    await state().searchHospitals();
  }

  // search the data in firebase.
  @deprecated
  static Future<void> searchMoreHospitals() async {
     await state().searchMoreHospitals(0);
    return [];
  }

  // set search term in the state
  static void setSearchTerm(String value) {
    state().setSearchTerm = value.toString().trim();
  }

  // set search filter in the state
  static void setFilter(SearchFilterType type) {
    state().setFilter = type;
  }
}
