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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/enumStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppointmentsProvider extends BaseProvider {
  int _totalAppointments = 0;

  int get totalAppointments => _totalAppointments;

  // All appointments
  List<Appointment> _appointmentList = [];

  List<Appointment> get appointmentList => _appointmentList;

  List<Appointment> _previousAppointmentsList = [];

  List<Appointment> get previousAppointmentsList => _previousAppointmentsList;

  List<Appointment> _scheduledAppointmentsList = [];

  List<Appointment> get scheduledAppointmentsList => _scheduledAppointmentsList;

  List<Appointment> _cancelledAppointmentsList = [];

  List<Appointment> get cancelledAppointmentsList => _cancelledAppointmentsList;

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _totalAppointments = 0;
    _appointmentList = [];
    _previousAppointmentsList = [];
    _scheduledAppointmentsList = [];
    _cancelledAppointmentsList = [];
  }

  Future<void> fetchData() async {
    // Get the user id
    //FAuthUser user = await LocatorService.authService().currentUser();
    final String uid = LocatorService.userProvider().user?.uid;

    try {
      final List<DocumentSnapshot> result =
          await FirestoreService.getAppointments(uid);

      if (result.isEmpty) {
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        // Convert each object to the Appointment model class.
        final _list = <Appointment>[];
        for (final obj in result) {
          final Map<String, dynamic> tempObj = {'uid': obj.id, ...obj.data()};
          final Appointment appointment = Appointment.fromJSON(tempObj);
          _list.add(appointment);
        }

        // set the total no. of appointments fetched
        _totalAppointments = _list.length;

        // assign the list to new list
        _appointmentList = _list;

        // Sort appointment in to list
        sortIntoLists(_list);

        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future<void> fetchDoctorsData() async {
    // Get the user id
    final String doctorId = LocatorService.doctorProvider().doctor?.uid;
    print("DOCTOR ID IS ??????? $doctorId");
    try {
      final List<DocumentSnapshot> result =
          await FirestoreService.getDoctorAppointments(doctorId);

      if (result.isEmpty) {
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        final _list = <Appointment>[];
        for (final obj in result) {
          final Map<String, dynamic> tempObj = {
            'uid': obj.id,
            ...obj.data(),
          };
          final Appointment appointment = Appointment.fromJSON(tempObj);
          _list.add(appointment);
        }

        // set the total no. of appointments fetched
        _totalAppointments = _list.length;

        // assign the list to new list
        _appointmentList = _list;

        // Sort appointment in to list
        sortIntoLists(_list);

        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  ///
  /// ## `Description`
  ///
  /// Triggers a new `Appointment Fetch` action on new notification if the
  /// account type is a [Doctor Account].
  ///
  /// Must be used in [ONLY] the following parameters of
  /// [ _firebaseMessaging.configure ] method of [PushNotificationService]
  ///
  /// 1. `onMessage`
  /// 2. `onResume`
  ///
  /// Should not be used with `onLaunch` as the appointment list will be
  /// fetched automatically on application launch.
  ///
  void fetchDoctorAppointmentsOnNotification() {
    log('Running fetchDoctorAppointmentsOnNotification', name: 'AP');
    // Continue only if Doctor info != null
    final doctor = LocatorService.doctorProvider().doctor;

    if (doctor != null) {
      // Trigger a fetch action for doctors appointment
      fetchDoctorsData();
    }
  }

  void sortIntoLists(List<Appointment> list) {
    _scheduledAppointmentsList = [];
    _previousAppointmentsList = [];
    _cancelledAppointmentsList = [];

    list.forEach(sort);

    _scheduledAppointmentsList.sort((b, a) {
      return a.timestamp.compareTo(b.timestamp);
    });
    _previousAppointmentsList.sort((b, a) {
      return a.timestamp.compareTo(b.timestamp);
    });
    _cancelledAppointmentsList.sort((b, a) {
      return a.timestamp.compareTo(b.timestamp);
    });
  }

  void sort(Appointment appointment) {
    switch (appointment.status) {
      case AppointmentStatusType.SCHEDULED:
        _scheduledAppointmentsList.add(appointment);
        break;

      case AppointmentStatusType.PREVIOUS:
        _previousAppointmentsList.add(appointment);
        break;

      case AppointmentStatusType.CANCELLED:
        _cancelledAppointmentsList.add(appointment);
        break;

      case AppointmentStatusType.NOT_DEFINED:
        break;
    }
  }

  //*******************************************
  //  Appointment status changes
  //*******************************************

  bool _isChangingStatus = false;

  bool get isChangingStatus => _isChangingStatus;

  set setChangingStatus(bool value) {
    _isChangingStatus = value;
  }

  /// Change appointment status
  Future<void> changeAppointmentStatus(String appointmentId) async {
    setChangingStatus = true;
    notifyListeners();
    final result = await FirestoreService.updateAppointmentStatus(
        appointmentId, EnumStrings.PREVIOUS);

    if (result) {
      Fluttertoast.showToast(msg: AppStrings.updated);

      // Change the appointment in the local lists as well.
      _updateAppointmentLists(appointmentId);
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    }
    setChangingStatus = false;
    notifyListeners();
  }

  /// Updates the local appointment lists by removing the item from
  /// scheduled list and adding it to the previous list.
  void _updateAppointmentLists(String appointmentId) {
    log('Updating appointment lists', name: 'Appointment Provider');
    // find the appointment in the appointment list
    final Appointment appointment =
        _appointmentList.firstWhere((element) => element.uid == appointmentId);

    // update the status to previous
    appointment.updateStatusToPrevious();

    // remove appointment from scheduled list
    _scheduledAppointmentsList
        .removeWhere((element) => element.uid == appointmentId);

    // add the appointment to previous list
    _previousAppointmentsList.insert(0, appointment);
  }
}
