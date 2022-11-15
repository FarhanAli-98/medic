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
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/screens/search/filterContainer/filterContainer.dart';
import 'package:doctor_consultation/shared/animatedButton.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class InputContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: ClipRRect(
            borderRadius: ThemeGuide.borderRadius,
            child: TextFormField(
              initialValue: LocatorService.searchProvider().searchTerm,
              decoration: InputDecoration(
                hintText: AppStrings.search,
                hintStyle: _theme.textTheme.bodyText2.copyWith(
                  color: _theme.disabledColor,
                ),
              ),
              onEditingComplete: () {
                FocusScope.of(context).unfocus();
                // Call the loading function only as it calls the
                // getData function internally.
                LocatorService.searchProvider().notifyLoading();
              },
              onChanged: (val) =>
                  LocatorService.searchProvider().setSearchTerm = val,
            ),
          ),
        ),
        const SizedBox(width: 5),
        AnimButton(
          onTap: () {
            FocusScope.of(context).unfocus();
            UiController.modalBottomSheet(
              context,
              child: FilterContainer(),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            child: const Icon(Icons.filter_list),
            decoration: BoxDecoration(
              color: _theme.disabledColor.withOpacity(0.2),
              borderRadius: ThemeGuide.borderRadius,
            ),
          ),
        ),
      ],
    );
  }
}
