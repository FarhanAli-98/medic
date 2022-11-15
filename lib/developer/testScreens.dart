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

import 'package:doctor_consultation/developer/playgorund.dart';
import 'package:doctor_consultation/screens/accountInfo/editProfileInfo.dart';
import 'package:doctor_consultation/screens/accountInfo/medicineCourse.dart';
import 'package:doctor_consultation/screens/accountInfo/appointments/appointments.dart';
import 'package:doctor_consultation/screens/accountInfo/savedBlogs.dart';
import 'package:doctor_consultation/screens/chat/chat.dart';
import 'package:doctor_consultation/screens/search/searchScreen.dart';
import 'package:flutter/widgets.dart';

abstract class TestScreens {
  static Widget build() {
    return chat;
  }

  static const Widget editProfile = EditProfile();
  static const Widget appointments = Appointments();
  static const Widget medicineCourse = MedicineCourse();
  static const Widget savedBlogs = SavedBlogs();
  static const Widget searchScreen = SearchScreen();
  static const Widget chat = Chat();

  // Test screen
  static const Widget playgroung = Playground();
}
