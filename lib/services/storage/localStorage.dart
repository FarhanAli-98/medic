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

import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

///
/// ## Description
///
/// Stores the information about `User`, `User settings` and likely
/// values used for the application in the future.
///
/// Use this class to store data for the application in the local
/// device. (Use only to store small amounts of data)
///
abstract class LocalStorage {
  static Future<void> setString(String key, Object value) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: key, value: value);
  }

  static Future<String> getString(String key) async {
    const storage = FlutterSecureStorage();
    return await storage.read(key: key);
  }

  static Future<Map<String, String>> getAll() async {
    const storage = FlutterSecureStorage();
    return await storage.readAll();
  }
}
