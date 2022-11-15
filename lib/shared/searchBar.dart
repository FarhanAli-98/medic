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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: ThemeGuide.borderRadius10,
              color: Color.fromRGBO(240, 240, 240, 1),
            ),
            child: TextField(
              cursorColor: Theme.of(context).cursorColor,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                alignLabelWithHint: true,
                hintText: AppStrings.search,
                hintStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                icon: Padding(
                  padding: EdgeInsets.only(
                    left: 12,
                    top: 12,
                    bottom: 12,
                    right: 0,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.black54,
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          child: const Icon(
            Icons.filter_list,
            size: 30,
          ),
        ),
      ],
    );
  }
}
