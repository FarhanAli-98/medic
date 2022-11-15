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
import 'package:doctor_consultation/providers/illnessOptionsProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_consultation/utils/sanitizers.dart';

///
/// ## `Description`
///
/// Modal to fetch all the list of the illness from the server and display
/// to the user to choose from.
///
class IllnessOptionsModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.choose + ' ' + AppStrings.illness),
      ),
      body: ChangeNotifierProvider<IllnessOptionsProvider>.value(
        value: LocatorService.illnessOptionsProvider(),
        child: ViewStateSelector<IllnessOptionsProvider>(
          getData: () =>
              LocatorService.illnessOptionsProvider().fetchIllnessData(),
          child: ListContainer(),
        ),
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Selector<IllnessOptionsProvider, List<String>>(
      selector: (context, d) => d.illnessList,
      builder: (context, list, widget) {
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: list.length,
          itemBuilder: (context, i) {
            return ListItem(
              title: list[i],
              index: i,
            );
          },
        );
      },
    );
  }
}

class ListItem extends StatelessWidget {
  const ListItem({
    Key key,
    @required this.title,
    this.index,
  }) : super(key: key);

  final String title;
  final int index;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      padding: ThemeGuide.padding,
      decoration: ThemeGuide.boxDecorationBlack,
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(0),
        title: Text(
          Sanitizer.initialCapital(title),
          style: _theme.textTheme.headline6,
        ),
        leading: AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: _theme.primaryColor.withOpacity(0.2),
              borderRadius: ThemeGuide.borderRadius,
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: _theme.textTheme.headline6,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void onTap() {
    LocatorService.consultationProvider().setTitle =
        Sanitizer.initialCapital(title);
    LocatorService.illnessOptionsProvider().next();
  }
}
