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

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Input Class that renders an Input Text field.
/// Takes in a `placeholder` to label the field.
class CustomInput extends StatelessWidget {
  const CustomInput({
    Key key,
    @required this.placeholder,
    @required this.onChange,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.prefixText,
    this.inputFormatters,
  }) : super(key: key);

  final String placeholder, prefixText;
  final Function validator;
  final Function onChange;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    bool obscureText;
    if (placeholder.toString().toLowerCase() == 'password' ||
        placeholder.toString().toLowerCase() == 'confirm password') {
      obscureText = true;
    } else {
      obscureText = false;
    }

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: _theme.inputDecorationTheme.fillColor,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextFormField(
        inputFormatters: inputFormatters,
        validator: validator,
        onChanged: onChange,
        autocorrect: false,
        keyboardType: keyboardType,
        cursorColor: _theme.cursorColor,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
        textCapitalization: TextCapitalization.none,
        decoration: InputDecoration(
          prefixStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black54,
            fontWeight: FontWeight.w600,
          ),
          prefixText: prefixText,
          border: InputBorder.none,
          hintText: placeholder,
          hintStyle: const TextStyle(
            fontSize: 16.0,
            color: Colors.black38,
          ),
          contentPadding: const EdgeInsets.all(10.0),
        ),
      ),
    );
  }
}
