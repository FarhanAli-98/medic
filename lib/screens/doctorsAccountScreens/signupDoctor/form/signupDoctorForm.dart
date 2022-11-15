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

// ignore_for_file: directives_ordering

import 'dart:developer';

import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/authController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/shared/textArea.dart';
import 'package:doctor_consultation/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/shared/customInput.dart';
import 'package:country_picker/country_picker.dart';

class SignupDoctorForm extends StatefulWidget {
  @override
  _SignupDoctorFormState createState() => _SignupDoctorFormState();
}

class _SignupDoctorFormState extends State<SignupDoctorForm> {
  String email,
      name,
      confirmPassword,
      password,
      experience,
      specialities,
      fee,
      registration,
      about;
  String selectedCountry = 'Select Country';
  bool _isLoading = false;
  String errorText = '';
  Country country;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomInput(
              placeholder: AppStrings.name,
              onChange: (val) => name = val,
              validator: validateName,
              prefixText: 'Dr. ',
            ),
            CustomInput(
              placeholder: AppStrings.emailLabel,
              onChange: (val) => email = val,
              validator: AuthController.validateEmail,
            ),
            CustomInput(
              placeholder: '${AppStrings.experience} ${AppStrings.years}',
              onChange: (val) => experience = val,
              validator: validateExp,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomInput(
              placeholder: AppStrings.fee,
              onChange: (val) => fee = val,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: validateFee,
              keyboardType: TextInputType.number,
              prefixText:
                  '${Config.CURRENCY_SYMBOL.isEmpty ? Config.CURRENCY : Config.CURRENCY_SYMBOL} ',
            ),
            CustomInput(
              placeholder: AppStrings.specialities,
              onChange: (val) => specialities = val,
              validator: validateSpecialities,
            ),
            CustomInput(
              placeholder: AppStrings.registration,
              onChange: (val) => registration = val,
              validator: validateSpecialities,
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
            CustomAreaInput(
              placeholder: AppStrings.signupAbout,
              onChange: (val) => about = val,
              validator: validateSpecialities,
              textarea: true,
            ),
            GestureDetector(
              onTap: () {
                showCountryPicker(
                  context: context,

                  //Optional. Shows phone code before the country name.
                  showPhoneCode: true,
                  showWorldWide: false,
                  onSelect: (Country country) {
                    setState(() {
                      print('Select country: ${country.displayName}');
                      selectedCountry = country.name;
                    });
                  },
                  // Optional. Sets the theme for the country list picker.
                  countryListTheme: CountryListThemeData(
                    // Optional. Sets the border radius for the bottomsheet.

                    // Optional. Styles the search field.
                    inputDecoration: InputDecoration(
                      labelText: 'Search',
                      hintText: 'Start typing to search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: const Color(0xFF8C98A8).withOpacity(0.2),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: Container(
                height: 40,
                width: 350,
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: _theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(child: Text(selectedCountry)),
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
            FooterLinks(),
          ],
        ),
      ),
    );
  }

  String validateName(String value) {
    if (value.length <= 3) {
      return AppStrings.invalidNameShort;
    }
    return null;
  }

  String validateExp(String value) {
    if (value.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (Validator.isExperienceValid(value)) {
      if (int.parse(value) <= 70) {
        return null;
      } else {
        return AppStrings.invalidExperienceTooMuch;
      }
    }
    return AppStrings.invalidExperience;
  }

  String validateFee(String value) {
    if (value.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (Validator.isFeeValid(value)) {
      // check if it is greater than 0
      if (int.parse(value) > 0) {
        return null;
      } else {
        return AppStrings.invalidFeeZero;
      }
    }
    return AppStrings.invalidFee;
  }

  String validateSpecialities(String val) {
    if (val.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (Validator.isSpecialitiesValid(val)) {
      return null;
    }
    return AppStrings.invalidSpecialities;
  }

  ///
  /// ## `Description`
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

      // creates the specialities array with lower case strings.
      List createSpecialities() {
        final list = <String>[];

        if (specialities != null && specialities.isNotEmpty) {
          final List<String> tempList = specialities.split(',');
          for (final e in tempList) {
            list.add(e.trim().toLowerCase());
          }
        }
        return list;
      }

      // Authenticate doctor
      try {
        final data = {
          'name': name,
          'experience': experience,
          'fee': fee,
          'specialities': createSpecialities(),
          'register': registration,
          'about': about
        };

        final result = await AuthController.signupDoctor(email, password, data);
        log(result.uid, name: 'Signup doctor uid');

        // If doctorId is not empty then set the doctorId in the provider
        if (result.uid.isNotEmpty) {
          final bool isDataAvailable =
              await LocatorService.doctorProvider().fetchDoctorData(result.uid);

          if (isDataAvailable) {
            AuthController.setDoctorId(result.uid);
            await AuthController.saveDoctorCredentials(result.uid, email);

            // Setup push notification for the user.
            LocatorService.pushNotificationService().manageNotificationsAtAuth(
              doctorId: result.uid,
            );

            // Navigate to home
            AuthController.navigateToDoctorHome();
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
        errorText = e.toString();
      }

      // Stop the indicator
      setState(() => _isLoading = !_isLoading);
    }
  }
}

class FooterLinks extends StatelessWidget {
  // Launch the terms of service URL
  Future<void> _launchURL1() async {
    const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  // Launch the privacy policy URL
  Future<void> _launchURL2() async {
    const url = 'https://flutter.dev';
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
              onTap: () => _launchURL1(),
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
              onTap: () => _launchURL2(),
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
