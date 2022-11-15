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

import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/foundation.dart';

///
/// ## Description
///
/// Provider that handles `User` data in the state.
/// Cares about the user data after it has been loaded into memory from the server.
///
class UserProvider with ChangeNotifier {
  // Set the userId for the app when the user signup or login.
  String _userId = '';
  List<String> images = [];
  String get userId => _userId;
  void setUserId(String value) {
    log(value, name: 'UserProvider setUserId');
    _userId = value;
  }

  User _user;
  User get user => _user;
  void setUser(Map<String, dynamic> json) {
    _user = User.fromJson(json);
  }

  /// Clears all the data in the storage variables when the user sign out.
  /// Must only be run when the user sign out of an account.
  void clearData() {
    _userId = '';
    _user = null;
  }


  Future<bool> fetchUserData(String id) async {
    try {
      log('Fetching data for user id $id', name: 'UP');
      final Map<String, dynamic> result =
          await FirestoreService.getUserInfo(id);
      if (result != null) {
        setUser(result);

        // Initialize the push notification token stream to track refreshed token
        LocatorService.pushNotificationService().setRefreshedTokenFor(
          userId: result['uid'],
        );
        //listOfMediaImages(id);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString(), name: 'UP');
      return false;
    }
  }

  // updateName(String value) {
  //   _user.name = value;
  //   notifyListeners();
  // }

  // updatePassword(String value) {
  //   // Call the HTTP client and update the user password

  //   // Optional to call the following method to update the UI though recommended.
  //   // notifyListeners();
  // }

  // updateNumber(String value) {
  //   _user.phoneNumber = value;
  //   notifyListeners();
  // }

  // updateAge(String value) {
  //   _user.age = value;
  //   notifyListeners();
  // }

  // updateGender(String value) {
  //   _user.gender = value;
  //   notifyListeners();
  // }

  void updateImage(String url) {
    _user.imageUrl = url;
    notifyListeners();
  }

  Future<void> listOfMediaImages(String uid) async {
    images = await FirebaseStorageService.fetchImages(uid);
    log(images.length.toString(), name: 'IMAGES FROM FIREBASE');
    notifyListeners();
  }

  void addMediaImages(String url) {
    images.add(url);
    notifyListeners();
  }

  void updateUserData(Map<String, dynamic> data) {
    final tempUser = _user.toJson();
    data.forEach((key, value) {
      tempUser[key] = value;
    });
    // set user again
    setUser(tempUser);
    notifyListeners();
  }
}
