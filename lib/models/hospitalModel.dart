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

import 'package:doctor_consultation/models/addressModel.dart';
import 'package:doctor_consultation/models/paymentModel.dart';
import 'package:flutter/foundation.dart';

class Hospital {
  Hospital({
    @required this.uid,
    @required this.name,
    this.email,
    this.bio,
    this.phoneNumber,
    this.specialities,
    this.imageUrl,
    this.address,
    this.payment,
  });

  Hospital.fromMap(Map jsonData) {
    uid = jsonData['uid'] ?? '';
    name = jsonData['name'] ?? '';
    bio = jsonData['bio'] ?? '';
    email = jsonData['email'] ?? '';
    phoneNumber = jsonData['phoneNumber'] ?? '';
    imageUrl = jsonData['imageUrl'] ?? '';
    specialities = jsonData['specialities'] != null
        ? jsonData['specialities'].cast<String>()
        : [];
    address = jsonData['address'] != null
        ? Address.fromMap(jsonData['address'])
        : Address.empty();
    payment = jsonData['payment'] != null
        ? Payment.fromMap(jsonData['payment'])
        : Payment.empty();
  }

  String uid, rating, name, email, bio, imageUrl, phoneNumber;
  List<String> specialities;
  Address address;
  Payment payment;
}
