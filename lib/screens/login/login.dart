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
import 'package:doctor_consultation/screens/login/form/loginForm.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/shared/dividerWithText.dart';
import 'package:doctor_consultation/shared/socialButtons/socialButtonsContainer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Login extends StatelessWidget {
  const Login({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SocialLoginLoadingOverlay(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            const LoginMessageTop(),
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
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 30,
                ),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(240, 240, 240, 1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  AppStrings.login,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            LoginForm(),
            const SizedBox(
              height: 10,
            ),
            const DividerWithText(
              text: AppStrings.or,
            ),
            SocialButtonsContainer(
              googleLable: AppStrings.loginWithGoogle,
              googleOnPress: () => AuthController.signInWithGoogle(),
              facebookLable: AppStrings.loginWithFacebook,
              facebookOnPress: () => AuthController.signInWithFacebook(),
            ),
            const SizedBox(
              height: 30,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  AppStrings.loginQues,
                  style: TextStyle(
                    color: Colors.black26,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () =>
                        NavigationController.navigator.replace(Routes.signup),
                    highlightColor: Colors.transparent,
                    child: const Text(
                      AppStrings.signup,
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
            const SizedBox(height: 30),
            const DoctorAccountSwitcher(),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SvgPicture.asset(
      'lib/assets/svg/cardiogram.svg',
      width: 200,
      height: 200,
    ));
  }
}
