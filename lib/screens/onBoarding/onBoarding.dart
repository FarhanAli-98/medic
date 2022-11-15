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
import 'package:doctor_consultation/services/storage/localStorage.dart';
import 'package:doctor_consultation/services/storage/storageConstants.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doctor_consultation/themes/theme.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  bool isDone = false;

  @override
  void initState() {
    super.initState();

    // Controller that controls the animation.
    _controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    // Type of animation to perform for `Logo`
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  static const PageDecoration _decoration = PageDecoration(
    bodyTextStyle: TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14.0,
      color: Colors.black38,
    ),
  );

  static List<PageViewModel> listPagesViewModel = [
    PageViewModel(
      title: AppStrings.title1,
      body: AppStrings.desc1,
      image: _buildImage('lib/assets/svg/doctor.svg'),
      decoration: _decoration,
    ),
    PageViewModel(
      title: AppStrings.title2,
      body: AppStrings.desc2,
      image: _buildImage('lib/assets/svg/info_coloured.svg'),
      decoration: _decoration,
    ),
    PageViewModel(
      title: AppStrings.title3,
      body: AppStrings.desc3,
      image: _buildImage('lib/assets/svg/contact.svg'),
      decoration: _decoration,
    ),
    PageViewModel(
      title: AppStrings.title4,
      body: AppStrings.desc4,
      image: _buildImage('lib/assets/svg/getStarted.svg'),
      decoration: _decoration,
    ),
  ];

  static Widget _buildImage(String assetUrl) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: ThemeGuide.borderRadius10,
        ),
        child: SvgPicture.asset(
          assetUrl,
          height: 200,
          width: 200,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  static Widget _buildButton({
    @required String title,
    Function onPress,
    Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: CupertinoButton(
        color: color ?? LightTheme.mRed,
        onPressed: () {
          onPress();
        },
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> updateInitialInstall() async {
    if (isDone) {
      await LocalStorage.setString(
          LocalStorageConstants.INITIAL_INSTALL, 'false');
    }
  }

  static void _goToLogin() {
    NavigationController.navigator.replace(Routes.login);
  }

  static void _goToSignUp() {
    NavigationController.navigator.replace(Routes.signup);
  }

  Future<void> onDone() async {
    setState(() {
      isDone = true;
    });
    // Update the initial install flag
    await updateInitialInstall();
  }

  @override
  Widget build(BuildContext context) {
    if (isDone) {
      _controller.forward();
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ScaleTransition(
            scale: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset(
                  'lib/assets/svg/getStarted.svg',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                  child: Text(
                    'Login so that you can have a personalized experience.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black38,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                _buildButton(
                  title: 'Login',
                  color: LightTheme.mRed,
                  onPress: () {
                    _goToLogin();
                  },
                ),
                _buildButton(
                  title: 'Signup',
                  color: LightTheme.mYellow,
                  onPress: () {
                    _goToSignUp();
                  },
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return IntroductionScreen(
        showNextButton: true,
        pages: listPagesViewModel,
        onDone: () {
          onDone();
        },
        showSkipButton: true,
        skip: const Text('Skip'),
        next: const Text('Next'),
        done: const Text(
          'Done',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        dotsDecorator: DotsDecorator(
          size: const Size.square(10.0),
          activeSize: const Size(20.0, 10.0),
          activeColor: LightTheme.mBlue,
          color: Colors.black12,
          spacing: const EdgeInsets.symmetric(horizontal: 3.0),
          activeShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      );
    }
  }
}
