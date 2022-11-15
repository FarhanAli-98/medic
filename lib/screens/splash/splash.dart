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

// ignore_for_file: unused_field

import 'dart:developer';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/services/storage/localStorage.dart';
import 'package:doctor_consultation/services/storage/storageConstants.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation, _textAimation;

  // Auth variables
  FAuthUser _user;
  String _accountType;
  bool _isUserLoggedIn = false,
      _isDocAvailable = false,
      _isUserDocAvailable = false,
      _initialInstall = false;

  @override
  void initState() {
    super.initState();

    // Controller that controls the animation.
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    // Type of animation to perform for `Logo`
    _animation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.2, 1.0, curve: Curves.elasticOut),
    );

    // Animation for the text => `Name of the application`
    _textAimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.6, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Listen to animation completion
    _controller.addStatusListener(handler);

    // Starts the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Very Important to dispose the controller for optimization.
    _controller.removeStatusListener(handler);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          color: Colors.white,
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'lib/assets/images/splash.png',
            fit: BoxFit.fitWidth,
          )
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: <Widget>[
          //     ScaleTransition(
          //       scale: _animation,
          //       child: Image.asset(
          //         'lib/assets/images/app_icon.png',
          //         width: 300,
          //         height: 300,
          //       ),
          //     ),
          //     const SizedBox(
          //       height: 50,
          //     ),
          //     FadeTransition(
          //       opacity: _textAimation,
          //       child: Text(
          //         Config.SPLASH_SCREEN_HEADING,
          //         style: Theme.of(context)
          //             .textTheme
          //             .headline6
          //             .copyWith(color: Colors.black),
          //         textAlign: TextAlign.center,
          //       ),
          //     ),
          //   ],
          // ),
          ),
    );
  }

  /// Check the user logged in status simultaneously as the animation
  /// runs. Main function is to set the flags for controlled navigation
  /// after splash screen animation ends.
  Future<void> checkUserStatus() async {
    log('Checking user status', name: 'Splash Screen');
    _user = await LocatorService.authService().currentUser();

    _isUserLoggedIn = _user != null || false;

    // check the account type
    _accountType =
        await LocalStorage.getString(LocalStorageConstants.ACCOUNT_TYPE);

    // If the user is logged in then go to `Home` else go to `Login` else if it is
    // initial install go to onboarding.
    if (_isUserLoggedIn) {
      if (_accountType == LocalStorageConstants.DOCTOR_ACCOUNT_TYPE) {
        // then load the doctor files
        _isDocAvailable =
            await LocatorService.doctorProvider().fetchDoctorData(_user.uid);
             LocatorService.appointmentsProvider().fetchDoctorsData();
      } else {
        // Get the data from the firebase firestore and put in UserProvider for
        // global access.
        _isUserDocAvailable =
            await LocatorService.userProvider().fetchUserData(_user.uid);
        LocatorService.pushNotificationService().setUserToken(_user.uid);
           LocatorService.appointmentsProvider().fetchData();
       
     
      }
    } else {
      final initial =
          await LocalStorage.getString(LocalStorageConstants.INITIAL_INSTALL);
      _initialInstall = initial == null || false;
    }
  }

  /// Listen for animation changes
  Future<void> handler(AnimationStatus status) async {
    if (status == AnimationStatus.completed) {
      log('Animation complete', name: 'Splash screen');
      await checkUserStatus();
      if (_isDocAvailable) {
        NavigationController.navigator.replace(Routes.homeDoctor);
        if (LocatorService.notificationController().isNotificationClicked) {
          NavigationController.navigator.pushAndRemoveUntil(
            Routes.appointmentsDoctor,
            ModalRoute.withName(Routes.homeDoctor),
          );
          return;
        } else {
          NavigationController.navigator.replace(Routes.homeDoctor);
          return;
        }
      }

      if (_isUserDocAvailable) {
        // Add onLaunch notification checker to navigate to a specific screen.
        if (LocatorService.notificationController().isNotificationClicked) {
          NavigationController.navigator.pushAndRemoveUntil(
            Routes.appointments,
            ModalRoute.withName(Routes.home),
          );
          return;
        } else {
          NavigationController.navigator.replace(Routes.home);
          return;
        }
      }

      if (_initialInstall) {
        NavigationController.navigator.replace(Routes.onBoarding);
        return;
      } else {
        NavigationController.navigator.replace(Routes.login);
        return;
      }
    }
  }
}
