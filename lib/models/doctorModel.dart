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

import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/models/addressModel.dart';
import 'package:doctor_consultation/models/paymentModel.dart';
import 'package:flutter/foundation.dart';

class Doctor {
  Doctor(
      {@required this.uid,
      @required this.name,
      this.fee,
      this.specialities,
      this.address,
      this.payment,
      this.experience,
      this.imageUrl,
      this.email,
      this.about,
      this.online,
      this.coin,
      this.registerid})
      : assert(uid != null),
        assert(name != null);

  Doctor.fromMap(Map<String, dynamic> jsonData) {
    uid = jsonData['uid'];
    name = jsonData['name'];
    registerid = jsonData['register'];
    about = jsonData['about'];
    fee = jsonData['fee'] != null ? jsonData['fee'].toString() : '';
    specialities = jsonData['specialities'] != null
        ? jsonData['specialities'].cast<String>()
        : [];
    address = jsonData['address'] != null
        ? Address.fromMap(jsonData['address'])
        : Address.empty();
    payment = jsonData['payment'] != null
        ? Payment.fromMap(jsonData['payment'])
        : Payment.empty();
    experience =
        jsonData['experience'] != null ? jsonData['experience'].toString() : '';
    email = jsonData['email'] ?? '';
    imageUrl = jsonData['imageUrl'] ?? Config.placeholedImageUrl;
    online = jsonData['online'] ?? false;
    coin = jsonData['coin'] ?? 0.0;
  }
  String uid, name, imageUrl, experience, email, fee, about, registerid;
  bool online;
  double coin;
  List<String> specialities;
  Address address;
  Payment payment;

  Map<String, dynamic> toJson() {
    return {
      'uid': uid ?? '',
      'name': name ?? '',
      'fee': fee ?? '',
      'specialities': specialities ?? '',
      'address': address != null ? address.toJson() : '',
      'payment': payment != null ? payment.toJson() : '',
      'experience': experience ?? '',
      'imageUrl': imageUrl ?? '',
      'email': email ?? '',
      'about': about ?? '',
      'register': registerid ?? '',
      'online': online ?? false,
      'coin': coin ?? 0
    };
  }
}
