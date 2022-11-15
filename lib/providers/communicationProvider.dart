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

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:flutter/foundation.dart';

/// Handles all the communication related logic
/// listens for incoming updates from the server
/// reacts to those changes.
class CommunicationProvider with ChangeNotifier {
  Stream<DocumentSnapshot> getAppointmentDocStream(String documentId) {
    return FirestoreService.getAppointmentDocStream(documentId);
  }

  Future<void> updateUserStatus(String documentId, bool isUserActive) async {
    await FirestoreService.updateAppointmentDocUserStatus(
      documentId,
      isUserActive,
    );
  }

  Future<void> updateDoctorStatus(
    String documentId,
    bool isDoctorActive,
  ) async {
    await FirestoreService.updateAppointmentDocDoctorStatus(
      documentId,
      isDoctorActive,
    );
  }

  // Doctor id
  String _doctorId;
  String get doctorId => _doctorId;
  set setDoctorId(String value) {
    _doctorId = value;
  }

  // User id
  String _userId;
  String get userId => _userId;
  set setUserId(String value) {
    _userId = value;
  }

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _doctorId = null;
    _userId = null;
  }
}
