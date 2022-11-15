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
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///
/// ## `Description`
///
/// Screen which allows the users to choose from the different format
/// to connect to the doctor.
/// Fetch the doctors list based on the choice of the user for instant connection.
///
class   Support extends StatelessWidget {
  const Support({this.category, this.assetUrl});

  final String category;
  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    final String newCategory =
        category ?? LocatorService.consultationProvider().title;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(AppStrings.chooseConsultFormat),
      ),
      body: Container(
        color: Colors.white,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            if (assetUrl != null) Header(assetUrl: assetUrl),
            DisplayCategory(category: newCategory ?? 'Not Available'),
            const SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                LocatorService.consultationProvider()
                    .setConsultationFormatType = ConsultationFormatType.CHAT;
                LocatorService.consultationProvider().setTitle = newCategory;
                NavigationController.navigator.push(Routes.doctorsList);
              },
              child: ChoiceContainer(
                heading: AppStrings.chatTitle,
                subHeading: '\n ${AppStrings.chatSub}',
                icon: SvgPicture.asset(
                  'lib/assets/svg/support.svg',
                  height: 40,
                ),
                color: const Color(0xFF9ECEF9),
              ),
            ),
            GestureDetector(
              onTap: () {
                LocatorService
                    .consultationProvider()
                    .setConsultationFormatType =
                    ConsultationFormatType.VOICE_CALL;
                LocatorService
                    .consultationProvider()
                    .setTitle = newCategory;
                NavigationController.navigator.push(Routes.doctorsList);
              },
              child: ChoiceContainer(
                heading: AppStrings.call,
                subHeading: '\n ${AppStrings.callSub}',
                icon: SvgPicture.asset(
                  'lib/assets/svg/contact.svg',
                  height: 40,
                ),
                color: const Color(0xFF9ECEF9),
              ),
            ),
            GestureDetector(
              onTap: () {
                LocatorService
                    .consultationProvider()
                    .setConsultationFormatType =
                    ConsultationFormatType.VIDEO_CALL;
                LocatorService
                    .consultationProvider()
                    .setTitle = newCategory;
                NavigationController.navigator.push(Routes.doctorsList);
              },
              child: ChoiceContainer(
                heading: AppStrings.videoCall,
                subHeading: '\n ${AppStrings.videoCallSub}',
                icon: SvgPicture.asset(
                  'lib/assets/svg/video.svg',
                  height: 40,
                ),
                color: const Color(0xFF9ECEF9),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DisplayCategory extends StatelessWidget {
  const DisplayCategory({
    Key key,
    @required this.category,
  }) : super(key: key);

  final String category;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 40, top: 40),
      child: RichText(
        text: TextSpan(
          text: '${AppStrings.category}: ',
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
              text: category ?? '',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 20.0,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ChoiceContainer extends StatelessWidget {
  const ChoiceContainer({
    Key key,
    @required this.heading,
    @required this.subHeading,
    @required this.icon,
    @required this.color,
  }) : super(key: key);

  final String heading;
  final String subHeading;
  final Widget icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, top: 12, right: 30, bottom: 12),
      margin: const EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          Container(
            child: icon,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.all(Radius.circular(15)),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: heading ?? '',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
                children: [
                  TextSpan(
                    text: subHeading ?? '',
                    style: const TextStyle(
                      color: Color.fromRGBO(200, 200, 200, 1),
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
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
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  const Header({
    Key key,
    this.assetUrl,
  }) : super(key: key);

  final String assetUrl;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: SvgPicture.asset(
        assetUrl,
        height: 200,
        width: 100,
      ),
    );
  }
}
