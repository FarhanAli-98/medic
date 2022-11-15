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
import 'package:doctor_consultation/screens/doctorsAccountScreens/loginDoctor/form/loginDoctorForm.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/shared/dividerWithText.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoginDoctor extends StatelessWidget {
  const LoginDoctor({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
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
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(240, 240, 240, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                AppStrings.loginAsDoctor,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const LoginDoctorForm(),
          const DividerWithText(
            text: AppStrings.or,
          ),
          const SizedBox(
            height: 20,
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
                  onTap: () => NavigationController.navigator
                      .replace(Routes.signupDoctor),
                  highlightColor: Colors.transparent,
                  child: const Text(
                    AppStrings.signupAsDoctor,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: Color(0xFFE57373),
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 30,
          ),
          const NormalAccountSwitcher(),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
