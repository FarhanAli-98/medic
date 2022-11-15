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

import 'dart:convert';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/userProvider.dart';
import 'package:doctor_consultation/services/storage/localStorage.dart';
import 'package:doctor_consultation/services/storage/storageConstants.dart';

/// ## Description
///
/// This class handles the communication between the `User` class
/// and Global State related to `User` object.
@deprecated
abstract class UserViewModel {
  /// Gets the user provider but does not listen to
  /// updates.
  static UserProvider userProvider() {
    return locator<UserProvider>();
  }

  // static void updateNumber(String value) {
  //   userProvider().updateNumber(value);
  // }

  // static void updateImage(String url) {
  //   userProvider().updateImage(url);
  // }

  static void updateUserData(Map<String, dynamic> data) {
    userProvider().updateUserData(data);
  }

  // Set the userId in the provider for future reference.
  static Future<void> setUserId(String userId) async {
    LocatorService.userProvider().setUserId(userId);
  }

  // Set the user in the provider for future reference.
  static void setUser(String userData) {
    // Convert the string in to JSON
    final obj = jsonDecode(userData);
    //set the data now
    userProvider().setUser(obj);
  }

  // static void addAddress(Address value){
  //   userProvider(context).addAddress(value);
  // }

  // static void removeAddress(Address value){
  //   userProvider(context).removeAddress(value);
  // }

  /// Takes in a `Map<String, dynamic>` and saves it as a string with key `userData`
  /// to use in another session.
  static Future<void> saveAllCredentials(Map<String, dynamic> data) async {
    await LocalStorage.setString(
        LocalStorageConstants.USER_DATA, jsonEncode(data));
  }
}
