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
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class Prescription extends StatefulWidget {
  const Prescription({Key key, @required this.appointment}) : super(key: key);

  final Appointment appointment;

  @override
  _PrescriptionState createState() => _PrescriptionState();
}

class _PrescriptionState extends State<Prescription> {
  final _fKey = GlobalKey<FormState>();

  String tablets, dose, remarks;
  bool isLoading = false;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.prescription),
      ),
      body: Padding(
        padding: ThemeGuide.padding20,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Form(
            key: _fKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const FieldLable(lable: AppStrings.tablets),
                ClipRRect(
                  borderRadius: ThemeGuide.borderRadius10,
                  child: FormField(
                    builder: (state) {
                      return TextFormField(
                        onChanged: (val) => tablets = val,
                        validator: validateTablets,
                        maxLines: 2,
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                const FieldLable(lable: AppStrings.dose),
                ClipRRect(
                  borderRadius: ThemeGuide.borderRadius10,
                  child: TextFormField(
                    onChanged: (val) => dose = val,
                    validator: validateDose,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(height: 16),
                const FieldLable(lable: AppStrings.remarks),
                ClipRRect(
                  borderRadius: ThemeGuide.borderRadius10,
                  child: TextFormField(
                    onChanged: (val) => remarks = val,
                    validator: validateRemarks,
                    maxLines: 10,
                  ),
                ),
                const SizedBox(height: 16),
                ShowError(text: errorText),
                Submit(
                  isLoading: isLoading,
                  onPress: () => submit(),
                  lable: AppStrings.save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> submit() async {
    if (_fKey.currentState.validate()) {
      setState(() {
        isLoading = !isLoading;
      });
      final bool result =
          await FirestoreService.createPrescription(createObject());
      if (result) {
        NavigationController.navigator.pop();
        return;
      } else {
        setState(() {
          errorText = AppStrings.somethingWentWrong;
          isLoading = !isLoading;
        });
      }
    }
  }

  Map<String, dynamic> createObject() {
    return {
      'tablets': tablets,
      'dose': dose,
      'remarks': remarks,
      'doctorId': widget.appointment.doctorId,
      'userId': widget.appointment.userId,
      'appointmentId': widget.appointment.uid,
      'title': widget.appointment.title,
      'appointmentDate': widget.appointment.createdAt,
      // add timestamp at the firestore service.
    };
  }

  String validateTablets(String val) {
    if (val.isEmpty) {
      return AppStrings.emptyFields;
    }
    return null;
  }

  String validateDose(String val) {
    if (val.isEmpty) {
      return AppStrings.emptyFields;
    }
    return null;
  }

  String validateRemarks(String val) {
    if (val.isEmpty) {
      return AppStrings.emptyFields;
    }
    return null;
  }
}

class FieldLable extends StatelessWidget {
  const FieldLable({Key key, @required this.lable}) : super(key: key);

  final String lable;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: ThemeGuide.padding10,
      child: Text(
        lable ?? '',
        style: Theme.of(context).textTheme.subtitle1,
      ),
    );
  }
}
