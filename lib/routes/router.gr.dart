// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:doctor_consultation/screens/call/VideoCall.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/media/images/add_image.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/media/media.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/schedule/schedule.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/paymentDetails/paymentDetails.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/schedule/slots.dart';
import 'package:doctor_consultation/services/payment/SSLcommerzPayment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../controllers/appointmentSetupController.dart';
import '../controllers/communicationController.dart';
import '../models/appointmentModel.dart';
import '../models/blogModel.dart';
import '../models/doctorModel.dart';
import '../models/hospitalModel.dart';
import '../screens/accountInfo/accountInfo.dart';
import '../screens/accountInfo/appointments/appointments.dart';
import '../screens/accountInfo/contactScreen.dart';
import '../screens/accountInfo/editProfileInfo.dart';
import '../screens/accountInfo/help/help.dart';
import '../screens/accountInfo/medicineCourse.dart';
import '../screens/accountInfo/savedBlogs.dart';
import '../screens/blogs/blogPost.dart';
import '../screens/blogs/blogScreen.dart';
import '../screens/call/call.dart';
import '../screens/chat/chat.dart';
import '../screens/doctorInfo/doctorInfo.dart';
import '../screens/doctorList/doctorList.dart';
import '../screens/doctorsAccountScreens/appointments/appointmentsDoctor.dart';
import '../screens/doctorsAccountScreens/editProfileDoctor/editProfileDoctor.dart';
import '../screens/doctorsAccountScreens/editProfileDoctor/updateAddress.dart';
import '../screens/doctorsAccountScreens/homeDoctor/homeDoctor.dart';
import '../screens/doctorsAccountScreens/loginDoctor/loginDoctor.dart';
import '../screens/doctorsAccountScreens/prescription/prescription.dart';
import '../screens/doctorsAccountScreens/signupDoctor/signupDoctor.dart';
import '../screens/home/home.dart';
import '../screens/hospitalInfo/hospitalInfo.dart';
import '../screens/hospitalList/hospitalList.dart';
import '../screens/login/login.dart';
import '../screens/onBoarding/onBoarding.dart';
import '../screens/review/review.dart';
import '../screens/search/searchScreen.dart';
import '../screens/signup/signup.dart';
import '../screens/splash/splash.dart';
import '../screens/support/support.dart';
import '../services/payment/paymentWebview.dart';

class Routes {
  static const String splashScreen = '/';
  static const String login = '/Login';
  static const String signup = '/Signup';
  static const String home = '/Home';
  static const String onBoarding = '/on-boarding';
  static const String chat = '/Chat';
  static const String call = '/Call';
  static const String review = '/Review';
  static const String paymentWebview = '/payment-webview';
  static const String sSLCommerzPayment = '/payment-SSLCommerz';
  static const String communicationController = '/communication-controller';
  static const String appointmentSetupController =
      '/appointment-setup-controller';
  static const String blogsScreen = '/blogs-screen';
  static const String doctorInfo = '/doctor-info';
  static const String doctorsList = '/doctors-list';
  static const String hospitalInfo = '/hospital-info';
  static const String hospitalList = '/hospital-list';
  static const String searchScreen = '/search-screen';
  static const String support = '/Support';
  static const String blogPost = '/blog-post';
  static const String accountInfo = '/account-info';
  static const String savedBlogs = '/saved-blogs';
  static const String appointments = '/Appointments';
  static const String help = '/Help';
  static const String contactScreen = '/contact-screen';
  static const String editProfile = '/edit-profile';
  static const String slots = '/slots';
  static const String medicineCourse = '/medicine-course';
  static const String loginDoctor = '/login-doctor';
  static const String signupDoctor = '/signup-doctor';
  static const String homeDoctor = '/home-doctor';
  static const String editProfileDoctor = '/edit-profile-doctor';
  static const String updateAddress = '/update-address';
  static const String paymentDetails = '/payment-details';
  static const String appointmentsDoctor = '/appointments-doctor';
  static const String prescription = '/Prescription';
  static const String media = '/media';
  static const String schedule = '/Schedule';
  static const String calling = '/calling';
  static const String imageUpload = '/image-upload';

  static const all = <String>{
    splashScreen,
    login,
    signup,
    home,
    onBoarding,
    chat,
    call,
    review,
    paymentWebview,
    sSLCommerzPayment,
    communicationController,
    appointmentSetupController,
    blogsScreen,
    doctorInfo,
    doctorsList,
    hospitalInfo,
    hospitalList,
    searchScreen,
    support,
    blogPost,
    accountInfo,
    savedBlogs,
    appointments,
    help,
    contactScreen,
    editProfile,
    medicineCourse,
    loginDoctor,
    signupDoctor,
    homeDoctor,
    editProfileDoctor,
    updateAddress,
    paymentDetails,
    appointmentsDoctor,
    prescription,
    media,
    schedule,
    calling,
    imageUpload,
    slots
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashScreen, page: SplashScreen),
    RouteDef(Routes.login, page: Login),
    RouteDef(Routes.signup, page: Signup),
    RouteDef(Routes.home, page: Home),
    RouteDef(Routes.onBoarding, page: OnBoarding),
    RouteDef(Routes.chat, page: Chat),
    RouteDef(Routes.call, page: Call),
    RouteDef(Routes.slots, page: Slots),
    RouteDef(Routes.imageUpload, page: UploadingImageToFirebaseStorage),
    RouteDef(Routes.review, page: Review),
    RouteDef(Routes.paymentWebview, page: PaymentWebview),
    RouteDef(Routes.sSLCommerzPayment, page: SSLCommerzPayment),
    RouteDef(Routes.paymentWebview, page: PaymentWebview),
    RouteDef(Routes.sSLCommerzPayment, page: SSLCommerzPayment),
    RouteDef(Routes.communicationController, page: CommunicationController),
    RouteDef(Routes.appointmentSetupController,
        page: AppointmentSetupController),
    RouteDef(Routes.blogsScreen, page: BlogsScreen),
    RouteDef(Routes.doctorInfo, page: DoctorInfo),
    RouteDef(Routes.doctorsList, page: DoctorsList),
    RouteDef(Routes.hospitalInfo, page: HospitalInfo),
    RouteDef(Routes.hospitalList, page: HospitalList),
    RouteDef(Routes.searchScreen, page: SearchScreen),
    RouteDef(Routes.support, page: Support),
    RouteDef(Routes.blogPost, page: BlogPost),
    RouteDef(Routes.accountInfo, page: AccountInfo),
    RouteDef(Routes.savedBlogs, page: SavedBlogs),
    RouteDef(Routes.appointments, page: Appointments),
    RouteDef(Routes.help, page: Help),
    RouteDef(Routes.contactScreen, page: ContactScreen),
    RouteDef(Routes.editProfile, page: EditProfile),
    RouteDef(Routes.medicineCourse, page: MedicineCourse),
    RouteDef(Routes.loginDoctor, page: LoginDoctor),
    RouteDef(Routes.signupDoctor, page: SignupDoctor),
    RouteDef(Routes.homeDoctor, page: HomeDoctor),
    RouteDef(Routes.editProfileDoctor, page: EditProfileDoctor),
    RouteDef(Routes.updateAddress, page: UpdateAddress),
    RouteDef(Routes.media, page: Media),
    RouteDef(Routes.schedule, page: Schedule),
    RouteDef(Routes.paymentDetails, page: PaymentDetails),
    RouteDef(Routes.appointmentsDoctor, page: AppointmentsDoctor),
    RouteDef(Routes.prescription, page: Prescription),
  ];

  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SplashScreen(),
        settings: data,
      );
    },
    Login: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Login(),
        settings: data,
      );
    },
    Signup: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Signup(),
        settings: data,
      );
    },
    Home: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Home(),
        settings: data,
      );
    },
    OnBoarding: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const OnBoarding(),
        settings: data,
      );
    },
    Chat: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Chat(),
        settings: data,
      );
    },
    Schedule: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Schedule(),
        settings: data,
      );
    },
    Call: (data) {
      final args = data.getArgs<CallArguments>(
        orElse: () => CallArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => Call(
          key: args.key,
          channelName: args.channelName,
          isAudio: args.isAudio,
        ),
        settings: data,
      );
    },
    // Calling: (data) {
    //   final args = data.getArgs<CallArguments>(
    //     orElse: () => CallArguments(),
    //   );
    //   return CupertinoPageRoute<dynamic>(
    //     builder: (context) => Calling(
    //       key: args.key,
    //       channelName: args.channelName,
    //       isAudio: args.isAudio,
    //     ),
    //     settings: data,
    //   );
    // },
        Slots: (data) {
      final args = data.getArgs<SlotsArguments>(
        orElse: () => SlotsArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => Slots(
          key: args.key,
          time:args.time,
        ),
        settings: data,
      );
    },
  
    Review: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Review(),
        settings: data,
      );
    },
    PaymentWebview: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const PaymentWebview(),
        settings: data,
      );
    },

    SSLCommerzPayment: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SSLCommerzPayment(),
        settings: data,
      );
    },
    CommunicationController: (data) {
      final args = data.getArgs<CommunicationControllerArguments>(
        orElse: () => CommunicationControllerArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => CommunicationController(
          key: args.key,
          appointment: args.appointment,
        ),
        settings: data,
      );
    },
    AppointmentSetupController: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => AppointmentSetupController(),
        settings: data,
      );
    },
    BlogsScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const BlogsScreen(),
        settings: data,
      );
    },
    DoctorInfo: (data) {
      final args = data.getArgs<DoctorInfoArguments>(
        orElse: () => DoctorInfoArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => DoctorInfo(
          key: args.key,
          doctor: args.doctor,
          isDoctor: args.isDoctor,
        ),
        settings: data,
      );
    },
    DoctorsList: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const DoctorsList(),
        settings: data,
      );
    },
    HospitalInfo: (data) {
      final args = data.getArgs<HospitalInfoArguments>(
        orElse: () => HospitalInfoArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => HospitalInfo(
          key: args.key,
          hospital: args.hospital,
        ),
        settings: data,
      );
    },
    HospitalList: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const HospitalList(),
        settings: data,
      );
    },
    SearchScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SearchScreen(),
        settings: data,
      );
    },
    Support: (data) {
      final args = data.getArgs<SupportArguments>(
        orElse: () => SupportArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => Support(
          category: args.category,
          assetUrl: args.assetUrl,
        ),
        settings: data,
      );
    },
    BlogPost: (data) {
      final args = data.getArgs<BlogPostArguments>(
        orElse: () => BlogPostArguments(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => BlogPost(
          key: args.key,
          blog: args.blog,
        ),
        settings: data,
      );
    },
    AccountInfo: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const AccountInfo(),
        settings: data,
      );
    },
    SavedBlogs: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SavedBlogs(),
        settings: data,
      );
    },
    Appointments: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Appointments(),
        settings: data,
      );
    },
    Help: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const Help(),
        settings: data,
      );
    },
    ContactScreen: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const ContactScreen(),
        settings: data,
      );
    },
    EditProfile: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const EditProfile(),
        settings: data,
      );
    },
    MedicineCourse: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const MedicineCourse(),
        settings: data,
      );
    },
    LoginDoctor: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const LoginDoctor(),
        settings: data,
      );
    },
    SignupDoctor: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const SignupDoctor(),
        settings: data,
      );
    },
    HomeDoctor: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const HomeDoctor(),
        settings: data,
      );
    },
    EditProfileDoctor: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const EditProfileDoctor(),
        settings: data,
      );
    },
    UpdateAddress: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const UpdateAddress(),
        settings: data,
      );
    },
    Media: (data) {
      final args = data.getArgs<MediaInfo>(
        orElse: () => MediaInfo(),
      );
      return CupertinoPageRoute<dynamic>(
        builder: (context) => Media(
          key: args.key,
          isDoctor: args.isDoctor,
        ),
        settings: data,
      );
    },

    PaymentDetails: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const PaymentDetails(),
        settings: data,
      );
    },
    AppointmentsDoctor: (data) {
      return CupertinoPageRoute<dynamic>(
        builder: (context) => const AppointmentsDoctor(),
        settings: data,
      );
    },
    Prescription: (data) {
      final args = data.getArgs<PrescriptionArguments>(nullOk: false);
      return CupertinoPageRoute<dynamic>(
        builder: (context) => Prescription(
          key: args.key,
          appointment: args.appointment,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// Call arguments holder class
class CallArguments {
  final Key key;
  final String channelName;
  final bool isAudio;

  CallArguments({this.key, this.channelName, this.isAudio});
}

/// CommunicationController arguments holder class
class CommunicationControllerArguments {
  final Key key;
  final Appointment appointment;

  CommunicationControllerArguments({this.key, this.appointment});
}

/// DoctorInfo arguments holder class
class DoctorInfoArguments {
  final Key key;
  final Doctor doctor;
  final bool isDoctor;

  DoctorInfoArguments({this.key, this.isDoctor, this.doctor});
}

//MediaInfo
class MediaInfo {
  final Key key;
  final bool isDoctor;

  MediaInfo({
    this.key,
    this.isDoctor,
  });
}

/// HospitalInfo arguments holder class
class HospitalInfoArguments {
  final Key key;
  final Hospital hospital;

  HospitalInfoArguments({this.key, this.hospital});
}
///Time Slots with arguments
class SlotsArguments {
  final Key key;
  final DateTime time;

  SlotsArguments({this.key, this.time});
}

/// Support arguments holder class
class SupportArguments {
  final String category;
  final String assetUrl;

  SupportArguments({this.category, this.assetUrl});
}

/// BlogPost arguments holder class
class BlogPostArguments {
  final Key key;
  final Blog blog;

  BlogPostArguments({this.key, this.blog});
}

/// Prescription arguments holder class
class PrescriptionArguments {
  final Key key;
  final Appointment appointment;

  PrescriptionArguments({this.key, @required this.appointment});
}
