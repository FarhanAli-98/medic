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
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:doctor_consultation/screens/call/call.dart';
import 'package:doctor_consultation/screens/chat/chat.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/// Class handles only the communication between doctor and patient.
class CommunicationController extends StatefulWidget {
  const CommunicationController({Key key, this.appointment}) : super(key: key);

  final Appointment appointment;

  @override
  _CommunicationControllerState createState() =>
      _CommunicationControllerState();
}

class _CommunicationControllerState extends State<CommunicationController>
    with WidgetsBindingObserver {
  String documentId, doctorId, userId;
  final communicationProvider = LocatorService.communicationProvider();
  final bool isDoctorsAccount =
      LocatorService.doctorProvider().doctor?.uid != null || false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    // set the document ID. (IMPT)
    documentId = widget.appointment.uid;

    doctorId = widget.appointment.doctorId;
    userId = widget.appointment.userId;

    if (isDoctorsAccount) {
      communicationProvider.updateDoctorStatus(documentId, true);
    } else {
      communicationProvider.updateUserStatus(documentId, true);
    }

    communicationProvider.setUserId = widget.appointment.userId;
    communicationProvider.setDoctorId = widget.appointment.doctorId;
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      log('State changed to paused', name: 'CC');
      if (isDoctorsAccount) {
        communicationProvider.updateDoctorStatus(documentId, false);
      } else {
        communicationProvider.updateUserStatus(documentId, false);
      }
    }
    if (state == AppLifecycleState.inactive) {
      log('State changed to inactive', name: 'CC');
      if (isDoctorsAccount) {
        communicationProvider.updateDoctorStatus(documentId, false);
      } else {
        communicationProvider.updateUserStatus(documentId, false);
      }
    }
    if (state == AppLifecycleState.detached) {
      log('State changed to detached', name: 'CC');
      if (isDoctorsAccount) {
        communicationProvider.updateDoctorStatus(documentId, false);
      } else {
        communicationProvider.updateUserStatus(documentId, false);
      }
    }
    if (state == AppLifecycleState.resumed) {
      log('State changed to resumed', name: 'CC');
      if (isDoctorsAccount) {
        communicationProvider.updateDoctorStatus(documentId, true);
      } else {
        communicationProvider.updateUserStatus(documentId, true);
      }
    }
  }

  @override
  void dispose() {
    if (isDoctorsAccount) {
      communicationProvider.updateDoctorStatus(documentId, false);
    } else {
      communicationProvider.updateUserStatus(documentId, false);
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: LocatorService.communicationProvider()
          .getAppointmentDocStream(documentId),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasData) {
          final data = snapshot.data.data();
          final isDoctorActive = data['isDoctorActive'];
          final isUserActive = data['isUserActive'];

          if (isUserActive && isDoctorActive) {
            return switchByConsultationType(
              widget.appointment.consultationType,
            );
          }

          return placeHolderView();
        } else {
          return Container(
            child: const Center(
              child: CustomLoader(),
            ),
          );
        }
      },
    );
  }

  Widget switchByConsultationType(ConsultationFormatType type) {
    switch (type) {
      case ConsultationFormatType.CHAT:
        return const Chat();
        break;

      case ConsultationFormatType.VIDEO_CALL:
        return Call(
          channelName: '$doctorId-$userId',
          isAudio: false,
        );
        break;

      case ConsultationFormatType.VOICE_CALL:
        return Call(
          channelName: '$doctorId-$userId',
          isAudio: true,
        );
        break;

      default:
        return const Chat();
    }
  }

  Widget placeHolderView() {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: ThemeGuide.padding20,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppStrings.connecting,
              style: Theme.of(context).textTheme.headline6,
            ),
            const SizedBox(
              height: 30,
            ),
            const SpinKitThreeBounce(
              color: Colors.blue,
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              AppStrings.communicationMessage,
              style: Theme.of(context).textTheme.caption,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
