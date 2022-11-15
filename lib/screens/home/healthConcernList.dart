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
import 'package:doctor_consultation/screens/support/support.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// ## [Description]
///
/// Health Concern List widget that contains the options for
/// geneal category selection.
/// Returns a horizontal list which is hard coded in.
/// To use more than 5 options, define an array of options and use that to render
/// each element.
///
class HealthConcernList extends StatelessWidget {
  const HealthConcernList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 40, top: 0, right: 20, bottom: 00),
          child: Text(
            AppStrings.searchHealthConcern,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
            left: 40,
            right: 40,
            top: 20,
            bottom: 20,
          ),
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: <Widget>[
              buildChoiceContainer(
                heading: AppStrings.generalDoctor,
                icon: SvgPicture.asset(
                  'lib/assets/svg/doctor.svg',
                  height: 40,
                ),
                color: const Color(0xFF9ECEF9),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const Support(
                        category: AppStrings.generalDoctor2,
                        assetUrl: 'lib/assets/svg/doctor.svg',
                      ),
                    ),
                  );
                },
              ),
              buildChoiceContainer(
                heading: AppStrings.dentalCare,
                icon: SvgPicture.asset(
                  'lib/assets/svg/dental.svg',
                  height: 40,
                ),
                color: const Color(0xFFF1A7F2),
                onPressed: () {
                  Navigator.of(context).push(
                    CupertinoPageRoute(
                      builder: (context) => const Support(
                        category: AppStrings.dentalCare2,
                        assetUrl: 'lib/assets/svg/dental.svg',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  ///
  /// ## `Description`
  ///
  /// Function that returns a widget which takes care of the touch event
  /// and serves as the item layout for the list.
  ///
  GestureDetector buildChoiceContainer(
      {String heading, Widget icon, Color color, Function onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding:
            const EdgeInsets.only(left: 12, top: 12, right: 30, bottom: 12),
        margin: const EdgeInsets.only(right: 20),
        child: Row(
          children: <Widget>[
            Container(
              child: icon,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Text(
              heading ?? '',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(235, 235, 235, 1),
              spreadRadius: 0,
              blurRadius: 10,
            )
          ],
        ),
      ),
    );
  }
}
