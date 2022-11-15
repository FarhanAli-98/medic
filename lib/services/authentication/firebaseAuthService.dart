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

// ignore_for_file: unnecessary_brace_in_string_interps

import 'dart:async';
import 'dart:developer';

// import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:doctor_consultation/models/userModel.dart' as model;
import 'package:doctor_consultation/services/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthService implements AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  model.FAuthUser _userFromFirebase(User user) {
    if (user == null) {
      return null;
    }
    return model.FAuthUser(
      uid: user.uid,
      email: user.email,
    );
  }

  @override
  Stream<model.FAuthUser> get onAuthStateChanged {
    return _firebaseAuth.authStateChanges().map(_userFromFirebase);
  }

  @override
  Future<model.FAuthUser> signInAnonymously() async {
    final UserCredential authResult = await _firebaseAuth.signInAnonymously();
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<model.FAuthUser> signInWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult =
        await _firebaseAuth.signInWithCredential(EmailAuthProvider.credential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<model.FAuthUser> createUserWithEmailAndPassword(
      String email, String password) async {
    final UserCredential authResult = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    return _userFromFirebase(authResult.user);
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  @override
  Future<model.FAuthUser> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount googleUser =
          await googleSignIn.signIn().catchError((e) {
        print(e.toString());
      });

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;
        if (googleAuth.accessToken != null && googleAuth.idToken != null) {
          final UserCredential authResult = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));

          return _userFromFirebase(authResult.user);
        } else {
          return null;
          // throw PlatformException(
          //     code: 'ERROR_MISSING_GOOGLE_AUTH_TOKEN',
          //     message: 'Missing Google Auth Token');
        }
      } else {
        return null;
        // throw PlatformException(
        //     code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
      }
    } catch (e) {
      log(e.toString(), name: 'GSI: AuthService');
      return null;
    }
  }

  @override
  Future<model.FAuthUser> signInWithFacebook() async {
    // final fbLogin = FacebookLogin();

    // final FacebookLoginResult result = await fbLogin.logIn(['email']);
    // final String token = result.accessToken.token;
    // final response = await http.get(Uri.parse(
    //     'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}'));
    // final profile = jsonDecode(response.body);
    // print(profile);

    final FacebookLogin facebookLogin = FacebookLogin();
    // https://github.com/roughike/flutter_facebook_login/issues/210
    facebookLogin.loginBehavior = FacebookLoginBehavior.webOnly;
    final FacebookLoginResult result =
        await facebookLogin.logIn(<String>['public_profile']);
    if (result.accessToken != null) {
      final UserCredential authResult =
          await _firebaseAuth.signInWithCredential(
        FacebookAuthProvider.credential(result.accessToken.token),
      );

      return _userFromFirebase(authResult.user);
    } else {
      return null;
      // throw PlatformException(
      //     code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');
    }
  }

  // @override
  // Future<model.FAuthUser> signInWithApple({List<Scope> scopes = const []}) async {
  //   final AuthorizationResult result = await AppleSignIn.performRequests(
  //       [AppleIdRequest(requestedScopes: scopes)]);
  //   switch (result.status) {
  //     case AuthorizationStatus.authorized:
  //       final appleIdCredential = result.credential;
  //       final oAuthProvider = OAuthProvider(providerId: 'apple.com');
  //       final credential = oAuthProvider.credential(
  //         idToken: String.fromCharCodes(appleIdCredential.identityToken),
  //         accessToken:
  //             String.fromCharCodes(appleIdCredential.authorizationCode),
  //       );

  //       final authResult = await _firebaseAuth.signInWithCredential(credential);
  //       final firebaseUser = authResult.user;
  //       if (scopes.contains(Scope.fullName)) {
  //         final updateUser = UserUpdateInfo();
  //         updateUser.displayName =
  //             '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
  //         await firebaseUser.updateProfile(updateUser);
  //       }
  //       return _userFromFirebase(firebaseUser);
  //     case AuthorizationStatus.error:
  //       throw PlatformException(
  //         code: 'ERROR_AUTHORIZATION_DENIED',
  //         message: result.error.toString(),
  //       );
  //     case AuthorizationStatus.cancelled:
  //       throw PlatformException(
  //         code: 'ERROR_ABORTED_BY_USER',
  //         message: 'Sign in aborted by user',
  //       );
  //   }
  //   return null;
  // }

  @override
  Future<model.FAuthUser> currentUser() async {
    final User user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<String> currentUserId() async {
    final User user = _firebaseAuth.currentUser;
    return user.uid;
  }

  @override
  Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    final FacebookLogin facebookLogin = FacebookLogin();
    await facebookLogin.logOut();
    return _firebaseAuth.signOut();
  }

  @override
  void dispose() {}
}
