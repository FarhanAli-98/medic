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

import 'dart:convert';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/services/storage/localStorage.dart';
import 'package:doctor_consultation/services/storage/storageConstants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// FCM Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.

  //await Firebase.initializeApp();
  print(' --- background message received ---');
  print(message.notification.title ?? 'title empity');
  print(message.notification.body ?? 'body empity');
  final m = {
    'data': message.data,
    'notification': {
      'title': message.notification.title,
      'body': message.notification.body,
    }
  };

  // Todo(aniketmalik): Try and show a notification from a back handler.
  PushNotificationService().showNotification(
    title: message.notification.title,
    body: message.notification.body,
    payload: message,
  );

  print('Handling a background message: $m}');
}

class PushNotificationService {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  /// Initial notification setup on application startup.
  Future<void> registerNotification() async {
    _firebaseMessaging.requestPermission();

    // Force show notification on iOS and Android
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    // Handle notification when the application is in session
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log('onMessage: $message');
      print(message);

      String title = 'Appointment';
      String body = 'Please check your appointments';

      if (message.notification != null) {
        title = message.notification.title ?? title;
        body = message.notification.body ?? body;
      }

      showNotification(
        title: title,
        body: body,
        payload: message,
      );
      // Required to update appointment list on new notification
      LocatorService.appointmentsProvider()
          .fetchDoctorAppointmentsOnNotification();
    });

    // Handle notification when the application is in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('onResume:');
      print(message);

      // Required to update appointment list on new notification
      LocatorService.appointmentsProvider()
          .fetchDoctorAppointmentsOnNotification();

      if (message.data.containsKey('appointmentDocument')) {
        if (LocatorService.doctorProvider().doctor != null) {
          // Navigate to doctor's appointments screen.
          NavigationController.navigator.push(Routes.appointmentsDoctor);
        } else {
          // Navigate to appointments screen.
          NavigationController.navigator.push(Routes.appointments);
        }
      }
    });

    // Handle background message here
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    /// FCM handler when the application wakes from a terminated state.
    final RemoteMessage _initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (_initialMessage != null) {
      // It means the application woke up from a terminated state.
      log('onLaunch:');
      print(_initialMessage);

      if (_initialMessage.data.containsKey('appointmentDocument')) {
        LocatorService.notificationController().setNotificationClicked(true);
        LocatorService.notificationController()
            .setNotificationObject(_initialMessage);
      }
    }
  }

  void setUserToken(String userId) {
    _firebaseMessaging.getToken().then((token) async {
      log('User token: $token', name: 'PNS');

      // Compare token saved in the device before updating
      final String savedToken =
          await LocalStorage.getString(LocalStorageConstants.USER_PUSH_TOKEN);

      if (savedToken != null) {
        if (savedToken == token) {
          log('Token already up to date', name: 'PNS - setUserToken');
          return;
        }
      } else {
        await FirestoreService.setUserPushToken(userId, token);
        await LocalStorage.setString(
            LocalStorageConstants.USER_PUSH_TOKEN, token);
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void setDoctorToken(String doctorId) {
    _firebaseMessaging.getToken().then((token) async {
      log('Doctor token: $token', name: 'PNS');

      // Compare token saved in the device before updating
      final String savedToken =
          await LocalStorage.getString(LocalStorageConstants.DOCTOR_PUSH_TOKEN);

      if (savedToken != null) {
        if (savedToken == token) {
          log('Doctor Token already up to date', name: 'PNS - setDoctorToken');
          return;
        }
      } else {
        await FirestoreService.setDoctorPushToken(doctorId, token);
        await LocalStorage.setString(
            LocalStorageConstants.DOCTOR_PUSH_TOKEN, token);
      }
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  /// Updates users or doctors refresh token.
  ///
  /// ## `IMPORTANT`
  /// Run on app initialization after the user data is downloaded.
  /// Good place to run this is when user data or doctor data is fetched.
  void setRefreshedTokenFor({String userId, String doctorId}) {
    log('Listening for token change', name: 'PNS');
    _firebaseMessaging.onTokenRefresh.listen((String token) async {
      log('Token changed for userId $userId or doctorId $doctorId',
          name: 'PNS');
      // if there is a new token set to user or doctor
      if (userId != null) {
        try {
          await FirestoreService.setUserPushToken(userId, token);
        } catch (e) {
          log('$e', name: 'PNS');
          return;
        }
        return;
      }

      if (doctorId != null) {
        try {
          await FirestoreService.setDoctorPushToken(doctorId, token);
        } catch (e) {
          log('$e', name: 'PNS');
          return;
        }
        return;
      }
    });
  }

  Future<void> sendSuccessNotification(String id, String diseases) async {
    final FAuthUser user = await LocatorService.authService().currentUser();

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userDoc = await _firestore
        .collection('doctors')
        .doc(id)
        .collection('tokens')
        .get();
    if (userDoc != null) {
      userDoc.docs.forEach((element) async {
        await notifyDoctor(element.data()['pushToken'], user.email, diseases);
      });
    }

    showNotification(
      body: 'Appointments Schedule Successfully',
      title:
          'Your appointment has been schedule please keep active for meeting',
      payload: null,
    );
  }

  Future<void> notifyDoctor(String token, String name, String diseases) async {
    final func = FirebaseFunctions.instance.httpsCallable('notifySubscribers');
    final res = await func.call(<String, dynamic>{
      'targetDevices': token,
      'messageTitle': 'Appointments Schedule Successfully',
      'messageBody': 'Appointment create from $name patient of $diseases',
    });
    print("message was ${res.data as bool ? "sent!" : "not sent!"}");
  }

  /// Used to subscribe to specific topics
  Future<void> subscribeToTopic({
    String topic = Config.NOTIFICATION_SUBSCRIPTION_TOPIC,
  }) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  /// Configure how the local notifications are shown to the user when the
  /// application is in different states.
  Future<void> configLocalNotification() async {
    log('Calling from configure local notifications');
    const initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const initializationSettingsIOS = IOSInitializationSettings();
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (payload) async {
      log('Payload clicked', name: 'PNS');

      final message = json.decode(payload);
      print(message);

      if (message['data'].containsKey('appointmentDocument')) {
        if (LocatorService.doctorProvider().doctor != null) {
          // Navigate to doctor's appointments screen.
          NavigationController.navigator.push(Routes.appointmentsDoctor);
        } else {
          // Navigate to appointments screen.
          NavigationController.navigator.push(Routes.appointments);
        }
      }
      // Cancel so that the notification is not added many times
      _flutterLocalNotificationsPlugin.cancel(message['id'] as int ?? 0);
      return;
    });
  }

  Future<void> showNotification({
    @required String title,
    @required String body,
    RemoteMessage payload,
    bool isFullScreen = false,
  }) async {
    log('Showing notification');
    print('Title: $title\nBody: $body');
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'appointment_channel',
      'Appointment',
      'Appointment Notifications',
      playSound: true,
      enableVibration: true,
      importance: Importance.max,
      priority: Priority.max,
      visibility: NotificationVisibility.public,
      ticker: 'Appointment message',
      fullScreenIntent: isFullScreen,
      category: 'call',
      // Adding an insisting flag
      additionalFlags: Int32List.fromList(<int>[4]),
      ongoing: true,
    );
    const iOSPlatformChannelSpecifics = IOSNotificationDetails(
      presentAlert: true,
      presentSound: true,
    );
    final platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    final int _notificationId =
        payload?.notification?.hashCode ?? math.Random().nextInt(100);
    await _flutterLocalNotificationsPlugin.show(
      _notificationId,
      title,
      body,
      platformChannelSpecifics,
      payload: json.encode({
        'id': _notificationId,
        'isFullScreen': isFullScreen,
        'data': payload == null ? '' : payload.data,
        'notification': {'title': title, 'body': body}
      }),
    );
  }

  /// Functions to manage the initialization, configuration and all other notifications
  /// related things at Login or SignUp
  void manageNotificationsAtAuth({String userId, String doctorId}) {
    // call other functions
    subscribeToTopic();

    if (userId != null) {
      setUserToken(userId);
    }

    if (doctorId != null) {
      setDoctorToken(doctorId);
    }
  }
}
