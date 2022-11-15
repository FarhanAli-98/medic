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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/widgets/illnessOptionsModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// ## `Description`
///
/// Widget that returns the main list of categories displayed
/// to the user to select from.
/// Returns a horizontal list of illness with SVG assets in card
/// format.
///
class CategoryOptions extends StatefulWidget {
  const CategoryOptions({Key key}) : super(key: key);
  List<Map<String, String>> get choiceList => const <Map<String, String>>[
        {'heading': 'Cough', 'svgUrl': 'lib/assets/svg/cough.svg'},
        {'heading': 'Cold', 'svgUrl': 'lib/assets/svg/nose.svg'},
        {'heading': 'Fever', 'svgUrl': 'lib/assets/svg/thermometer.svg'},
        {'heading': 'Skin', 'svgUrl': 'lib/assets/svg/rash.svg'},
        {'heading': 'Allergy', 'svgUrl': 'lib/assets/svg/allergy.svg'},
        {'heading': 'Flu', 'svgUrl': 'lib/assets/svg/headache.svg'},
        {'heading': 'Stomach', 'svgUrl': 'lib/assets/svg/stomach.svg'},
        {'heading': 'Eye', 'svgUrl': 'lib/assets/svg/eye.svg'},
        {'heading': 'Bone', 'svgUrl': 'lib/assets/svg/bicepBones.svg'},
        {'heading': 'Spine', 'svgUrl': 'lib/assets/svg/spine.svg'},
        {'heading': 'Diabetes', 'svgUrl': 'lib/assets/svg/bloodCheck.svg'},
      ];
  List<Color> get colorList => const <Color>[
        Color(0xaaE090C9),
        Color(0xaaFBBA7B),
        Color(0xaaF59482),
        Color(0xaaE090C9),
      ];
  @override
  _CategoryOptionsState createState() => _CategoryOptionsState();
}

class _CategoryOptionsState extends State<CategoryOptions> {
  int _colorIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Align(
          alignment: Alignment.centerRight,
          child: FlatButton(
            onPressed: () {
              LocatorService.illnessOptionsProvider().setRouteTo = () {
                NavigationController.navigator.push(Routes.support);
              };
              UiController.showModal(context, IllnessOptionsModal());
            },
            child: const Text(AppStrings.seeAll),
          ),
        ),
        Container(
          height: 300,
          padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
          child: ListView.builder(
            itemCount: widget.choiceList.length,
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (index % 3 == 0 || index == 3) {
                _colorIndex = 0;
              }
              final Widget item = buildChoiceContainer(
                heading: widget.choiceList[index]['heading'],
                backgroundColor: widget.colorList[_colorIndex],
                svgUrl: widget.choiceList[index]['svgUrl'],
                onPress: () {
                  LocatorService.consultationProvider().setTitle =
                      widget.choiceList[index]['heading'];

                  NavigationController.navigator.push(
                    Routes.support,
                    arguments: SupportArguments(
                      category: widget.choiceList[index]['heading'],
                      assetUrl: widget.choiceList[index]['svgUrl'],
                    ),
                  );
                },
              );
              _colorIndex += 1;
              return item;
            },
          ),
        ),
      ],
    );
  }

  ///
  /// ## `Description`
  ///
  /// Function which returns a widget that takes care of the touch event and
  /// serves as the item layout for the list.
  ///
  GestureDetector buildChoiceContainer({
    String heading,
    Color backgroundColor,
    String svgUrl,
    Function onPress,
  }) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        width: 180,
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: backgroundColor,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  heading ?? ' ',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                width: 180,
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SvgPicture.asset(
                  svgUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
