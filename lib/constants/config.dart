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

abstract class Config {
  static const String ANDROID_PACKCAGE_NAME =
      'com.orderpin.doctor_consultation';
  static const String IOS_PACKCAGE_NAME = 'com.orderpin.doctor_consultation';

  // TODO(AniketMalik): Add this step to setup and installation guide
  static const String FIREBASE_APP_NAME = 'doctor-consultation';

  // Agora AppId --> Do not leave this empty or your video call will not work.
  //static const AGORA_APP_ID = 'b6342b4edeb94e18ae31440aa0f9a620';
    static const AGORA_APP_ID = '04e286223d9744d7973cedef9d6a9f18';


  // Algolia App Id --> Used to power text based search
  static const String ALGOLIA_APP_ID = '7G7HHDM85G';
  static const String ALGOLIA_SEARCH_API_KEY =
      'a88e8465f060e567ff0a2bf265e09d2f';

  static const String ALGOLIA_DOCTORS_INDEX = 'DC_doctors';
  static const String ALGOLIA_HOSPITALS_INDEX = 'DC_hospitals';

  // Signup User placeholder image - Change this image during production for your own
  // firebase project.
  static const String placeholedImageUrl =
      'https://thumbs.dreamstime.com/b/doctor-icon-add-sign-new-plus-positive-symbol-vector-illustration-116307542.jpg';

  // Payment related API and Url strings to use for network request.
  // Payment related API and Url strings to use for network request.
  static const PAYMENT_API =
      'https://FUNCTION-LOCATION-YOUR-FIREBASE-PROJECT.cloudfunctions.net/paymentApi';
  static const INITIATE_PAYMENT_URL = PAYMENT_API + '/initiate_payment';

  static const CURRENCY = 'BDT';
  static const CURRENCY_SYMBOL = '৳';

  // Notification topics which will be subscribed by all app users
  static const String NOTIFICATION_SUBSCRIPTION_TOPIC = 'TO_ALL_USERS';
  static const String NOTIFICATION_SUBSCRIPTION_TOPIC_DOCTORS =
      'TO_ALL_DOCTORS';

  static const String TERMS_OF_SERVICE_URL = ' https://medicbangladesh.com/terms-conditions/';
  static const String PRIVACY_POLICY_URL = 'https://medicbangladesh.com/privacy-policy/';

  static const String SPLASH_SCREEN_HEADING = 'Doc Consult';

  // There must not by any space in front or back of the following constants
  static const String HELP_TELEPHONE_NUMBER = '+000000000000';
  static const String CONTACT_EMAIL_ADDRESS = 'mail@email.com';
  static const String CONTACT_US =
      'https://medicbangladesh.com/contact/';
}
