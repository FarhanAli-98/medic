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

import 'package:auto_route/auto_route_annotations.dart';
import 'package:doctor_consultation/controllers/appointmentSetupController.dart';
import 'package:doctor_consultation/controllers/communicationController.dart';
import 'package:doctor_consultation/screens/accountInfo/accountInfo.dart';
import 'package:doctor_consultation/screens/accountInfo/appointments/appointments.dart';
import 'package:doctor_consultation/screens/accountInfo/contactScreen.dart';
import 'package:doctor_consultation/screens/accountInfo/editProfileInfo.dart';
import 'package:doctor_consultation/screens/accountInfo/help/help.dart';
import 'package:doctor_consultation/screens/accountInfo/medicineCourse.dart';
import 'package:doctor_consultation/screens/accountInfo/savedBlogs.dart';
import 'package:doctor_consultation/screens/blogs/blogPost.dart';
import 'package:doctor_consultation/screens/blogs/blogScreen.dart';
import 'package:doctor_consultation/screens/call/call.dart';
import 'package:doctor_consultation/screens/chat/chat.dart';
import 'package:doctor_consultation/screens/doctorInfo/doctorInfo.dart';
import 'package:doctor_consultation/screens/doctorList/doctorList.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/appointments/appointmentsDoctor.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/editProfileDoctor/editProfileDoctor.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/editProfileDoctor/updateAddress.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/homeDoctor/homeDoctor.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/loginDoctor/loginDoctor.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/media/media.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/paymentDetails/paymentDetails.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/prescription/prescription.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/schedule/slots.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/signupDoctor/signupDoctor.dart';
import 'package:doctor_consultation/screens/home/home.dart';
import 'package:doctor_consultation/screens/hospitalInfo/hospitalInfo.dart';
import 'package:doctor_consultation/screens/hospitalList/hospitalList.dart';
import 'package:doctor_consultation/screens/login/login.dart';
import 'package:doctor_consultation/screens/onBoarding/onBoarding.dart';
import 'package:doctor_consultation/screens/review/review.dart';
import 'package:doctor_consultation/screens/search/searchScreen.dart';
import 'package:doctor_consultation/screens/signup/signup.dart';
import 'package:doctor_consultation/screens/splash/splash.dart';
import 'package:doctor_consultation/screens/support/support.dart';
import 'package:doctor_consultation/services/payment/SSLcommerzPayment.dart';
import 'package:doctor_consultation/services/payment/paymentWebview.dart';

@CupertinoAutoRouter(
  routes: [
    CupertinoRoute(page: SplashScreen, initial: true),

    CupertinoRoute(page: Login),
    CupertinoRoute(page: Signup),
    CupertinoRoute(page: Home),
    CupertinoRoute(page: OnBoarding),

    CupertinoRoute(page: Chat),
    CupertinoRoute(page: Call),

    // Payment
    CupertinoRoute(page: Review),
    CupertinoRoute(page: PaymentWebview),
    CupertinoRoute(page: SSLCommerzPayment),

    CupertinoRoute(page: CommunicationController),
    CupertinoRoute(page: AppointmentSetupController),

    CupertinoRoute(page: BlogsScreen),
    CupertinoRoute(page: Media),
    CupertinoRoute(page: DoctorInfo),
    CupertinoRoute(page: DoctorsList),
    CupertinoRoute(page: HospitalInfo),
    CupertinoRoute(page: HospitalList),

    CupertinoRoute(page: SearchScreen),

    CupertinoRoute(page: Support),
    CupertinoRoute(page: BlogPost),
    // CupertinoRoute(page: Calling),

    CupertinoRoute(page: AccountInfo),
    CupertinoRoute(page: SavedBlogs),
    CupertinoRoute(page: Appointments),
    CupertinoRoute(page: Help),
    CupertinoRoute(page: ContactScreen),
    CupertinoRoute(page: EditProfile),
    CupertinoRoute(page: MedicineCourse),

    // Doctors Screens
    CupertinoRoute(page: LoginDoctor),
    CupertinoRoute(page: SignupDoctor),
    CupertinoRoute(page: HomeDoctor),
    CupertinoRoute(page: EditProfileDoctor),
    CupertinoRoute(page: UpdateAddress),
    CupertinoRoute(page: PaymentDetails),
    CupertinoRoute(page: AppointmentsDoctor),
    CupertinoRoute(page: Prescription),
    CupertinoRoute(page: Slots),
  ],
)
class $Router {}
