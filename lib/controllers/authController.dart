import 'dart:developer';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/services/authentication/firebaseAuthService.dart';
import 'package:doctor_consultation/services/storage/localStorage.dart';
import 'package:doctor_consultation/services/storage/storageConstants.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthController {
// Validates the email
  static String validateEmail(String email) {
    return EmailValidator.validate(email)
        ? null
        : AppStrings.invalidEmailErrorText;
  }

  // Validates the password
  static String validatePassword(String password) {
    final int len = password.toString().length;
    if (len < 6) {
      return len == 0
          ? AppStrings.invalidPasswordEmpty
          : AppStrings.invalidPasswordTooShort;
    } else {
      return null;
    }
  }

  // Validates the confirm password field
  static String validateConfirmPassword(
      String confirmPassword, String password) {
    return password.toString() != confirmPassword.toString()
        ? AppStrings.invalidPasswordNoMatch
        : null;
  }

  static bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  // Save the credentials to local storage for later use upon startup
  static Future<void> saveCredentials(String userId, String email) async {
    await LocalStorage.setString(LocalStorageConstants.USER_ID, userId);
    await LocalStorage.setString(LocalStorageConstants.EMAIL, email);
    await LocalStorage.setString(
      LocalStorageConstants.ACCOUNT_TYPE,
      LocalStorageConstants.NORMAL_ACCOUNT_TYPE,
    );
    await LocalStorage.setString(LocalStorageConstants.INITIAL_INSTALL, 'done');
  }

  // Save the credentials to local storage for later use upon startup
  static Future<void> saveDoctorCredentials(
      String doctorId, String email) async {
    await LocalStorage.setString(LocalStorageConstants.DOCTOR_ID, doctorId);
    await LocalStorage.setString(LocalStorageConstants.EMAIL, email);
    await LocalStorage.setString(
      LocalStorageConstants.ACCOUNT_TYPE,
      LocalStorageConstants.DOCTOR_ACCOUNT_TYPE,
    );
    await LocalStorage.setString(LocalStorageConstants.INITIAL_INSTALL, 'done');
  }

  // Set the userId in the provider for future reference.
  static void setUserId(String userId) {
    LocatorService.userProvider().setUserId(userId);
  }

  // Set the doctorId in the provider for future reference.
  static void setDoctorId(String doctorId) {
    LocatorService.doctorProvider().setdoctorId(doctorId);
  }

  /// `Login Specific functions:`

  // Login to the app with email and password
  static Future<FAuthUser> login(String email, String password) async {
    final FAuthUser userInfo =
        await FirebaseAuthService().signInWithEmailAndPassword(
      email,
      password,
    );

    return userInfo;
  }

  // Logout function
  static Future<void> logout() async {
    // pop the navigator route.
    NavigationController.navigator.pop();
    NavigationController.navigator.replace(Routes.login);
    LocatorService.authService().signOut();
    LocatorService.reset();
  }

  /// `SignUp specific functions:`

  // Creates a new users for the app with email and password
  static Future<FAuthUser> signup(String email, String password) async {
    final FAuthUser userInfo = await FirebaseAuthService()
        .createUserWithEmailAndPassword(email, password);

    if (userInfo.uid.isNotEmpty) {
      /// [Important]
      /// Run this function every time to create a user document.
      await FirestoreService.createUser(userInfo.uid, userInfo.email);
    }

    return userInfo;
  }

  // Creates a new doctor for the app with email and password
  static Future<FAuthUser> signupDoctor(
      String email, String password, Map<String, dynamic> data) async {
    final FAuthUser userInfo = await FirebaseAuthService()
        .createUserWithEmailAndPassword(email, password);

    if (userInfo.uid.isNotEmpty) {
      /// [Important]
      /// Run this function every time to create a doctor document.
      await FirestoreService.createDoctor(userInfo.uid, userInfo.email, data);
    }

    return userInfo;
  }

  /// [Navigation handler]
  static void navigateToHome() {
    NavigationController.navigator.replace(Routes.home);
  }

  static void navigateToDoctorHome() {
    NavigationController.navigator.replace(Routes.homeDoctor);
  }

  /// [Auth Providers] to create users
  static Future<void> signInWithGoogle() async {
    try {
      final FAuthUser userInfo = await FirebaseAuthService().signInWithGoogle();
      if (userInfo == null) {
        log(
          'No userInfo found',
          name: 'Auth controller',
        );
        // log(e.code, name: 'Error code: Auth');
        Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
        return;
      }

      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(true);

      if (userInfo.uid.isNotEmpty) {
        final bool isDataAvailable =
            await LocatorService.userProvider().fetchUserData(userInfo.uid);

        if (isDataAvailable) {
          setUserId(userInfo.uid);
          LocatorService.pushNotificationService()
              .manageNotificationsAtAuth(userId: userInfo.uid);

          await saveCredentials(userInfo.uid, userInfo.email);
          // Change the loading status of the overlay.
          LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
          navigateToHome();
        } else {
          /// [Important]
          /// Run this function every time to create a user document.
          await FirestoreService.createUser(userInfo.uid, userInfo.email);

          final bool isDataAvailable =
              await LocatorService.userProvider().fetchUserData(userInfo.uid);

          if (isDataAvailable) {
            setUserId(userInfo.uid);
            LocatorService.pushNotificationService()
                .manageNotificationsAtAuth(userId: userInfo.uid);

            await saveCredentials(userInfo.uid, userInfo.email);
            // Change the loading status of the overlay.
            LocatorService.uiAuthProvider()
                .changeSocialLoginLoadingStatus(false);
            navigateToHome();
          }
        }
      }
    } on PlatformException catch (e) {
      log(e.message, name: 'Error message: Login page');
      // log(e.code, name: 'Error code: Login page');
      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    } catch (e) {
      // log(e, name: 'Error: Login Page');
      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    }
  }

  static Future<void> signInWithFacebook() async {
    try {
      final FAuthUser userInfo =
          await FirebaseAuthService().signInWithFacebook();

      log('$userInfo', name: 'Auth Facebook');

      if (userInfo == null) {
        log(
          'No userInfo found',
          name: 'Error message: Auth platform exception',
        );
        // log(e.code, name: 'Error code: Auth');
        Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
        return;
      }

      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(true);

      if (userInfo.uid.isNotEmpty) {
        final bool isDataAvailable =
            await LocatorService.userProvider().fetchUserData(userInfo.uid);

        if (isDataAvailable) {
          setUserId(userInfo.uid);
          LocatorService.pushNotificationService()
              .manageNotificationsAtAuth(userId: userInfo.uid);

          await saveCredentials(userInfo.uid, userInfo.email);
          // Change the loading status of the overlay.
          LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
          navigateToHome();
        } else {
          /// [Important]
          /// Run this function every time to create a user document.
          await FirestoreService.createUser(userInfo.uid, userInfo.email);

          final bool isDataAvailable =
              await LocatorService.userProvider().fetchUserData(userInfo.uid);

          if (isDataAvailable) {
            setUserId(userInfo.uid);
            LocatorService.pushNotificationService()
                .manageNotificationsAtAuth(userId: userInfo.uid);

            await saveCredentials(userInfo.uid, userInfo.email);
            // Change the loading status of the overlay.
            LocatorService.uiAuthProvider()
                .changeSocialLoginLoadingStatus(false);
            navigateToHome();
          }
        }
      }
    } on PlatformException catch (e) {
      log(e.message, name: 'Error message: Auth platform exception');
      // log(e.code, name: 'Error code: Auth');
      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    } catch (e) {
      log(e.toString(), name: 'Error: Auth');
      // Change the loading status of the overlay.
      LocatorService.uiAuthProvider().changeSocialLoginLoadingStatus(false);
      Fluttertoast.showToast(msg: AppStrings.somethingWentWrong);
    }
  }
}
