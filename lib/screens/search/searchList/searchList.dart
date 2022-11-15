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

import 'package:doctor_consultation/providers/searchProvider.dart';
import 'package:doctor_consultation/screens/search/searchList/searchListViews/searchLIstSpecialityView.dart';
import 'package:doctor_consultation/screens/search/searchList/searchListViews/searchListDoctorView.dart';
import 'package:doctor_consultation/screens/search/searchList/searchListViews/searchListHospitalView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Selector<SearchProvider, SearchFilterType>(
      selector: (context, d) => d.filter,
      builder: (context, filterType, _) {
        return SearchListAdapter.build(filterType);
      },
    );
  }
}

abstract class SearchListAdapter {
  static Widget build(SearchFilterType type) {
    if (type == SearchFilterType.DOCTOR) {
      return SearchListDoctorView();
    }

    if (type == SearchFilterType.HOSPITAL) {
      return SearchListHospitalView();
    }

    if (type == SearchFilterType.SPECIALITY) {
      return SearchListSpecialityView();
    }

    return SearchListDoctorView();
  }
}