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

import 'package:flutter/foundation.dart';

/// Model class to store `User` information
class User {
  User({
    @required this.uid,
    @required this.name,
    @required this.email,
    this.age,
    this.imageUrl,
    this.gender,
    this.dob,
    this.phoneNumber,
  })  : assert(uid != null),
        assert(name != null),
        assert(email != null);

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'] ?? '';
    email = json['email'] ?? '';
    age = json['age'];
    imageUrl = json['imageUrl'];
    gender = json['gender'];
    dob = json['dob'];
    phoneNumber = json['phoneNumber'];
  }
  String uid, name, phoneNumber, email, gender, dob, imageUrl, age;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid ?? '',
      'name': name ?? '',
      'email': email ?? '',
      'age': age ?? '',
      'imageUrl': imageUrl ?? '',
      'gender': gender ?? '',
      'dob': dob ?? '',
      'phoneNumber': phoneNumber ?? '',
    };
  }
}

///
/// ## Description
///
/// Model class for the firebase user.
/// Only takes the `id` and `email` of the user.
///
/// Note: Do not use for storing user info except to check if user is present.
///
class FAuthUser {
  FAuthUser({
    @required this.uid,
    @required this.email,
  }) : assert(uid != null);

  String uid, email;
}
