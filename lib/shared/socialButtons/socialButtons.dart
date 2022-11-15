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
import 'package:flutter_svg/flutter_svg.dart';

enum SocialButtonType {
  GOOGLE,
  FACEBOOK,
  APPLE,
}

abstract class SocialButtons {
  static const String _svgAssetPath = 'lib/assets/svg/';

  static Widget _buildButton({
    Function onPress,
    @required String assetUrl,
    double height = 40,
  }) {
    return InkWell(
      highlightColor: Colors.transparent,
      onTap: () {
        onPress();
      },
      child: SvgPicture.asset(
        assetUrl,
        height: height,
      ),
    );
  }

  // Build google button
  static Widget googleButton({Function onPress, double height = 40}) {
    return _buildButton(
        assetUrl: _svgAssetPath + 'google.svg',
        onPress: onPress,
        height: height);
  }

  // Build facebook button
  static Widget facebookButton({Function onPress, double height = 40}) {
    return _buildButton(
        assetUrl: _svgAssetPath + 'facebook.svg',
        onPress: onPress,
        height: height);
  }
}
