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

import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/searchProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/shared/doctorListItem.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchListSpecialityView extends StatefulWidget {
  @override
  _SearchListSpecialityViewState createState() =>
      _SearchListSpecialityViewState();
}

class _SearchListSpecialityViewState extends State<SearchListSpecialityView> {
  final ScrollController _scrollController = ScrollController();
  bool isPerformingRequest = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    _scrollController?.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _getMoreData();
    }
  }

  Future<void> _getMoreData() async {
    if (!isPerformingRequest) {
      setState(() => isPerformingRequest = true);
      // Gets more data
      await LocatorService.searchProvider().searchMoreDoctorsSpeciality();
      // double edge = 20.0;
      // double offsetFromBottom = _scrollController.position.maxScrollExtent -
      //     _scrollController.position.pixels;
      // if (offsetFromBottom < edge) {
      //   _scrollController.animateTo(
      //       _scrollController.offset - (edge - offsetFromBottom) + 20,
      //       duration: new Duration(milliseconds: 500),
      //       curve: Curves.easeOut);
      // }
      setState(() {
        isPerformingRequest = false;
      });
    }
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 200),
          opacity: isPerformingRequest ? 1.0 : 0.0,
          child: const CustomLoader(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ViewStateSelector<SearchProvider>(
      getData: () => LocatorService.searchProvider().searchDoctorsSpeciality(),
      child: Selector<SearchProvider, List>(
        selector: (context, d) => d.specialityDoctorList,
        builder: (context, list, _) {
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                return _buildProgressIndicator();
              } else {
                return GestureDetector(
                  onTap: () => NavigationController.navigator.push(
                    Routes.doctorInfo,
                    arguments: DoctorInfoArguments(doctor: list[index],isDoctor: false),
                  ),
                  child: DoctorListItem(
                    doctor: list[index],
                  ),
                );
              }
            },
            controller: _scrollController,
          );
        },
      ),
    );
  }
}
