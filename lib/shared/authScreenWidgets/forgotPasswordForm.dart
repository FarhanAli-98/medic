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

import 'package:doctor_consultation/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordForm extends StatefulWidget {
  const ForgotPasswordForm({Key key}) : super(key: key);
  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<ForgotPasswordForm> {
  String email;
  bool _isLoading = false;
  String errorText = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Container(
        padding: const EdgeInsets.all(20.0),
        margin: ThemeGuide.padding10,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: ThemeGuide.borderRadius20,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 200,
              child: Center(
                child: FractionallySizedBox(
                  heightFactor: 0.4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        AppStrings.forgotPassword,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ClipRRect(
                        borderRadius: ThemeGuide.borderRadius,
                        child: Form(
                          key: _formKey,
                          child: TextFormField(
                            maxLines: 1,
                            onChanged: (val) => email = val,
                            decoration: const InputDecoration(
                              hintText: AppStrings.email,
                            ),
                            validator: validateEmail,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: Text(
                          AppStrings.resetPasswordMessage,
                          style: Theme.of(context).textTheme.caption,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      ShowError(
                        text: errorText,
                      ),
                      Submit(
                        isLoading: _isLoading,
                        lable: AppStrings.submit,
                        onPress: () => submit(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String validateEmail(String val) {
    if (val.isEmpty) {
      return AppStrings.invalidEmailEmpty;
    }

    if (Validator.isEmailValid(val)) {
      return null;
    }
    return AppStrings.invalidEmailErrorText;
  }

  Future<void> submit() async {
    if (_formKey.currentState.validate()) {
      try {
        setState(() {
          _isLoading = !_isLoading;
          errorText = '';
        });

        // Send password reset email
        await LocatorService.authService()
            .sendPasswordResetEmail(email)
            .then((_) {
          Fluttertoast.showToast(msg: AppStrings.resetLinkSentMessage);
          Navigator.of(context).pop();
        });

        setState(() {
          _isLoading = !_isLoading;
          errorText = '';
        });
      } catch (e) {
        log('It is not listening');
        setState(() {
          _isLoading = !_isLoading;
          errorText = e.message.toString();
        });
      }
    }
  }
}
