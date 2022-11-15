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

class DividerWithText extends StatelessWidget {
  const DividerWithText(
      {this.text,
      this.thickness = 2,
      this.indent = 20,
      this.endIndent = 20,
      this.color,
      this.textStyle,
      Key key})
      : super(key: key);

  final String text;
  final double thickness, indent, endIndent;
  final Color color;
  final TextStyle textStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Divider(
          indent: indent,
          endIndent: endIndent,
          thickness: thickness,
          color: color,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          color: _theme.backgroundColor,
          child: Text(
            text ?? '',
            style: textStyle,
          ),
        ),
      ],
    );
  }
}
