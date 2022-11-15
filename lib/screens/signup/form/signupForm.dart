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

import 'dart:developer';

import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/authController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/shared/customInput.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key key}) : super(key: key);
  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  String email;
  String password;
  String confirmPassword;
  bool _isLoading = false;
  String errorText = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///
  /// ## Decription
  ///
  /// Triggers methods to handle:
  ///
  /// - Form validation
  /// - Firebase Authentication
  ///
  /// ### Functional Flow:
  ///
  /// 1. Show the loading indicator
  /// 2. Start authenticating service
  ///
  /// `Note`: Always wrap an authentication request in a try-catch block
  ///
  Future<void> buttonFun(BuildContext context) async {
    if (AuthController.validateForm(_formKey)) {
      // Start the indicator
      setState(() => _isLoading = !_isLoading);

      // Authenticate
      try {
        final result = await AuthController.signup(email, password);
        log('${result.uid} - ${result.email}',
            name: 'Signup user uid and email');

        // If userId is not empty then set the userId in the provider
        if (result.uid.isNotEmpty) {
          // Get the user data
          final bool isDataAvailable =
              await LocatorService.userProvider().fetchUserData(result.uid);

          if (isDataAvailable) {
            AuthController.setUserId(result.uid);
            await AuthController.saveCredentials(result.uid, email);

            // Setup push notification for the user.
            LocatorService.pushNotificationService().manageNotificationsAtAuth(
              userId: result.uid,
            );

            // Navigate to HomePage
            AuthController.navigateToHome();
          } else {
            errorText =
                'Could not get the data for this email. Please try again';
          }
        } else {
          errorText = 'Could not find the account. Please try again';
        }
      } on PlatformException catch (e) {
        errorText = e.message.toString();
        log(e.message, name: 'Error log: Signup page');
      } catch (e) {
        errorText = '$e';
      }

      // Stop the indicator
      setState(() => _isLoading = !_isLoading);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomInput(
              placeholder: AppStrings.emailLabel,
              onChange: (val) => email = val,
              validator: AuthController.validateEmail,
            ),
            CustomInput(
              placeholder: AppStrings.passwordLabel,
              onChange: (val) => password = val,
              validator: (val) => AuthController.validatePassword(password),
            ),
            CustomInput(
              placeholder: AppStrings.confirmPasswordLabel,
              onChange: (val) => confirmPassword = val,
              validator: (val) => AuthController.validateConfirmPassword(
                confirmPassword,
                password,
              ),
            ),
            Submit(
              onPress: () => buttonFun(context),
              isLoading: _isLoading,
              lable: AppStrings.signup,
            ),
            ShowError(
              text: errorText,
            ),
            const FooterLinks(),
          ],
        ),
      ),
    );
  }
}

class FooterLinks extends StatelessWidget {
  const FooterLinks({Key key}) : super(key: key);
  // Launch the terms of service URL
  Future<void> _termsOfService() async {
    const url = Config.TERMS_OF_SERVICE_URL;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Launch the privacy policy URL
  Future<void> _privacyPolicy() async {
    const url = Config.PRIVACY_POLICY_URL;
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return DefaultTextStyle(
      style: _theme.textTheme.caption.copyWith(
        color: const Color.fromRGBO(200, 200, 200, 1),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Wrap(
          runSpacing: 2,
          alignment: WrapAlignment.center,
          children: <Widget>[
            const Text(AppStrings.tosPreText),
            GestureDetector(
              onTap: () => _termsOfService(),
              child: const Text(
                AppStrings.termsOfService,
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                ),
              ),
            ),
            const Text(
              ' ${AppStrings.and} ',
            ),
            GestureDetector(
              onTap: () => _privacyPolicy(),
              child: const Text(
                AppStrings.privacyPolicy,
                style: TextStyle(
                  color: Color(0xFF64B5F6),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
