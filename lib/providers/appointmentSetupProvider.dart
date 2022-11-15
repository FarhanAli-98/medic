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

// ignore_for_file: prefer_final_locals

import 'dart:developer';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/enumStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

/// Handles all the communication related logic
class AppointmentSetupProvider with ChangeNotifier {
  String setConsultationType() {
    final type = LocatorService.consultationProvider().formatType;

    switch (type) {
      case ConsultationFormatType.CHAT:
        return EnumStrings.CHAT;
        break;

      case ConsultationFormatType.VIDEO_CALL:
        return EnumStrings.VIDEO_CALL;
        break;

      case ConsultationFormatType.VOICE_CALL:
        return EnumStrings.VOICE_CALL;
        break;

      case ConsultationFormatType.NOT_DEFINED:
        return EnumStrings.NOT_DEFINED;
        break;

      default:
        return EnumStrings.NOT_DEFINED;
    }
  }

  // Unique ID for the appointment document.
  // Used as a reference UID by the payment document.
  String _appointmentUID;
  String get appointmentUID => _appointmentUID;
  set setAppoinetmentUID(String value) {
    _appointmentUID = value;
  }

  // Unique ID for the appointment document.
  // Used as a reference UID by the payment document.
  String _paymentDocUID;
  String get paymentDocUID => _paymentDocUID;
  set setPaymentDocUID(String value) {
    _paymentDocUID = value;
  }

  // Flags to change the UI.
  bool isLoading = false;
  bool isAppointmentSuccessfull = false;
  bool isAppointmentFailed = false;

  // message to display to the ui
  String displayMessage = '';

  // Updates the UI
  void updateUI(
    String message, {
    bool setLoaing = true,
    bool setAppointmentSuccessfull = false,
    bool setAppointmentFailed = false,
  }) {
    displayMessage = message;
    isLoading = setLoaing;
    isAppointmentSuccessfull = setAppointmentSuccessfull;
    isAppointmentFailed = setAppointmentFailed;
    notifyListeners();
  }

  List<String> timeSlots = [];
  // ignore: prefer_final_fields
  List<NeatCleanCalendarEvent> todaysEvents = [
    NeatCleanCalendarEvent('Event A',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 12, 0),
        description: 'A special event',
        color: Colors.blue[700]),
  ];

  final List<NeatCleanCalendarEvent> eventList = [
    NeatCleanCalendarEvent('MultiDay Event A',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 10, 0),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 12, 0),
        color: Colors.orange,
        isMultiDay: true),
    NeatCleanCalendarEvent('Allday Event B',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day - 2, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day + 2, 17, 0),
        color: Colors.pink,
        isAllDay: true),
    NeatCleanCalendarEvent('Normal Event D',
        startTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 14, 30),
        endTime: DateTime(DateTime.now().year, DateTime.now().month,
            DateTime.now().day, 17, 0),
        color: Colors.indigo),
  ];

  void slots(DateTime now, int duration) {
    // DateTime now = DateTime.now();
    DateTime startTime = DateTime(now.year, now.month, now.day, 8, 0, 0);
    DateTime endTime = DateTime(now.year, now.month, now.day, 18, 0, 0);
    Duration step = Duration(minutes: duration);
    timeSlots = [];
    while (startTime.isBefore(endTime)) {
      DateTime timeIncrement = startTime.add(step);
      timeSlots.add(DateFormat.jm().format(timeIncrement));
      startTime = timeIncrement;
    }
    notifyListeners();
  }

  // Initiate a call room
  void initiateCallRoom() async {
    updateUI('Initiating call');

    var doctorId = LocatorService.consultationProvider().doctor.uid;
    var userId = LocatorService.consultationProvider().userId;

    var timestamp = DateTime.now().millisecondsSinceEpoch;
    var callRoomDoc = {
      'userId': userId,
      'doctorId': doctorId,
      'channelName': '$doctorId-$userId',
      'consultationType': setConsultationType(),
      'createAt': timestamp,
      'validTill': timestamp + 18000000,
    };

    bool isAudio;
    if (LocatorService.consultationProvider().formatType ==
        ConsultationFormatType.VOICE_CALL) {
      isAudio = true;
    } else {
      isAudio = false;
    }

    await Future.delayed(Duration(seconds: 2));
    NavigationController.navigator.pop();
    NavigationController.navigator.push(
      Routes.call,
      arguments: CallArguments(
        channelName: callRoomDoc['channelName'],
        isAudio: isAudio,
      ),
    );
  }

  ///
  /// ## `Description`
  ///
  /// When an appointment is successfully created, update the UI to show
  /// success message.
  ///
  /// ### `Important`
  ///
  /// * Triggers an `Appointment Fetch` action to get all the new
  /// appointments and add the new one to the list as well.
  ///
  void onAppointmentSuccessfull() {
    updateUI('', setLoaing: false, setAppointmentSuccessfull: true);

    // Notification request set to the doctor
    LocatorService.pushNotificationService().showNotification(
      title: AppStrings.appointmentSuccessfull,
      body: AppStrings.appointmentQuestionMessage,
    );

    // Call the fetch appointment action
    LocatorService.appointmentsProvider().fetchData();
  }

  void onAppointmentFailed() {
    updateUI('', setLoaing: false, setAppointmentFailed: true);
    Fluttertoast.showToast(msg: AppStrings.appointmentFailed);
  }

  @deprecated
  Future<void> initiateAppointment() async {
    updateUI(AppStrings.settingUpAppointment);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
//TODO Read this  doc

    final appointmentDoc = {
      'userId': LocatorService.consultationProvider().userId,
      'doctorId': LocatorService.consultationProvider().doctor.uid,
      'title': LocatorService.consultationProvider().title,
      'status': EnumStrings.SCHEDULED,
      'consultationType': setConsultationType(),
      'createdAt': timestamp.toString(),
      'validTill': (timestamp + 18000000).toString(), // valid till 5 hours
      'isDoctorActive': false, // for live updates from stream
      'isUserActive': false,
    };

    final result = await FirestoreService.createAppointmentDoc(appointmentDoc);
    if (result.containsKey('ref')) {
      LocatorService.pushNotificationService().sendSuccessNotification(
        LocatorService.consultationProvider().doctor.uid,
        LocatorService.consultationProvider().title,
      );
      onAppointmentSuccessfull();
    } else {
      onAppointmentFailed();
    }
  }

  ///
  /// ## `Description`
  ///
  /// Creates a new appointment using a [predefined UID]. The UID is required
  /// to create a new appointment doc. If the UID is not set using the
  /// `appointmentUID` variable in this provider, the function will fail.
  ///
  Future<void> initiateAppointmentWithId() async {
    if (appointmentUID == null) {
      log('No appointment ID found', name: 'ASC');
      return;
    }

    updateUI(AppStrings.settingUpAppointment);

    final timestamp = DateTime.now().millisecondsSinceEpoch;
    print(
      LocatorService.consultationProvider().doctor.uid,
    );
    //TODO
    final appointmentDoc = {
      'uid': appointmentUID.toString(),
      'userId': LocatorService.consultationProvider().userId,
      'doctorId': LocatorService.consultationProvider().doctor.uid,
      'title': LocatorService.consultationProvider().title,
      'status': EnumStrings.SCHEDULED,
      'consultationType': setConsultationType(),
      'createdAt': timestamp.toString(),
      'validTill': (timestamp + 18000000).toString(), // valid till 5 hours
      'isDoctorActive': false, // for live updates from stream
      'isUserActive': true,
      'timestamp': timestamp.toString(),
      'paymentId': _paymentDocUID.toString(),
    };

    final result =
        await FirestoreService.createAppointmentDocWithId(appointmentDoc);
    if (result.containsKey('ref')) {
      onAppointmentSuccessfull();
    } else {
      onAppointmentFailed();
    }
  }

  Future<void> runMockTest() async {
    updateUI('Initiating an appointment');
    await Future.delayed(const Duration(seconds: 3));
    onAppointmentSuccessfull();
    // onAppointmentFailed();
  }
}
