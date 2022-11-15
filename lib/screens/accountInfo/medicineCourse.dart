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
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/models/prescriptionModel.dart';
import 'package:doctor_consultation/providers/medicineCourseProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/shared/infoSectionContainer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MedicineCourse extends StatelessWidget {
  const MedicineCourse({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.medicineCourse),
      ),
      body: ChangeNotifierProvider.value(
        value: LocatorService.medicineCourseProvider(),
        child: ViewStateSelector<MedicineCourseProvider>(
          getData: () => LocatorService.medicineCourseProvider().fetchData(),
          child: Selector<MedicineCourseProvider, List>(
            selector: (context, d) => d.courseList,
            builder: (context, list, _) {
              return RefreshIndicator(
                color: Colors.black,
                onRefresh: () =>
                    LocatorService.medicineCourseProvider().fetchData(),
                child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  itemCount: list.length,
                  itemBuilder: (context, i) {
                    return MedicineCourseListItem(
                      prescription: list[i],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MedicineCourseListItem extends StatelessWidget {
  const MedicineCourseListItem({Key key, @required this.prescription})
      : super(key: key);

  final Prescription prescription;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return GestureDetector(
      onTap: () => UiController.showModal(
        context,
        PrescriptionInfoModal(prescription: prescription),
      ),
      child: Container(
        margin: const EdgeInsets.all(10.0),
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: _theme.accentColor,
          borderRadius: ThemeGuide.borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(230, 230, 230, 1),
              blurRadius: 5,
              spreadRadius: 2,
              offset: Offset(0.0, 3.0),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      prescription.title ?? '',
                      style: _theme.textTheme.headline6,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${AppStrings.tablets}: ',
                          style: _theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black38,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            prescription.tablets ?? '',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${AppStrings.dose}: ',
                          style: _theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black38,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            prescription.dose ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${AppStrings.remarks}: ',
                          style: _theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black38,
                          ),
                        ),
                        Flexible(
                          child: Text(
                            prescription.remarks ?? '',
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: _theme.textTheme.bodyText1.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          '${AppStrings.date}: ',
                          style: _theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black38,
                          ),
                        ),
                        Text(
                          prescription.appointmentDate ?? '',
                          style: _theme.textTheme.caption.copyWith(
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PrescriptionInfoModal extends StatefulWidget {
  const PrescriptionInfoModal({
    Key key,
    @required this.prescription,
  }) : super(key: key);

  final Prescription prescription;

  @override
  _PrescriptionInfoModalState createState() => _PrescriptionInfoModalState();
}

class _PrescriptionInfoModalState extends State<PrescriptionInfoModal> {
  String errorText = '';

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.prescription),
      ),
      body: ListView(
        padding: ThemeGuide.padding20,
        physics: const BouncingScrollPhysics(),
        children: <Widget>[
          SectionContainer(
            title: AppStrings.tablets,
            text: widget.prescription.tablets,
          ),
          const SizedBox(
            height: 20,
          ),
          SectionContainer(
            title: AppStrings.dose,
            text: widget.prescription.dose,
          ),
          const SizedBox(
            height: 20,
          ),
          SectionContainer(
            title: AppStrings.remarks,
            text: widget.prescription.remarks,
          ),
          const SizedBox(
            height: 20,
          ),
          SectionContainer(
            title: AppStrings.date,
            text: widget.prescription.appointmentDate,
          ),
          const SizedBox(
            height: 20,
          ),
          if (isLoading)
            const CustomLoader()
          else
            CupertinoButton.filled(
              child: const Text('${AppStrings.about} ${AppStrings.doctor}'),
              onPressed: () => getDoctorInfo(),
            ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Future<void> getDoctorInfo() async {
    setState(() {
      isLoading = !isLoading;
    });

    try {
      final result =
          await FirestoreService.getDoctorInfo(widget.prescription.doctorId);

      if (result.isNotEmpty) {
        final doctor = Doctor.fromMap(result);
        NavigationController.navigator.push(
          Routes.doctorInfo,
          arguments: DoctorInfoArguments(doctor: doctor,isDoctor: true),
        );
        setState(() {
          isLoading = !isLoading;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = !isLoading;
        errorText = e.toString();
      });
    }
  }
}
