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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doctor_consultation/controllers/controller.dart';
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/screens/chat/chat.dart';
import 'package:doctor_consultation/services/pushNotification/pushNotificationService.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/shared/infoSectionContainer.dart';
import 'package:doctor_consultation/shared/widgets/categoryOptionsModal.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:doctor_consultation/utils/validators.dart';
import '../../constants/responsive.dart';
import '../../shared/CustomContainer.dart';
import 'package:cloud_functions/cloud_functions.dart';

class DoctorInfo extends StatefulWidget {
  const DoctorInfo({Key key, this.doctor, @required this.isDoctor})
      : super(key: key);
  final Doctor doctor;
  final bool isDoctor;

  @override
  State<DoctorInfo> createState() => _DoctorInfoState();
}

class _DoctorInfoState extends State<DoctorInfo> {
  bool isCheck = false;
//TODO remove this after PMI
  @override
  void initState() {
    super.initState();
    LocatorService.consultationProvider().testSetDoctor(widget.doctor);
    LocatorService.mediaProvider().mediaImages(widget.doctor.uid);
  }

  // get() {
  //   setState(() {
  //     isCheck = true;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${AppStrings.dr} ${widget.doctor.name}'),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: isCheck
              //TODO remove this lines of code
              ? StreamBuilder(
                  stream: LocatorService.communicationProvider()
                      .getAppointmentDocStream(widget.doctor.uid),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (snapshot.hasData) {
                      final data = snapshot.data.data();
                      final isDoctorActive = data['isDoctorActive'];
                      final isUserActive = data['isUserActive'];

                      if (isUserActive && isDoctorActive) {
                        NavigationController.navigator.push(
                          Routes.communicationController,
                          arguments: CommunicationControllerArguments(
                            appointment: Appointment.fromJSON(data),
                          ),
                        );
                      }

                      return Container();
                    } else {
                      return Container(
                        child: const Center(
                          child: CustomLoader(),
                        ),
                      );
                    }
                  },
                )
              : Column(
                  children: <Widget>[
                    DoctorProfile(doctor: widget.doctor),
                    _buildItem(
                      context: context,
                      onPress: () => NavigationController.navigator.push(
                        Routes.media,
                        arguments: MediaInfo(
                          isDoctor: widget.isDoctor,
                        ),
                      ),
                      lable: AppStrings.gellery,
                    ),
                    // Container(
                    //   margin: const EdgeInsets.symmetric(
                    //     horizontal: 30,
                    //     vertical: 20,
                    //   ),
                    //   height: 200,
                    //   width: 200,
                    //   decoration: BoxDecoration(
                    //     boxShadow: const [
                    //       BoxShadow(
                    //         color: Colors.black12,
                    //         spreadRadius: 3,
                    //         blurRadius: 10,
                    //       )
                    //     ],
                    //     borderRadius: ThemeGuide.borderRadius20,
                    //     image: DecorationImage(
                    //       fit: BoxFit.cover,
                    //       image: CachedNetworkImageProvider(doctor.imageUrl),
                    //     ),
                    //   ),
                    // ),

                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //     vertical: 5,
                    //     horizontal: 10,
                    //   ),
                    //   child: Wrap(
                    //     alignment: WrapAlignment.center,
                    //     spacing: 8,
                    //     runSpacing: 8,
                    //     children: renderSpecialities(
                    //       doctor.specialities,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: SectionContainer(
                        title: AppStrings.fee,
                        text:
                            '${Config.CURRENCY_SYMBOL.isNotEmpty ? Config.CURRENCY_SYMBOL : Config.CURRENCY} ${widget.doctor.fee}',
                      ),
                    ),
                    // Padding(
                    //   padding:
                    //       const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    //   child: SectionContainer(
                    //     title: AppStrings.experience,
                    //     text: doctor.experience + ' ' + AppStrings.years,
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16),
                      child: ContactContainer(doctor: widget.doctor),
                    ),
                    Container(
                      width: double.infinity,
                      padding: ThemeGuide.padding16,
                      child: CupertinoButton.filled(
                        padding: ThemeGuide.padding16,
                        child: Text(
                          AppStrings.connectNow,
                          style: Theme.of(context)
                              .textTheme
                              .button
                              .copyWith(color: Colors.white),
                        ),
                        //TODO change this navigation
                        onPressed: () => //get()
                            //sendNotificationToSpacificUser(),
                            handleConnect(context, widget.doctor),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildItem({BuildContext context, Function onPress, String lable}) {
    return GestureDetector(
      onTap: () => onPress(),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: const BoxDecoration(
          borderRadius: ThemeGuide.borderRadius,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(230, 230, 230, 1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 3.0),
            ),
          ],
        ),
        child: ListTile(
          title: Text(
            lable,
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(fontWeight: FontWeight.w600),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 16,
          ),
        ),
      ),
    );
  }

  Future<void> handleConnect(BuildContext context, Doctor doctor) async {
    LocatorService.appointmentSetupProvider().initiateCallRoom();
    // NavigationController.navigator.push(
    //   Routes.call,
    //   arguments: CallArguments(
    //     channelName: 'test',
    //     isAudio: false,
    //   ),
    // );

    // Appointment appointment;

    // LocatorService.appointmentsProvider().appointmentList.forEach((element) {
    //   // print(LocatorService.authService().currentUserId());
    //   print(element.userId);
    //   if (element.uid == '112106211517021nhok6Ttn7P1RNh') {
    //     print('object');
    //     appointment = element;
    //   }
    // });
    // NavigationController.navigator.push(
    //   Routes.communicationController,
    //   arguments: CommunicationControllerArguments(
    //     appointment: appointment,
    //   ),
    // );

    // if (Validator.isAmountValid(doctor.fee)) {
    //   // Set the doc id and amount to provider
    //   LocatorService.consultationProvider().setDoctor = doctor;
    //   LocatorService.consultationProvider().setAmount = doctor.fee;
    //   print(LocatorService.consultationProvider().title);
    //   if (LocatorService.consultationProvider().title != null) {
    //     NavigationController.navigator.push(Routes.review);
    //   } else {
    //     UiController.showModal(context, CategoryOptionsModal());
    //   }
    // } else {
    //   Fluttertoast.showToast(msg: AppStrings.invalidAmount);
    // }
  }
}

// //sendNotificationToSpacificUser()
// Future<void> sendNotificationToSpacificUser() async {
//   NavigationController.navigator.push(
//     Routes.call,
//     arguments: CallArguments(
//       channelName: 'test',
//       isAudio: false,
//     ),
//   );

// final u = Uri.parse(url).queryParameters['data'];
//     final result = jsonDecode(u);
//     print('$result');
//     dispose();
// //TODO
// Setup appointmentUID to create an appointment document with that ID
//     LocatorService.appointmentSetupProvider().setAppoinetmentUID =
//         // ignore: prefer_single_quotes
//         doctor.uid;
//     // result['appointmentId'];
//     LocatorService.appointmentSetupProvider().setPaymentDocUID = doctor.uid;
//     LocatorService.appointmentSetupProvider().initiateAppointmentWithId();
// // Setup paymentDocUID to have reference for payment document with appointment
// // document
// LocatorService.appointmentSetupProvider().setPaymentDocUID
// result['paymentDocId'];

// NavigationController.navigator
//     .popAndPush(Routes.appointmentSetupController);
// return;
// NavigationController.navigator.push(
//   Routes.calling,
//   arguments: CallArguments(
//     channelName: 'test',
//     isAudio: false,
//   ),
// );

// final func = FirebaseFunctions.instance.httpsCallable('notifySubscribers');
// final res = await func.call(<String, dynamic>{
//   'targetDevices':
//       'fSGdxdEvTE2150U8gJeMIu:APA91bHdfCDDr6wVvu14lm-5hIJsu6TM0L9SQoD0llBhRkPVGQLszvHzobsLy3Qnscn37-XGDu7OHi9KJIwtjrt17REpQrH4PFG-FwA3ZxWQLL5KlMXFEga8Em3kvqYlXkNCDFbRrYpE',
//   'messageTitle': 'Appointments from user side',
//   'messageBody':
//       'this one is test body for send notification on another device. Testing from internal app side',
// });
// print("message was ${res.data as bool ? "sent!" : "not sent!"}");
// }

class DoctorProfile extends StatelessWidget {
  final Doctor doctor;
  const DoctorProfile({
    Key key,
    this.doctor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    '${AppStrings.dr} ' + doctor.name ?? '',
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // const SizedBox(height: 10),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: renderSpecialities(doctor.specialities ?? ''),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'About',
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.lato(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                        color: Colors.black),
                  ),
                  Container(
                    height: 100,
                    width: 150,
                    child: Center(
                        child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          // padding: const EdgeInsets.all(8.0),
                          child: Text(
                            doctor.about ?? '',
                            textAlign: TextAlign.justify,
                            overflow: TextOverflow.fade,
                            style: GoogleFonts.lato(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: 15.0,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    )),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          'Currency: '
                          '${Config.CURRENCY_SYMBOL.isNotEmpty ? Config.CURRENCY_SYMBOL : Config.CURRENCY} ',
                          style: _theme.textTheme.subtitle1.copyWith(
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          doctor.fee ?? AppStrings.notProvided,
                          style: _theme.textTheme.subtitle1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (doctor.address.street != '' ||
                      doctor.address.street != null)
                    Row(
                      children: [
                        const Center(
                          child: Icon(Icons.location_on),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Address',
                              textAlign: TextAlign.justify,
                              overflow: TextOverflow.fade,
                              style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                            _addressbuild(doctor.address.street ?? '', context),
                            _addressbuild(doctor.address.city ?? '', context),
                            _addressbuild(doctor.address.state ?? '', context),
                            _addressbuild(
                                doctor.address.country ?? '', context),
                          ],
                        ),
                      ],
                    ),
                  if (doctor.address.street != '' ||
                      doctor.address.street != null)
                    const SizedBox(height: 10),
                  Container(
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          AppStrings.exp + ' ',
                          style: _theme.textTheme.subtitle1.copyWith(
                            color: Colors.black38,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          doctor.experience ?? '' + ' ' + AppStrings.yr,
                          style: _theme.textTheme.subtitle1.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Expanded(
                child: Container(
                  height: Responsive.height(30, context),
                  width: Responsive.width(35, context),
                  decoration: BoxDecoration(
                    borderRadius: ThemeGuide.borderRadius16,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: CachedNetworkImageProvider(
                          doctor.imageUrl ?? Config.placeholedImageUrl),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Text _addressbuild(String d, BuildContext context) {
    return Text(
      stringExtension(d),
      overflow: TextOverflow.ellipsis,
      style: GoogleFonts.lato(
          textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 15.0,
          fontWeight: FontWeight.w400,
          color: Colors.grey),
    );
  }

  List<Widget> renderSpecialities(List<String> specialities) {
    final ar = specialities ?? [];
    if (ar.isEmpty) {
      return [
        const CustomeContainer.small(speciality: AppStrings.notProvided),
      ];
    }
    return ar.map((speciality) {
      return CustomeContainer.small(speciality: speciality);
    }).toList();
  }

//TODO
  String stringExtension(String text) {
    try {
      if (text.isEmpty || text == null || text == '') {
        return '';
      }
      // return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}' ?? '';
      return '${text.toUpperCase()}${text.substring(1).toLowerCase()}' ?? '';
    } catch (e) {
      return 'Not found';
    }
  }
}

class ContactContainer extends StatelessWidget {
  const ContactContainer({Key key, this.doctor}) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: ThemeGuide.padding20,
      decoration: const BoxDecoration(
        color: ThemeGuide.darkGrey,
        borderRadius: ThemeGuide.borderRadius10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppStrings.contact,
            style: _theme.textTheme.headline6,
          ),
          const SizedBox(height: 20),
          Row(
            children: <Widget>[
              Text(
                '${AppStrings.email}:  ',
                style:
                    _theme.textTheme.bodyText1.copyWith(color: Colors.black45),
              ),
              Text(doctor.email ?? '', style: _theme.textTheme.bodyText1),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${AppStrings.address}:  ',
                style:
                    _theme.textTheme.bodyText1.copyWith(color: Colors.black45),
              ),
              Flexible(
                child: DefaultTextStyle(
                  style: _theme.textTheme.bodyText1,
                  child: Wrap(
                    runSpacing: 4,
                    spacing: 4,
                    children: <Widget>[
                      Text(doctor.address.street ?? ''),
                      Text(doctor.address.city ?? ''),
                      Text(doctor.address.state ?? ''),
                      Text(doctor.address.country ?? ''),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
