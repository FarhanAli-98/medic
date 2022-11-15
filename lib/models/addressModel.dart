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

/// Model calss to store `Address` information of the user.
class Address {
  Address({
    this.state,
    this.street,
    this.city,
    this.country,
    this.pin,
  });

  Address.fromMap(Map<String, dynamic> jsonData) {
    street = jsonData['street'] ?? '';
    city = jsonData['city'] ?? '';
    state = jsonData['state'] ?? '';
    pin = jsonData['pin'] ?? '';
    country = jsonData['country'] ?? '';
  }

  Address.empty() {
    street = '';
    city = '';
    state = '';
    pin = '';
    country = '';
  }

  String street, city, state, pin, country;

  Map<String, dynamic> toJson() {
    return {
      'state': state ?? '',
      'street': street ?? '',
      'city': city ?? '',
      'country': country ?? '',
      'pin': pin ?? '',
    };
  }
}
