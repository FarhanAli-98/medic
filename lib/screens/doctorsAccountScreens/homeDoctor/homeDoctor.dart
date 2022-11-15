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

// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/constants/responsive.dart';
import 'package:doctor_consultation/controllers/mediaController.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/providers/doctorProvider.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/doctorsShared/doctorCustomDrawer.dart';
import 'package:doctor_consultation/shared/CustomContainer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeDoctor extends StatefulWidget {
  const HomeDoctor({Key key}) : super(key: key);

  @override
  State<HomeDoctor> createState() => _HomeDoctorState();
}

class _HomeDoctorState extends State<HomeDoctor> {
  //
  @override
  void initState() {
    super.initState();

    LocatorService.mediaProvider().mediaImages('');
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.white,
              title: const Text(
                'Are you sure you want to exit?',
                textAlign: TextAlign.center,
              ),
              titleTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              actions: <Widget>[
                // ignore: deprecated_member_use
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: Colors.red,
                  child: const Text(
                    AppStrings.yesUpperCase,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                // ignore: deprecated_member_use
                FlatButton(
                  shape: const RoundedRectangleBorder(
                    borderRadius: ThemeGuide.borderRadius10,
                  ),
                  color: Colors.blue,
                  child: const Text(
                    AppStrings.noUpperCase,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                )
              ],
            );
          },
        );
      },
      child: Material(
        child: Scaffold(
          key: GlobalKey<ScaffoldState>(),
          appBar: AppBar(),
          drawer: DoctorCustomDrawer(),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const HomeDoctorHeader(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
                  child: Text(
                    AppStrings.activity,
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                _buildItem(
                  context: context,
                  onPress: () =>
                      NavigationController.navigator.push(Routes.appointments),
                  lable: AppStrings.appointmentsTitle,
                ),
                // // _buildItem(
                // //   context: context,
                // //   onPress: () {},
                // //   lable: AppStrings.payment,
                // // ),
                _buildItem(
                  context: context,
                  onPress: () => NavigationController.navigator.push(
                    Routes.media,
                    arguments: MediaInfo(
                      isDoctor: true,
                    ),
                  ),
                  lable: AppStrings.gellery,
                ),
                _buildItem(
                  context: context,
                  onPress: () => NavigationController.navigator.push(
                    Routes.schedule,
                  ),
                  lable: AppStrings.schedule,
                ),

                _buildItem(
                  context: context,
                  onPress: () =>
                      NavigationController.navigator.push(Routes.updateAddress),
                  lable: AppStrings.updateAddress,
                ),
                const SizedBox(height: 50),
              ],
            ),
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
}

class HomeDoctorHeader extends StatelessWidget {
  const HomeDoctorHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(10),
      child: Consumer<DoctorProvider>(
        builder: (context, data, _) {
          final d = data.doctor;
          return Column(
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
                        '${AppStrings.dr} ' + d.name,
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
                        children: renderSpecialities(d.specialities),
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
                                d.about,
                                textAlign: TextAlign.justify,
                                overflow: TextOverflow.fade,
                                style: GoogleFonts.lato(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
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
                              d.fee ?? AppStrings.notProvided,
                              style: _theme.textTheme.subtitle1.copyWith(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),

                      if (d.address.street != '' || d.address.street != null)
                        Row(
                          children: [
                            Center(
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
                                _addressbuild(d.address.street, context),
                                _addressbuild(d.address.city, context),
                                _addressbuild(d.address.state, context),
                                _addressbuild(d.address.country, context),
                              ],
                            ),
                          ],
                        ),
                      if (d.address.street != '' || d.address.street != null)
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
                              d.experience + ' ' + AppStrings.yr,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () => NavigationController.navigator
                            .push(Routes.editProfileDoctor),
                        icon: Icon(Icons.edit),
                      ),
                      GestureDetector(
                        onTap: () => NavigationController.navigator
                            .push(Routes.editProfileDoctor),
                        child: Container(
                          // padding: const EdgeInsets.all(10.0),
                          height: Responsive.height(30, context),
                          width: Responsive.width(35, context),
                          decoration: BoxDecoration(
                            borderRadius: ThemeGuide.borderRadius16,
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: CachedNetworkImageProvider(
                                  d.imageUrl ?? Config.placeholedImageUrl),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Text _addressbuild(String d, BuildContext context) {
    return Text(
      stringExtension(d),
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

  String stringExtension(String text) {
    try {
      return '${text[0].toUpperCase()}${text.substring(1).toLowerCase()}';
    } catch (e) {
      return 'Not found';
    }
  }
}
