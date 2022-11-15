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

import 'dart:async';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/shared/appointmentWidgets/statusSwitcher.dart';
import 'package:doctor_consultation/shared/widgets/bottomSheetDecorators.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// Container for the bottom sheet which for appointments.
///
class MoreOptions extends StatelessWidget {
  const MoreOptions({Key key, @required this.appointment}) : super(key: key);

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return BottomSheetContainer(
      child: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 1.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Center(child: BottomSheetTopNotch()),
              const SizedBox(height: 20),
              const Text(
                AppStrings.moreInfo,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              MoreInfoRowItem(
                label: AppStrings.id,
                value: appointment.uid,
              ),
              MoreInfoRowItem(
                label: AppStrings.date,
                value: appointment.createdAt,
              ),
              MoreInfoRowItem(
                label: AppStrings.title,
                value: appointment.title,
              ),
              const SizedBox(height: 20),
              _WritePrescriptionButton(appointment: appointment),
              const SizedBox(height: 20),
              StatusSwitcher(
                onPositive: () async {
                  await LocatorService.appointmentsProvider()
                      .changeAppointmentStatus(appointment.uid);
                  Navigator.of(context).pop();
                },
                onNegative: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WritePrescriptionButton extends StatelessWidget {
  const _WritePrescriptionButton({
    Key key,
    @required this.appointment,
  }) : super(key: key);

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(50),
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: ListTile(
        leading: const Icon(
          Icons.assignment,
          color: Color(0xFF42A5F5),
          size: 26.0,
        ),
        title: const Text(
          AppStrings.writePrescription,
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.blue,
          size: 20,
        ),
        onTap: () => _writePrescription(appointment),
      ),
    );
  }

  static void _writePrescription(Appointment appointment) {
    NavigationController.navigator.pop();
    Timer(const Duration(milliseconds: 200), () {
      NavigationController.navigator.push(
        Routes.prescription,
        arguments: PrescriptionArguments(
          appointment: appointment,
        ),
      );
    });
  }
}
