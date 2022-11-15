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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/hospitalModel.dart';
import 'package:doctor_consultation/providers/hospitalDataProvider.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//
/// ## `Description`
///
/// This widget provides 3-4 hospitals info in list and is
/// intended to work as the small link to move to
/// the all hospitals screen.
///
class SmallHospitalList extends StatelessWidget {
  const SmallHospitalList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return ChangeNotifierProvider.value(
      value: LocatorService.hospitalDataProvider(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      AppStrings.hospitalsAndClinics,
                      style: _theme.textTheme.subtitle2.copyWith(fontSize: 16),
                    ),
                  ),
                ),
                FlatButton(
                  child: Text(
                    AppStrings.seeAll,
                    style: _theme.textTheme.bodyText1,
                  ),
                  onPressed: () =>
                      NavigationController.navigator.push(Routes.hospitalList),
                ),
              ],
            ),
            SizedBox(
              height: 400,
              child: Selector<HospitalDataProvider, List<Hospital>>(
                selector: (context, d) => d.hospitalSmallList,
                shouldRebuild: (a, b) => true,
                builder: (context, list, _) {
                  if (list.isEmpty) {
                    LocatorService.hospitalDataProvider()
                        .getHospitalsSmallList();
                    return const Center(
                      child: CustomLoader(),
                    );
                  } else {
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: list.length,
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () => NavigationController.navigator.push(
                            Routes.hospitalInfo,
                            arguments: HospitalInfoArguments(
                              hospital: list[i],
                            ),
                          ),
                          child: HospitalSmallListItem(
                            hospital: list[i],
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///
/// ## `Description`
///
/// Hospital List Item takes in a Map{} of hospital data.
/// Displays each Map as a card with specified length
/// and width.
/// Best to use as an item of a list
///
class HospitalSmallListItem extends StatelessWidget {
  const HospitalSmallListItem({Key key, @required this.hospital})
      : super(key: key);

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: ThemeGuide.boxShadowBlack,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      hospital.imageUrl ?? 'https://via.placeholder.com/100'),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  hospital.name ?? ' ',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.location_on,
                      color: Colors.red[400],
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
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
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.call,
                      color: Colors.green[400],
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        hospital.phoneNumber ?? ' ',
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.email,
                      color: Colors.blue[400],
                      size: 15,
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        hospital.email ?? ' ',
                      ),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
