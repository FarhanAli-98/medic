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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/providers/doctorsDataProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/shared/doctorListItem.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
/// ## `Description`
///
/// Screen to show the list of doctors available for the selected
/// format ( call, message, video call, etc ).
///
class DoctorsList extends StatelessWidget {
  const DoctorsList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.doctors),
      ),
      body: ChangeNotifierProvider.value(
        value: LocatorService.doctorDataProvider(),
        child: ViewStateSelector<DoctorDataProvider>(
          getData: () => LocatorService.doctorDataProvider().getDoctors(),
          child: ListContainer(),
        ),
      ),
    );
  }
}

///
/// ## `Description`
///
/// Widget to get the list of the data and display it using a Future.
/// It waits for the Future while displaying a loading indicator and
/// show the list when the Future is complete.
///

class ListContainer extends StatefulWidget {
  @override
  _ListContainerState createState() => _ListContainerState();
}

class _ListContainerState extends State<ListContainer> {
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
      await LocatorService.doctorDataProvider().getMoreDoctors();

      // const double edge = 50.0;
      // final double offsetFromBottom =
      //     _scrollController.position.maxScrollExtent -
      //         _scrollController.position.pixels;
      // if (offsetFromBottom < edge) {
      //   _scrollController.animateTo(
      //       _scrollController.offset - (edge - offsetFromBottom) + 20,
      //       duration: const Duration(milliseconds: 500),
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
    return Selector<DoctorDataProvider, List<Doctor>>(
      selector: (context, d) => d.doctorList,
      // shouldRebuild: (a, b) => true,
      builder: (context, list, _) {
        return RefreshIndicator(
          color: Colors.black,
          onRefresh: () => LocatorService.doctorDataProvider().getDoctors(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: list.length + 1,
            itemBuilder: (context, index) {
              if (index == list.length) {
                return _buildProgressIndicator();
              } else {
                return GestureDetector(
                  onTap: () => NavigationController.navigator.push(
                    Routes.doctorInfo,
                    arguments: DoctorInfoArguments(
                      doctor: list[index],
                      isDoctor: false
                      
                    ),
                  ),
                  child: DoctorListItem(
                    doctor: list[index],
                  ),
                );
              }
            },
            controller: _scrollController,
          ),
        );
      },
    );
  }
}
