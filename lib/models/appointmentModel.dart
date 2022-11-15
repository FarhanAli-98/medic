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

import 'package:doctor_consultation/constants/enumStrings.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:intl/intl.dart';

enum AppointmentStatusType { SCHEDULED, PREVIOUS, CANCELLED, NOT_DEFINED }

class Appointment {
  Appointment({
    this.uid,
    this.userId,
    this.createdAt,
    this.doctorId,
    this.status,
    this.validTill,
    this.title,
    this.timestamp,
    this.isDoctorActive,
    this.isUserActive,
  });

  Appointment.fromJSON(Map<String, dynamic> json) {
    uid = json['uid'];
    userId = json['userId'];
    doctorId = json['doctorId'];
    title = json['title'] ?? 'Title';
    consultationType = json['consultationType'] != null
        ? setConsultationType(json['consultationType'])
        : ConsultationFormatType.NOT_DEFINED;
    createdAt = json['createdAt'] != null ? createDate(json['createdAt']) : '';
    validTill = json['validTill'] != null ? createDate(json['validTill']) : '';
    status = json['status'] != null
        ? setStatus(json['status'])
        : AppointmentStatusType.NOT_DEFINED;
    timestamp = json['createdAt'] != null ? int.parse(json['createdAt']) : null;
    isDoctorActive = json['isDoctorActive'];
    isUserActive = json['isUserActive'];
  }

  String uid, userId, doctorId, createdAt, validTill, title;
  ConsultationFormatType consultationType;
  AppointmentStatusType status;
  int timestamp;
  bool isDoctorActive, isUserActive;

  ConsultationFormatType setConsultationType(String type) {
    switch (type) {
      case EnumStrings.CHAT:
        return ConsultationFormatType.CHAT;
        break;
      case EnumStrings.VOICE_CALL:
        return ConsultationFormatType.VOICE_CALL;
        break;
      case EnumStrings.VIDEO_CALL:
        return ConsultationFormatType.VIDEO_CALL;
        break;
      default:
        return ConsultationFormatType.NOT_DEFINED;
    }
  }

  AppointmentStatusType setStatus(String type) {
    switch (type) {
      case EnumStrings.SCHEDULED:
        return AppointmentStatusType.SCHEDULED;
        break;
      case EnumStrings.PREVIOUS:
        return AppointmentStatusType.PREVIOUS;
        break;
      case EnumStrings.CANCELLED:
        return AppointmentStatusType.CANCELLED;
        break;
      default:
        return AppointmentStatusType.NOT_DEFINED;
    }
  }

  String createDate(String date) {
    final d = DateTime.fromMillisecondsSinceEpoch(int.parse(date));
    return DateFormat('d MMM y h:mm a').format(d);
  }

  void updateStatusToPrevious() {
    status = AppointmentStatusType.PREVIOUS;
    log('Updating appointment status to previous');
  }
}
