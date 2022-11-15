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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/searchProvider.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class FilterContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _theme.backgroundColor,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _theme.disabledColor.withOpacity(0.2),
              borderRadius: ThemeGuide.borderRadius,
            ),
            child: Text(
              AppStrings.filterBy,
              style: _theme.textTheme.headline5,
            ),
          ),
          const SizedBox(height: 20),
          const FilterOptions(),
        ],
      ),
    );
  }
}

class FilterOptions extends StatefulWidget {
  const FilterOptions({Key key}) : super(key: key);
  @override
  FilterOptionsState createState() => FilterOptionsState();
}

class FilterOptionsState extends State<FilterOptions> {
  SearchFilterType _filter = SearchFilterType.DOCTOR;
  String pathUrl = 'lib/assets/svg';

  Widget buildOption({
    @required SearchFilterType type,
    @required String text,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filter = type;
          LocatorService.searchProvider().setFilter = _filter;
        });
      },
      child: FilterOptionsTile(
        isSelected: _filter == type || false,
        title: text,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _filter = LocatorService.searchProvider().filter;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        buildOption(type: SearchFilterType.DOCTOR, text: AppStrings.doctor),
        buildOption(type: SearchFilterType.HOSPITAL, text: AppStrings.hospital),
        buildOption(
            type: SearchFilterType.SPECIALITY, text: AppStrings.speciality),
      ],
    );
  }
}

class FilterOptionsTile extends StatelessWidget {
  const FilterOptionsTile({
    Key key,
    this.isSelected = false,
    this.title,
  }) : super(key: key);

  final bool isSelected;
  final String title;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: isSelected
            ? _theme.accentColor
            : _theme.disabledColor.withOpacity(0.1),
        borderRadius: ThemeGuide.borderRadius,
        border: Border.all(
          width: 3,
          color: isSelected
              ? _theme.primaryColorLight.withOpacity(0.2)
              : _theme.accentColor,
        ),
      ),
      child: AnimatedContainer(
        width: MediaQuery.of(context).size.width,
        padding:
            isSelected ? const EdgeInsets.all(15) : const EdgeInsets.all(10),
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: AnimatedContainer(
                height: isSelected ? 50 : 20,
                width: isSelected ? 50 : 20,
                duration: const Duration(milliseconds: 300),
                curve: Curves.fastOutSlowIn,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected
                        ? _theme.primaryColorLight.withOpacity(0.2)
                        : _theme.disabledColor.withOpacity(0.0),
                    borderRadius: ThemeGuide.borderRadius,
                  ),
                  child: isSelected
                      ? Icon(
                          Icons.check,
                          color: _theme.primaryColorLight,
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title ?? '',
                  style: _theme.textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Flexible(
              child: Container(
                height: isSelected ? 50 : 20,
                width: isSelected ? 50 : 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
