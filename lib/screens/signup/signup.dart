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
import 'package:doctor_consultation/controllers/authController.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/screens/signup/form/signupForm.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/shared/dividerWithText.dart';
import 'package:doctor_consultation/shared/socialButtons/socialButtonsContainer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Signup extends StatelessWidget {
  const Signup({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SocialLoginLoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height / 12,
            ),
            Center(
                child: SvgPicture.asset(
              'lib/assets/svg/cardiogram.svg',
              width: 200,
              height: 200,
            )),
            const SizedBox(
              height: 30,
            ),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: ThemeGuide.borderRadius10,
                ),
                child: const Text(
                  AppStrings.signup,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SignupForm(),
            const DividerWithText(text: AppStrings.or),
            SocialButtonsContainer(
              googleLable: AppStrings.signupWithGoogle,
              googleOnPress: () => AuthController.signInWithGoogle(),
              facebookLable: AppStrings.signupWithFacebook,
              facebookOnPress: () => AuthController.signInWithFacebook(),
            ),
            const SizedBox(height: 30),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppStrings.signUpQues,
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () =>
                        NavigationController.navigator.replace(Routes.login),
                    highlightColor: Colors.transparent,
                    child: const Text(
                      AppStrings.login,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFFE57373),
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 100,
            ),
          ],
        ),
      ),
    );
  }
}
