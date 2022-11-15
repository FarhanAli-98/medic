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

import 'package:flutter/foundation.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/doctorModel.dart';

///
/// ## `Description`
///
/// Holds information about the type of format chosen to
/// connect to the doctor.
///
class ConsultationProvider with ChangeNotifier {
  // Initial type
  ConsultationFormatType _formatType = ConsultationFormatType.CHAT;
  ConsultationFormatType get formatType => _formatType;

  set setConsultationFormatType(ConsultationFormatType type) {
    _formatType = type;
    _formatTypeString = getConsultationFormatString(type);
    notifyListeners();
  }

  // Get consultation format type string
  String _formatTypeString = 'Chat';
  String get formatTypeString => _formatTypeString;

  // Doctor id
  Doctor _doctor;
  Doctor get doctor => _doctor;
  set setDoctor(Doctor value) {
    _doctor = value;
    notifyListeners();
  }

  // User id
  String userId = LocatorService.userProvider().user.uid;

  // Amount to be paid
  String _amount;
  String get amount => _amount;
  set setAmount(String value) {
    _amount = value;
    notifyListeners();
  }

  // title of the appointment
  String _title;
  String get title => _title;
  set setTitle(String value) {
    _title = value;
    notifyListeners();
  }

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _formatType = ConsultationFormatType.CHAT;
    _formatTypeString = 'Chat';
    _doctor = null;
    _amount = null;
    _title = null;
  }

  /// Get the string value for the consultation type based on the enum
  static String getConsultationFormatString(ConsultationFormatType type) {
    switch (type) {
      case ConsultationFormatType.CHAT:
        return 'Chat';
        break;
      case ConsultationFormatType.VIDEO_CALL:
        return 'Video Call';
        break;
      case ConsultationFormatType.VOICE_CALL:
        return 'Voice Call';
        break;
      case ConsultationFormatType.NOT_DEFINED:
        return 'Not Defined';
        break;
      default:
        return 'Not Defined';
    }
  }

//TODO need remove PMI
  void testSetDoctor(Doctor doctor) {
    _doctor = doctor;
    notifyListeners();
  }
}

enum ConsultationFormatType {
  CHAT,
  VIDEO_CALL,
  VOICE_CALL,
  NOT_DEFINED,
}
