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
// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:doctor_consultation/models/userModel.dart';

///
/// ## Description
///
/// This is a heavy duty authentication service base class
/// Use this class to serve your authentication purpose.
///
/// ## Work Flow:
///
/// For any type of `Authentication Service` the work flow will remain the same.
/// Follow these patters to work fluently.
///
/// 1. Authenticate the user using the `AuthService` class.
/// 2. On success, fetch the user's information from the backend in `UserProvider` asyncronously
///    and save it in the `User` class to update the listeners.
/// 3. Use that user info to populate the user data in the widgets.
/// 4. On `signout` update the main wrapper to show the login screen.
///
abstract class AuthService {
  Future<FAuthUser> currentUser();
  Future<FAuthUser> signInAnonymously();
  Future<FAuthUser> signInWithEmailAndPassword(String email, String password);
  Future<FAuthUser> createUserWithEmailAndPassword(
      String email, String password);
  Future<void> sendPasswordResetEmail(String email);
  Future<FAuthUser> signInWithGoogle();
  Future<FAuthUser> signInWithFacebook();
  // Future<FAuthUser> signInWithApple({List scopes});
  Future<void> signOut();
  Stream<FAuthUser> get onAuthStateChanged;
  void dispose();
}
