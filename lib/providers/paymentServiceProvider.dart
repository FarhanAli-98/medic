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
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/enumStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// ## `Description`
///
/// Controls the payment flow, navigation, updating the appointments
/// and all the related stuff.
class PaymentServiceProvider with ChangeNotifier {
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

  Stream<DocumentSnapshot> docStream;
  StreamSubscription<DocumentSnapshot> sub;

  // Flags to change the UI.
  bool isPaymentSuccessful = false;
  bool isPaymentFailed = false;
  bool isLoading = false;
  // message to display to the ui
  String displayMessage = '';

  // Updates the UI
  void updateUI(String message, {bool setLoaing = true}) {
    displayMessage = message;
    isLoading = setLoaing;
    notifyListeners();
  }

  void onPaymentFailed() {
    log('Payment Failed', name: 'PSP');
    updateUI(AppStrings.paymentFailed, setLoaing: false);
    Fluttertoast.showToast(msg: AppStrings.paymentFailed);
  }

  void onPaymentSuccessfull() {
    log('Payment Successfull', name: 'PSP');
    updateUI(AppStrings.paymentSuccessfull);

    NavigationController.navigator.pop();
    NavigationController.navigator.push(Routes.communicationController);
  }

  void cancelSub() {
    sub?.cancel();
  }

  @override
  void dispose() {
    cancelSub();
    super.dispose();
  }
}
