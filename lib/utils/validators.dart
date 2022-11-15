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

import 'package:email_validator/email_validator.dart';

///
/// ## `Description`
///
/// All the user input must be validated before submitting to
/// database. Use this class to `validate` all kinds of data
/// that a user can input into the application.
///
class Validator {
  ///
  /// Validates the email.
  static bool isEmailValid(String email) {
    return EmailValidator.validate(email);
  }

  ///
  /// Validate `Fee` doctor input to only allow
  /// numbers and no other values.
  ///
  static bool isFeeValid(String value) => !RegExp('[^0-9]').hasMatch(value);

  ///
  /// Validate `Experience` doctor input to only allow
  /// numbers and no other values.
  ///
  static bool isExperienceValid(String value) =>
      !RegExp('[^0-9]').hasMatch(value);

  ///
  /// Validate `Specialities` doctor input to only allow
  /// alphabet and numbers
  ///
  static bool isSpecialitiesValid(String value) =>
      !RegExp('[^a-zA-Z0-9,\\s]').hasMatch(value);

  ///
  /// Validate if the given string is a number or not
  ///
  static bool isValidNumber(String value) => !RegExp('[^0-9]').hasMatch(value);

  /// Check if the amount is valid to process payment.
  static bool isAmountValid(String value) {
    try {
      final int len = value.length;

      if (len == 0) {
        return false;
      }

      // check if it is a valid number
      return isValidNumber(value);
    } catch (e) {
      return false;
    }
  }
}
