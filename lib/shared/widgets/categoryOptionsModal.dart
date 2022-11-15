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
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/shared/widgets/illnessOptionsModal.dart';
import 'package:flutter/material.dart';
import 'package:doctor_consultation/screens/home/categoryOptions.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:doctor_consultation/locator.dart';

class CategoryOptionsModal extends StatelessWidget {
  final choiceList = const CategoryOptions().choiceList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.choose + ' ' + AppStrings.illness),
        actions: <Widget>[
          FlatButton(
            child: const Text(AppStrings.seeAll),
            onPressed: () {
              NavigationController.navigator.pop();
              LocatorService.illnessOptionsProvider().setRouteTo = () {};
              UiController.showModal(context, IllnessOptionsModal());
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(color: Colors.white10),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          itemCount: choiceList.length,
          itemBuilder: (context, i) {
            return _buildItem(context, choiceList[i]);
          },
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, Map<String, String> obj) {
    return GestureDetector(
      onTap: () {
        LocatorService.consultationProvider().setTitle = obj['heading'];
        Navigator.of(context).pop();
      },
      child: Container(
        margin: ThemeGuide.padding,
        padding: ThemeGuide.padding10,
        decoration: ThemeGuide.boxDecorationBlack,
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              obj['svgUrl'],
              fit: BoxFit.contain,
              height: 80,
            ),
            const SizedBox(width: 20),
            Text(
              obj['heading'],
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
    );
  }
}
