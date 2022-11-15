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
import 'package:doctor_consultation/screens/support/support.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

///
/// ## `Description`
///
/// Modal to fetch all the list of the consultation display
/// to the user to choose from.
///
class FormatOptionsModal extends StatelessWidget {
  const FormatOptionsModal({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.chooseConsultFormat),
      ),
      body: ChangeNotifierProvider<ConsultationProvider>.value(
        value: LocatorService.consultationProvider(),
        child: const ListContainer(),
      ),
    );
  }
}

class ListContainer extends StatelessWidget {
  const ListContainer({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      children: [
        GestureDetector(
          onTap: () {
            LocatorService.consultationProvider().setConsultationFormatType =
                ConsultationFormatType.CHAT;
            NavigationController.navigator.pop();
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
            LocatorService.consultationProvider().setConsultationFormatType =
                ConsultationFormatType.VOICE_CALL;
            NavigationController.navigator.pop();
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
            LocatorService.consultationProvider().setConsultationFormatType =
                ConsultationFormatType.VIDEO_CALL;
            NavigationController.navigator.pop();
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
    );
  }
}
