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

import 'package:doctor_consultation/services/storage/localStorage.dart';

Future<void> setToStorage(String key, String value) async {
  await LocalStorage.setString(key, value);
}

Future<String> getFromStorage(String key) async {
  return await LocalStorage.getString(key);
}
