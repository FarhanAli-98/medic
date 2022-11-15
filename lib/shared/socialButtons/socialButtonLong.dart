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

import 'package:doctor_consultation/shared/socialButtons/socialButtons.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class SocialButtonLong extends StatelessWidget {
  const SocialButtonLong({
    this.buttonType,
    this.lable,
  });

  const SocialButtonLong.google({
    this.buttonType = SocialButtonType.GOOGLE,
    this.lable,
  });

  const SocialButtonLong.facebook({
    this.buttonType = SocialButtonType.FACEBOOK,
    this.lable,
  });

  final SocialButtonType buttonType;
  final String lable;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    Widget _renderButton = const SizedBox();

    switch (buttonType) {
      case SocialButtonType.GOOGLE:
        _renderButton = SocialButtons.googleButton(height: 35);
        break;

      case SocialButtonType.FACEBOOK:
        _renderButton = SocialButtons.facebookButton(height: 35);
        break;

      default:
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: _theme.accentColor,
        borderRadius: ThemeGuide.borderRadius16,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(160, 160, 160, 0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          _renderButton,
          Expanded(
            child: Text(
              lable,
              style: _theme.textTheme.subtitle1.copyWith(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
