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

import 'package:doctor_consultation/controllers/mediaController.dart';
import 'package:doctor_consultation/controllers/notificationController.dart';
import 'package:doctor_consultation/providers/appointmentSetupProvider.dart';
import 'package:doctor_consultation/providers/appointmentsProvider.dart';
import 'package:doctor_consultation/providers/authProvider.dart';
import 'package:doctor_consultation/providers/blogsProvider.dart';
import 'package:doctor_consultation/providers/chatProvider.dart';
import 'package:doctor_consultation/providers/communicationProvider.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:doctor_consultation/providers/doctorProvider.dart';
import 'package:doctor_consultation/providers/doctorsDataProvider.dart';
import 'package:doctor_consultation/providers/hospitalDataProvider.dart';
import 'package:doctor_consultation/providers/illnessOptionsProvider.dart';
import 'package:doctor_consultation/providers/mediaProvider.dart';
import 'package:doctor_consultation/providers/medicineCourseProvider.dart';
import 'package:doctor_consultation/providers/savedBlogsProvider.dart';
import 'package:doctor_consultation/providers/searchProvider.dart';
import 'package:doctor_consultation/providers/userProvider.dart';
import 'package:doctor_consultation/services/api/algoliaApi.dart';
import 'package:doctor_consultation/services/authentication/authentication.dart';
import 'package:doctor_consultation/services/authentication/firebaseAuthService.dart';
import 'package:doctor_consultation/services/pushNotification/pushNotificationService.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';

import 'providers/paymentDetailsProvider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton<AuthService>(() => FirebaseAuthService());
  locator.registerLazySingleton<AppointmentsProvider>(
      () => AppointmentsProvider());
  locator.registerLazySingleton<UserProvider>(() => UserProvider());
    locator.registerLazySingleton<MediaProvider>(() => MediaProvider());

  locator.registerLazySingleton<SearchProvider>(() => SearchProvider());
  locator.registerLazySingleton<MedicineCourseProvider>(
      () => MedicineCourseProvider());
  locator.registerLazySingleton<SavedBlogsProvider>(() => SavedBlogsProvider());
  locator.registerLazySingleton<ConsultationProvider>(
      () => ConsultationProvider());
  locator.registerLazySingleton<DoctorProvider>(() => DoctorProvider());
  locator.registerLazySingleton<DoctorDataProvider>(() => DoctorDataProvider());
  locator.registerLazySingleton<PaymentDetailsProvider>(
      () => PaymentDetailsProvider());
  locator.registerLazySingleton<HospitalDataProvider>(
      () => HospitalDataProvider());
  locator.registerLazySingleton<BlogsProvider>(() => BlogsProvider());
  locator.registerLazySingleton<CommunicationProvider>(
      () => CommunicationProvider());
  locator.registerLazySingleton<AppointmentSetupProvider>(
      () => AppointmentSetupProvider());
  locator.registerLazySingleton<AlgoliaApi>(() => AlgoliaApi());
  locator.registerLazySingleton<PushNotificationService>(
      () => PushNotificationService());
  locator.registerLazySingleton<NotificationController>(
      () => NotificationController());
  locator.registerLazySingleton<ChatProvider>(() => ChatProvider());
  locator.registerLazySingleton<IllnessOptionsProvider>(
      () => IllnessOptionsProvider());
  locator.registerLazySingleton<UIAuthProvider>(() => UIAuthProvider());

}

abstract class LocatorService {
  static FirebaseAuthService authService() => locator<AuthService>();
  static SearchProvider searchProvider() => locator<SearchProvider>();
  static UserProvider userProvider() => locator<UserProvider>();
  static MediaProvider mediaProvider() => locator<MediaProvider>();
  static DoctorProvider doctorProvider() => locator<DoctorProvider>();
  static DoctorDataProvider doctorDataProvider() =>
      locator<DoctorDataProvider>();
  static HospitalDataProvider hospitalDataProvider() =>
      locator<HospitalDataProvider>();
  static BlogsProvider blogsProvider() => locator<BlogsProvider>();
  static AppointmentsProvider appointmentsProvider() =>
      locator<AppointmentsProvider>();
  static MedicineCourseProvider medicineCourseProvider() =>
      locator<MedicineCourseProvider>();
  static SavedBlogsProvider savedBlogsProvider() =>
      locator<SavedBlogsProvider>();
  static ConsultationProvider consultationProvider() =>
      locator<ConsultationProvider>();
  static CommunicationProvider communicationProvider() =>
      locator<CommunicationProvider>();
  static AppointmentSetupProvider appointmentSetupProvider() =>
      locator<AppointmentSetupProvider>();
  static AlgoliaApi algoliaApi() => locator<AlgoliaApi>();
  static PushNotificationService pushNotificationService() =>
      locator<PushNotificationService>();
  static NotificationController notificationController() =>
      locator<NotificationController>();
  static ChatProvider chatProvider() => locator<ChatProvider>();
  static IllnessOptionsProvider illnessOptionsProvider() =>
      locator<IllnessOptionsProvider>();
  static UIAuthProvider uiAuthProvider() => locator<UIAuthProvider>();

  /// Clears all the data from the registered providers
  static void reset() {
    locator.resetLazySingleton<AppointmentsProvider>();
    locator.resetLazySingleton<CommunicationProvider>();
    locator.resetLazySingleton<ConsultationProvider>();
    locator.resetLazySingleton<DoctorProvider>();
    locator.resetLazySingleton<PaymentDetailsProvider>();
    locator.resetLazySingleton<DoctorDataProvider>();
    locator.resetLazySingleton<MedicineCourseProvider>();
    locator.resetLazySingleton<SavedBlogsProvider>();
    locator.resetLazySingleton<SearchProvider>();
    locator.resetLazySingleton<UserProvider>();
    locator.resetLazySingleton<MediaProvider>();

  }
}
