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
import 'package:doctor_consultation/themes/themeGuide.dart';

class SectionContainer extends StatelessWidget {
  const SectionContainer({Key key, this.title, this.text, this.child})
      : super(key: key);

  final String title, text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: ThemeGuide.padding20,
      decoration: const BoxDecoration(
        color: ThemeGuide.darkGrey,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title ?? ' ',
            style: _theme.textTheme.headline6,
          ),
          const SizedBox(
            height: 10,
          ),
          if (child != null)
            child
          else
            Text(
              text ?? ' ',
              style: Theme.of(context)
                  .textTheme
                  .bodyText1
                  .copyWith(color: Colors.black54, height: 1.3),
            ),
        ],
      ),
    );
  }
}
