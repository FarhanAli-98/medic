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

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class UiController {
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

  static void showSnackBar(
    BuildContext context,
    String text, {
    String actionLable,
    Function actionFun,
  }) {
    ScaffoldMessenger.maybeOf(context).showSnackBar(
      SnackBar(
        content: Text(text),
        action: SnackBarAction(
          label: actionLable ?? '',
          onPressed: () => actionFun(),
        ),
      ),
    );
  }
}
