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

import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    Key key,
    this.title = '',
    this.showBackButton = false,
  }) : super(key: key);

  final String title;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    if (showBackButton) {
      return AppBar(
        elevation: 0,
        leading: IconButton(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: () {
            NavigationController.navigator.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: _theme.primaryColorDark,
          ),
        ),
        title: Text(
          title ?? '',
          style: _theme.textTheme.subtitle1,
        ),
        backgroundColor: _theme.backgroundColor,
      );
    } else {
      return AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          title ?? '',
          style: _theme.textTheme.subtitle1,
        ),
        backgroundColor: _theme.backgroundColor,
      );
    }
  }

  @override
  Size get preferredSize => const Size(double.infinity, 56);
}
