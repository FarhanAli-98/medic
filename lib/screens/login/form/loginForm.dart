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

import 'package:doctor_consultation/controllers/authController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/shared/customInput.dart';

class LoginForm extends StatefulWidget {
  @override
  LoginFormState createState() => LoginFormState();
}

class LoginFormState extends State<LoginForm> {
  String email;
  String password;
  bool _isLoading = false;
  String errorText = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///
  /// ## `Decription`
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
  Future<void> buttonFun() async {
    if (AuthController.validateForm(_formKey)) {
      // Start the indicator
      setState(() => _isLoading = !_isLoading);

      // Authenticate
      try {
        final result = await AuthController.login(email, password);
        // log('${result.uid}', name: 'Login user uid');

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
        // log(e.message, name: 'Error message: Login page');
        // log(e.code, name: 'Error code: Login page');
      } catch (e) {
        errorText = AppStrings.somethingWentWrong;
        // log(e, name: 'Error: Login Page');
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
            Submit(
              onPress: () => buttonFun(),
              isLoading: _isLoading,
              lable: AppStrings.login,
            ),
            ShowError(
              text: errorText,
            ),
            const ForgotPassword()
          ],
        ),
      ),
    );
  }
}
