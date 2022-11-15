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

import 'package:doctor_consultation/shared/customDialog.dart';
import 'package:doctor_consultation/utils/networkStatus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

@deprecated
abstract class UtilsViewModel {
  /// Displays a custom alert box with blurred background
  static void showDialoge(BuildContext context, Widget child,
      {bool showCloseButton = true}) {
    showGeneralDialog(
      barrierColor: Colors.black.withOpacity(0.5),
      transitionBuilder: (context, a1, a2, widget) {
        return CustomDialog(
          showCloseButton: showCloseButton,
          child: Opacity(
            opacity: a1.value,
            child: IgnorePointer(child: child),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 200),
      barrierDismissible: false,
      context: context,
      pageBuilder: (context, animation1, animation2) {
        return const SizedBox();
      },
    );
  }

  /// Creates a modal screen
  static void showModal(BuildContext context, Widget child) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return child;
      },
    );
  }

  /// Create a bottom sheet.
  static void modalBottomSheet(BuildContext context, {Widget child}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          child ??
          Container(
            height: 200,
            color: Colors.white,
          ),
    );
  }

  /// Create a bottom sheet.
  static void modalPopup(BuildContext context, {Widget child}) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) =>
          child ??
          Container(
            height: 200,
            color: Colors.white,
          ),
    );
  }

  static void showSnackBar(
    BuildContext context,
    String text, {
    String actionLable,
    Function actionFun,
  }) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: actionLable ?? '',
          onPressed: () => actionFun(),
        ),
      ),
    );
  }

  /// Check the network status of the app.
  static Future<bool> checkNetworkStatus() {
    // print('From utils view model');
    return NetworkStatus.isConnected();
  }
}
