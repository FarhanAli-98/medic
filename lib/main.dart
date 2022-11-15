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

import 'dart:io';
import 'package:get/get.dart';
import 'package:auto_route/auto_route.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/routes/router.gr.dart' as nav;
import 'package:doctor_consultation/services/pushNotification/pushNotificationService.dart';
import 'package:doctor_consultation/themes/theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget { 
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
    
     MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => LocatorService.userProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => LocatorService.doctorProvider(),
        ),
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doctor Consultation',
        theme: CustomeTheme.lightTheme,
        onGenerateRoute: nav.Router(),
        builder: ExtendedNavigator.builder(router: nav.Router()),
      ),
    );
  }
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  setupLocator();

  if (Platform.isAndroid) {
    // Overrides the status bar and navigation style
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      statusBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
    ));
  }

  // Register for local and remote notifications
  PushNotificationService().registerNotification();
  PushNotificationService().configLocalNotification();
  runApp(const MyApp());
  
}
