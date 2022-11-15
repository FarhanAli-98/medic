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
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/models/hospitalModel.dart';
import 'package:doctor_consultation/shared/infoSectionContainer.dart';
import 'package:doctor_consultation/shared/specialityContainer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// Returns the information about the hospital or clinic on the screen
/// Shows a loading indicator while the data is being loaded.
///
class HospitalInfo extends StatelessWidget {
  const HospitalInfo({Key key, this.hospital}) : super(key: key);

  final Hospital hospital;

  double get _borderRadius => 25;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Stack(
        children: <Widget>[
          Container(
            height: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider(
                    hospital.imageUrl ?? 'https://via.placeholder.com/100'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 330,
            child: Container(
              height: 150,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(_borderRadius),
                color: Colors.white,
              ),
            ),
          ),
          ScrollView(
            hospital: hospital,
          ),
          Container(
            margin: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            padding: const EdgeInsets.all(15),
            height: AppBar().preferredSize.height,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                NavigationController.navigator.pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: Theme.of(context).primaryColorDark,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}

///
/// ## `Description`
///
/// Helper widget for the main screen.
/// Returns the data in a widget which has the scrolling effect and contains other
/// widgets that are used to display on the screen.
/// Server as a parent widget for scrolling other child widgets which hold information.
///
class ScrollView extends StatelessWidget {
  const ScrollView({Key key, @required this.hospital}) : super(key: key);

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: <Widget>[
          const SizedBox(
            height: 300,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(35),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 1,
                  blurRadius: 20,
                  offset: Offset(0, -10),
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  hospital.name,
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                HospitalContactContainer(
                  hospital: hospital,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: SectionContainer(
                    title: AppStrings.specialitiesLable,
                    child: Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 8,
                      runSpacing: 8,
                      children: renderSpecialities(
                        hospital.specialities,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SectionContainer(
                    title: AppStrings.about,
                    text: hospital.bio,
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HospitalContactContainer extends StatelessWidget {
  const HospitalContactContainer({Key key, this.hospital}) : super(key: key);

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      padding: ThemeGuide.padding20,
      margin: const EdgeInsets.symmetric(vertical: 10),
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
              Flexible(
                child: Text(hospital.email ?? ' ',
                    style: _theme.textTheme.bodyText1),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              Text(
                '${AppStrings.phoneNumber}:  ',
                style:
                    _theme.textTheme.bodyText1.copyWith(color: Colors.black45),
              ),
              Text(hospital.phoneNumber ?? ' ',
                  style: _theme.textTheme.bodyText1),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${AppStrings.address}: ',
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
                      Text(hospital.address.street ?? ''),
                      Text(hospital.address.city ?? ''),
                      Text(hospital.address.state ?? ''),
                      Text(hospital.address.country ?? ''),
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
