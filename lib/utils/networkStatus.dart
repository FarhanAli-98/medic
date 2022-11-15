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
import 'package:connectivity/connectivity.dart';

///
/// Checks the network status of the application to the internet.
/// Call this function before when you need to make sure you have
/// internet connection available.
///
abstract class NetworkStatus {
  static Future<bool> isConnected() async {
    final ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    bool result;

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      result = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      result = true;
    } else {
      // Not connected to the internet.
      result = false;
    }
    return result;
  }
}
