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

///
/// ## `Description`
///
/// Prescription model class.
///
class Prescription {
  Prescription.fromMap(Map<String, dynamic> json) {
    uid = json['uid'] ?? '';
    tablets = json['tablets'] ?? '';
    dose = json['dose'] ?? '';
    remarks = json['remarks'] ?? '';
    doctorId = json['doctorId'] ?? '';
    userId = json['userId'] ?? '';
    appointmentId = json['appointmentId'] ?? '';
    appointmentDate = json['appointmentDate'] ?? '';
    timestamp = json['timestamp'] ?? '';
    title = json['title'] ?? '';
  }

  String uid,
      tablets,
      dose,
      remarks,
      doctorId,
      userId,
      appointmentId,
      timestamp,
      title,
      appointmentDate;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid ?? '',
      'tablets': tablets ?? '',
      'dose': dose ?? '',
      'remarks': remarks ?? '',
      'doctorId': doctorId ?? '',
      'userId': userId ?? '',
      'appointmentId': appointmentId ?? '',
      'appointmentDate': appointmentDate ?? '',
      'timestamp': timestamp ?? '',
      'title': title ?? '',
    };
  }
}
