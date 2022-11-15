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
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/developer/mock/blogsData.dart';
import 'package:doctor_consultation/developer/mock/hospitalData.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/blogModel.dart';
import 'package:doctor_consultation/models/chatMessageModel.dart';
import 'package:doctor_consultation/providers/doctorProvider.dart';
import 'package:fluttertoast/fluttertoast.dart';

///
/// ## Description
///
/// Class that handles all the `FirebaseFirestore CRUD` operations.
///
abstract class FirestoreService {
  /// Important - Run the function when user sign up
  /// Create a users in specified collection
  static Future<void> createUser(
    String uid,
    String email,
  ) async {
    final userId = uid;

    log('Creating user with User id - $userId',
        name: 'FirebaseFirestore service');

    if (userId == null) {
      // throw Exception('No user id found in UserProvider');
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final data = {
      'uid': userId,
      'email': email,
      'phoneNumber': '',
      'age': '',
      'name': email != null ? email.split('@')[0] : userId.substring(0, 7),
      'imageUrl': Config.placeholedImageUrl,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').doc(userId).set(data);
  }

  // Returns a map of user data
  static Future<Map<String, dynamic>> getUserInfo(String userId) async {
    if (userId == null) {
      // throw Exception('No user id found in UserProvider');
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return null;
    }

    // UserId is present then get the information.
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userDoc = await _firestore.collection('users').doc(userId).get();
    if (userDoc != null) {
      return userDoc.data();
    } else {
      Fluttertoast.showToast(msg: 'Internet may not be available');
      return null;
    }
  }

  static Future<void> updateImageUrl(String url, {String uid}) async {
    final userId = uid ?? LocatorService.userProvider().user?.uid;

    log('user id - $userId', name: 'FirebaseFirestore service');

    if (userId == null) {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').doc(userId).update({
      'imageUrl': url,
    });
  }

  static Future<void> updateUserData(Map<String, dynamic> data,
      {String uid}) async {
    final userId = uid ?? LocatorService.userProvider().user.uid;

    log('Performing update for User id - $userId',
        name: 'FirebaseFirestore service');

    if (userId == null) {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('users').doc(userId).update(data);
  }

  static Future<void> setUserPushToken(String userId, String pushToken) async {
    log('Setting user push token', name: 'FS');
    if (userId.isNotEmpty && pushToken.isNotEmpty) {
      final data = {
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'pushToken': pushToken,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      };
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('tokens')
          .doc(pushToken)
          .set(data);
    } else {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }
  }

  // *********************************************************************
  // Doctor Specific functions
  // *********************************************************************

  /// Important - Run the funtion when a doctor sign up. Create a doctor in specified collection
  static Future<void> createDoctor(
    String uid,
    String email,
    Map<String, dynamic> newData,
  ) async {
    final userId = uid;

    log('Creating doctor with User id - $userId',
        name: 'FirebaseFirestore service');

    if (userId == null) {
      // throw Exception('No user id found in UserProvider');
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final data = {
      'uid': userId,
      'email': email,
      'phoneNumber': '',
      'experience': '',
      'name': email != null ? email.split('@')[0] : userId.substring(0, 7),
      'imageUrl': Config.placeholedImageUrl,
      ...newData,
      'address': {
        'street': '',
        'city': '',
        'state': '',
        'pin': '',
        'country': '',
      },
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('doctors').doc(userId).set(data);
  }

  /// `Update doctor data`
  static Future<void> updateDoctorData(Map<String, dynamic> data,
      {String uid}) async {
    final userId = uid ?? locator<DoctorProvider>().doctor.uid;

    log('Performing update for Doctor id - $userId',
        name: 'FirebaseFirestore service - update doctor data');

    if (userId == null) {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('doctors').doc(userId).update(data);
  }

  /// `Update doctor address`
  static Future<void> updateDoctorAddress(Map<String, dynamic> data,
      {String uid}) async {
    final userId = uid ?? locator<DoctorProvider>().doctor.uid;

    log('Doctor id - $userId',
        name: 'FirebaseFirestore service address update');

    if (userId == null) {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('doctors').doc(userId).update({
      'address': data,
    });
  }

  static Future<void> updateDoctorPayment(Map<String, dynamic> data,
      {String uid}) async {
    final userId = uid ?? locator<DoctorProvider>().doctor.uid;

    log('Doctor id - $userId',
        name: 'FirebaseFirestore service payment update');

    if (userId == null) {
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('doctors').doc(userId).update({
      'payment': data,
    });
  }

  /// `Update doctor image url`
  static Future<void> updateDoctorImageUrl(String url, {String uid}) async {
    final userId = uid ?? locator<DoctorProvider>().doctor.uid;

    log('Doctor id - $userId', name: 'FirebaseFirestore service image upload');

    if (userId == null) {
      // throw Exception('No user id found in UserProvider');
      Fluttertoast.showToast(msg: 'No userId found, please login again');
      return;
    }

    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore.collection('doctors').doc(userId).update({
      'imageUrl': url,
    });
  }

  /// `Get doctor data` Returns a map of user data
  static Future<Map<String, dynamic>> getDoctorInfo(String doctorId) async {
    if (doctorId == null) {
      // throw Exception('No user id found in UserProvider');
      Fluttertoast.showToast(msg: 'No doctorId found, please login again');
      return null;
    }

    // doctorId is present then get the information.
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final userDoc = await _firestore.collection('doctors').doc(doctorId).get();
    if (userDoc != null) {
      return userDoc.data();
    } else {
      Fluttertoast.showToast(msg: 'Internet may not be available');
      return null;
    }
  }

  static Future<List<DocumentSnapshot>> searchDoctors(String searchTerm) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query =
        _firestore.collection('doctors').orderBy('name').limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search doctors');
    return snapshots.docs;
  }

  static Future<List<DocumentSnapshot>> searchMoreDoctors(
      DocumentSnapshot lastDocumentSnapshot, String searchTerm) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('doctors')
        .orderBy('name')
        // .where('name', isGreaterThanOrEqualTo: searchTerm)
        .startAfterDocument(lastDocumentSnapshot)
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search more doctors');
    return snapshots.docs;
  }

  static Future<List<DocumentSnapshot>> searchDoctorsWithSpeciality(
      List<String> searchTerms) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('doctors')
        .where('specialities', arrayContainsAny: searchTerms)
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search doctors with speciality');
    return snapshots.docs;
  }

  static Future<List<DocumentSnapshot>> searchMoreDoctorsWithSpeciality(
      DocumentSnapshot lastDocumentSnapshot, List<String> searchTerms) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('doctors')
        .where('specialities', arrayContainsAny: searchTerms)
        .startAfterDocument(lastDocumentSnapshot)
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search more doctors with speciality');
    return snapshots.docs;
  }

  static Future<void> setDoctorPushToken(
      String doctorId, String pushToken) async {
    if (doctorId.isNotEmpty && pushToken.isNotEmpty) {
      log('Setting doctor push token', name: 'FS');
      final data = {
        'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
        'pushToken': pushToken,
        'platform': Platform.isAndroid ? 'android' : 'ios',
      };
      await FirebaseFirestore.instance
          .collection('doctors')
          .doc(doctorId)
          .collection('tokens')
          .doc(pushToken)
          .set(data);
    } else {
      Fluttertoast.showToast(msg: 'No id found, please login again');
      return;
    }
  }

  // *********************************************************************
  // `Hospitals functions`:
  // *********************************************************************

  /// Gets the list of hospitals without any search
  static Future<List<DocumentSnapshot>> getHospitals() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    // List<Map<String, dynamic>> hospital = [];
    // MOCK_HOSPITAL_DATA.forEach((element) {
    //   hospital.add(element);
    //   //print(result.);
    // });

    // hospital.forEach((element) {
    //   final DocumentReference _ref = _firestore.collection('hospitals').doc();
    //   _ref.set(element);
    // });

    final Query query =
        _firestore.collection('hospitals').orderBy('name').limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('Get hospitals ${snapshots.docs.length}', name: 'FS');
    return snapshots.docs;
  }

  /// Gets more hospitals without any search
  static Future<List<DocumentSnapshot>> getMoreHospitals(
      DocumentSnapshot lastDocument) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('hospitals')
        .startAfterDocument(lastDocument)
        .orderBy('name')
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('Get more hospitals ${snapshots.docs.length}', name: 'FS');
    return snapshots.docs;
  }

  static Future<List<DocumentSnapshot>> searchHospitals(
      String searchTerm) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('hospitals')
        .orderBy('name')
        // .where('name', isEqualTo: searchTerm)
        // .where('name', isGreaterThanOrEqualTo: searchTerm)
        // .where('name', isLessThanOrEqualTo: searchTerm)
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search hospitals');
    return snapshots.docs;
  }

  static Future<List<DocumentSnapshot>> searchMoreHospitals(
      DocumentSnapshot lastDocumentSnapshot, String searchTerm) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final Query query = _firestore
        .collection('hospitals')
        .orderBy('name')
        // .where('name', isGreaterThanOrEqualTo: searchTerm)
        .startAfterDocument(lastDocumentSnapshot)
        .limit(15);
    final QuerySnapshot snapshots = await query.get();
    log('${snapshots.docs.length}',
        name: 'FirebaseFirestore Service search more hospitals');
    return snapshots.docs;
  }

  // *********************************************************************
  // Payment Functions
  // *********************************************************************

  /// Creates a payment doc in the payments collection and returns a
  /// map with `ref` or `error` key.
  static Future<Map<String, dynamic>> createPaymentDoc(
      Map<String, dynamic> paymentData) async {
    if (paymentData.isNotEmpty) {
      log('Creating payment doc', name: 'FirebaseFirestore service');
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref = _firestore.collection('payments').doc();
      final result = await _ref.set(paymentData).then<bool>((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      if (result) {
        log('Sending the reference', name: 'FirebaseFirestore service');
        return {'ref': _ref};
      } else {
        log('Sending error', name: 'FirebaseFirestore service');
        return {'error': AppStrings.somethingWentWrong};
      }
    }
    Fluttertoast.showToast(msg: 'No data provided');
    return {'error': AppStrings.somethingWentWrong};
  }

  // *********************************************************************
  // Appointment Functions
  // *********************************************************************

  /// Creates an appointment doc in the appointments collection and returns a
  /// map with `ref` or `error` key.
  static Future<Map<String, dynamic>> createAppointmentDoc(
      Map<String, dynamic> appointmentDoc) async {
    if (appointmentDoc.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc();
      final result = await _ref.set(appointmentDoc).then<bool>((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      if (result) {
        return {'ref': _ref};
      } else {
        return {'error': AppStrings.somethingWentWrong};
      }
    }
    Fluttertoast.showToast(msg: 'No data provided');
    return {'error': AppStrings.somethingWentWrong};
  }

  /// Creates an appointment doc in the appointments collection
  ///
  /// `IMPT`:
  /// Must contain a field `uid` whose value will be used as the document Id
  /// for the firestore document.
  ///
  /// Returns a map with `ref` or `error` key.
  static Future<Map<String, dynamic>> createAppointmentDocWithId(
      Map<String, dynamic> appointmentDoc) async {
    if (appointmentDoc.isNotEmpty && appointmentDoc['uid'] != null) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc(appointmentDoc['uid']);
      final result = await _ref.set(appointmentDoc).then<bool>((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      if (result) {
        return {'ref': _ref};
      } else {
        return {'error': AppStrings.somethingWentWrong};
      }
    }
    Fluttertoast.showToast(msg: 'No data provided or the UID is not found');
    return {'error': AppStrings.somethingWentWrong};
  }

  /// Creates a call room with info to start a video or audio call
  static Future<Map<String, dynamic>> createCallRoom(
      Map<String, dynamic> callRoomDoc) async {
    if (callRoomDoc.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref = _firestore.collection('callRooms').doc();
      final result = await _ref.set(callRoomDoc).then<bool>((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      if (result) {
        return {'ref': _ref};
      } else {
        return {'error': AppStrings.somethingWentWrong};
      }
    }
    Fluttertoast.showToast(msg: 'No data provided');
    return {'error': AppStrings.somethingWentWrong};
  }

  /// Gets all the appointment for the user.
  static Future getAppointments(String uid) async {
    if (uid.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final Query query = _firestore
          .collection('appointments')
          // .where('doctorId', isEqualTo: uid);

          .where('userId', isEqualTo: uid);
      //.orderBy('createdAt', descending: true);
      // .limit(15);
      final QuerySnapshot snapshots = await query.get();
      log('Get Appointments - ${snapshots.docs.length}', name: 'FS');
      return snapshots.docs;
    } else {
      Fluttertoast.showToast(msg: 'No user id found. Please login again');
      return;
    }
  }

  /// Gets all the appointment for the doctor.
  static Future getDoctorAppointments(String doctorId) async {
    if (doctorId.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final Query query = _firestore
          .collection('appointments')
          .where('doctorId', isEqualTo: doctorId);
      // .limit(15);
      final QuerySnapshot snapshots = await query.get();
      log('Get Doctors Appointments - ${snapshots.docs.length}', name: 'FS');
      return snapshots.docs;
    } else {
      Fluttertoast.showToast(msg: 'No id found. Please login again');
      return;
    }
  }

//TODO CHAT
  /// Gets the appointment doc stream to listen for live updates.
  static Stream<DocumentSnapshot> getAppointmentDocStream(String documentId) {
    if (documentId.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc(documentId);
      return _ref.snapshots();
    } else {
      Fluttertoast.showToast(msg: 'No document found');
      return null;
    }
  }

  /// Updates appointment doc user status.
  static Future<void> updateAppointmentDocUserStatus(
      String documentId, bool isUserActive) async {
    if (documentId.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc(documentId);
      await _ref.update({'isUserActive': isUserActive});
    } else {
      Fluttertoast.showToast(msg: 'No document found');
      return;
    }
  }

  /// Updates appointment doc doctor status.
  static Future<void> updateAppointmentDocDoctorStatus(
      String documentId, bool isDoctorActive) async {
    if (documentId.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc(documentId);
      await _ref.update({'isDoctorActive': isDoctorActive});
    } else {
      Fluttertoast.showToast(msg: 'No document found');
      return;
    }
  }

  /// Updates appointment status from scheduled to others.
  static Future<bool> updateAppointmentStatus(
      String documentId, String updatedStatus) async {
    if (documentId.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref =
          _firestore.collection('appointments').doc(documentId);
      final result = await _ref.update({'status': updatedStatus}).then((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      return result;
    } else {
      Fluttertoast.showToast(msg: 'No document found');
      return null;
    }
  }

  // *********************************************************************
  // Prescriptions or medicine course functions
  // *********************************************************************

  /// Create a prescription document in the users' prescription subcollection
  static Future<bool> createPrescription(Map<String, dynamic> data) async {
    final String userId = data['userId'];
    final String doctorId = data['doctorId'];
    final String appointmentId = data['appointmentId'];

    if (userId.isNotEmpty && doctorId.isNotEmpty && appointmentId.isNotEmpty) {
      // Add a timstamp to the map
      data['timestamp'] = DateTime.now().millisecondsSinceEpoch.toString();

      // Write to firestore
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final DocumentReference _ref = _firestore
          .collection('users')
          .doc(userId)
          .collection('prescriptions')
          .doc();

      final bool result = await _ref.set(data).then((_) {
        Fluttertoast.showToast(msg: AppStrings.success);
        return true;
      }, onError: (e) {
        Fluttertoast.showToast(msg: 'Error $e');
        return false;
      });

      return result;
    } else {
      Fluttertoast.showToast(msg: 'No id found');
      return null;
    }
  }

  /// Get the prescription for a user.
  static Future<List<DocumentSnapshot>> getUserPrescriptions(String uid) async {
    if (uid.isNotEmpty) {
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final Query query = _firestore
          .collection('users')
          .doc(uid)
          .collection('prescriptions')
          .orderBy('timestamp', descending: true);
      // .limit(15);
      final QuerySnapshot snapshots = await query.get();
      log('Get Prescriptions - ${snapshots.docs.length}', name: 'FS');
      return snapshots.docs;
    } else {
      Fluttertoast.showToast(msg: 'No user id found. Please login again');
      return null;
    }
  }

  // *********************************************************************
  // Blogs functions
  // *********************************************************************

  /// Gets the blogs data
  static Future<List<DocumentSnapshot>> getBlogs() async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final Query query = firestore
        .collection('blogs')
        // .orderBy('timestamp', descending: true)
        .limit(15);

    final QuerySnapshot snapshot = await query.get();
    log('Get Blogs ${snapshot.docs.length}', name: 'FS');
    return snapshot.docs;
  }

  /// Gets more blogs data
  static Future<List<DocumentSnapshot>> getMoreBlogs(
      DocumentSnapshot lastDocument) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    final Query query = firestore
        .collection('blogs')
        .startAfterDocument(lastDocument)
        .orderBy('timestamp', descending: true)
        .limit(15);

    final QuerySnapshot snapshot = await query.get();
    log('Get More Blogs ${snapshot.docs.length}', name: 'FS');
    return snapshot.docs;
  }

  /// Gets the blogs data
  static Future<bool> saveBlog(Blog blog, String userId) async {
    if (userId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final DocumentReference _ref = firestore
          .collection('users')
          .doc(userId)
          .collection('savedBlogs')
          .doc(blog.uid);

      final result = await _ref.set(blog.toJson()).then((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      return result;
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Delete blogs data from a user saved blogs
  static Future<bool> deleteBlog(String blogId, String userId) async {
    if (userId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final DocumentReference _ref = firestore
          .collection('users')
          .doc(userId)
          .collection('savedBlogs')
          .doc(blogId);

      final result = await _ref.delete().then((_) {
        return true;
      }, onError: (e) {
        return false;
      });

      return result;
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Gets the users saved blogs data
  static Future<List<DocumentSnapshot>> getUsersSavedBlogs(
      String userId) async {
    if (userId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final Query query = firestore
          .collection('users')
          .doc(userId)
          .collection('savedBlogs')
          .orderBy('timestamp', descending: true)
          .limit(15);

      final QuerySnapshot snapshot = await query.get();
      log('Get Users Saved Blogs ${snapshot.docs.length}', name: 'FS');
      return snapshot.docs;
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Gets more users saved blogs data
  static Future<List<DocumentSnapshot>> getMoreUsersSavedBlogs(
      DocumentSnapshot lastDocument, String userId) async {
    if (userId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final Query query = firestore
          .collection('users')
          .doc(userId)
          .collection('savedBlogs')
          .startAfterDocument(lastDocument)
          .orderBy('timestamp', descending: true)
          .limit(15);

      final QuerySnapshot snapshot = await query.get();
      log('Get More Users Saved Blogs ${snapshot.docs.length}', name: 'FS');
      return snapshot.docs;
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  // *********************************************************************
  // Chat Messages functions
  // *********************************************************************

  /// Gets the list of messages in a chat
  static Future<List<DocumentSnapshot>> getChatMessages(
      String chatRoomId) async {
    if (chatRoomId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final Query query = firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .orderBy('timestamp', descending: true)
          .limit(200);

      final QuerySnapshot snapshot = await query.get();
      log('Chat Messages: Length ${snapshot.docs.length}', name: 'FS');
      return snapshot.docs.isNotEmpty ? snapshot.docs : [];
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Gets more chat messages
  static Future<List<DocumentSnapshot>> getMoreChatMessages(
      String chatRoomId, DocumentSnapshot lastDocument) async {
    if (chatRoomId.isNotEmpty && lastDocument.id != null) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      final Query query = firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .startAfterDocument(lastDocument)
          .orderBy('timestamp', descending: true)
          .limit(50);

      final QuerySnapshot snapshot = await query.get();
      log('More Chat Messages: Length ${snapshot.docs.length}', name: 'FS');
      return snapshot.docs.isNotEmpty ? snapshot.docs : [];
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Get chat room stream for real time updates
  static Stream<QuerySnapshot> getMessagesStream(String chatRoomId) {
    if (chatRoomId.isNotEmpty) {
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      return firestore
          .collection('messages')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .orderBy('timestamp', descending: true)
          .limit(1)
          .snapshots();
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return null;
    }
  }

  /// Send the message to the chat room.
  static Future<void> sendMessage(
      String chatRoomId, ChatMessage message) async {
    if (chatRoomId?.isNotEmpty ?? false) {
      log('Sending chat message...', name: 'FS');
      return await FirebaseFirestore.instance
          .collection('messages')
          .doc(chatRoomId)
          .collection(chatRoomId)
          .doc(DateTime.now().millisecondsSinceEpoch.toString())
          .set(message.toMap());
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return;
    }
  }

  // *********************************************************************
  // Illness related functions
  // *********************************************************************

  /// Gets the full list of illness from the server
  static Future<List<String>> getIllnessList() async {
    log('Fetching illness list...', name: 'FirebaseFirestore Service');
    final result = await FirebaseFirestore.instance
        .collection('admin')
        .doc('illnessList')
        .get();
    if (result.data() != null) {
      return result.data()['illnessList'].cast<String>();
    } else {
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
      return [];
    }
  }
}
