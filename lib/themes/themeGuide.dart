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

import 'package:flutter/material.dart';

abstract class ThemeGuide {
  // Padding
  static const EdgeInsets padding = EdgeInsets.all(8.0);
  static const EdgeInsets padding10 = EdgeInsets.all(10.0);
  static const EdgeInsets padding16 = EdgeInsets.all(16.0);
  static const EdgeInsets padding20 = EdgeInsets.all(20.0);

  // Border Radius
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(8));
  static const BorderRadius borderRadius10 =
      BorderRadius.all(Radius.circular(10));
  static const BorderRadius borderRadius16 =
      BorderRadius.all(Radius.circular(16));
  static const BorderRadius borderRadius20 =
      BorderRadius.all(Radius.circular(20));

  // Colors
  static const Color textFieldColor = Color.fromRGBO(245, 245, 245, 1);
  static const Color lightGrey = Color.fromRGBO(245, 245, 245, 1);
  static const Color darkGrey = Color.fromRGBO(240, 240, 240, 1);

  // Main box decoration
  static const BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: borderRadius10,
    boxShadow: boxShadow,
  );

  // Main box decoration black
  static const BoxDecoration boxDecorationBlack = BoxDecoration(
    color: Colors.white,
    borderRadius: borderRadius10,
    boxShadow: boxShadowBlack,
  );

  // Box shadow
  static const List<BoxShadow> boxShadow = [
    BoxShadow(
      color: Color.fromRGBO(94, 162, 242, 0.2),
      spreadRadius: 2,
      blurRadius: 5,
    ),
  ];

  static const List<BoxShadow> boxShadowBlack = [
    BoxShadow(
      color: Color.fromRGBO(235, 235, 235, 1),
      spreadRadius: 0,
      blurRadius: 10,
    )
  ];
}
