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

import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/authController.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/providers/userProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

///
/// ## `Description`
///
/// Drawer widget that returns a drawer for the Home Scaffold.
///
class CustomDrawer extends StatelessWidget {
  ListTile listTile({String svgIconName, String title, Function onTap}) =>
      ListTile(
        leading: SvgPicture.asset(
          'lib/assets/svg/$svgIconName.svg',
          height: 35,
        ),
        title: Text(
          title ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
        onTap: onTap,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width - 100,
      padding: const EdgeInsets.fromLTRB(10, 50, 10, 10),
      color: Colors.white,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: <Widget>[
            Selector<UserProvider, String>(
              selector: (context, d) => d.user.imageUrl,
              builder: (context, url, _) {
                return Container(
                  padding: const EdgeInsets.all(10.0),
                  width: 150,
                  height: 150,
                  child: CircleAvatar(
                    backgroundColor: Colors.black12,
                    backgroundImage: CachedNetworkImageProvider(url),
                  ),
                );
              },
            ),
            Selector<UserProvider, String>(
              selector: (context, d) => d.user.name,
              builder: (context, name, _) {
                return Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                );
              },
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              child: Divider(
                color: Colors.black12,
                height: 2.0,
                thickness: 1.5,
                indent: 20,
                endIndent: 20,
              ),
            ),
            listTile(
              svgIconName: 'info_coloured',
              title: AppStrings.accountInfo,
              onTap: () {
                NavigationController.navigator.pop();
                Timer(
                  const Duration(milliseconds: 300),
                  () {
                    NavigationController.navigator.push(Routes.accountInfo);
                  },
                );
              },
            ),
            listTile(
              svgIconName: 'help_coloured',
              title: AppStrings.help,
              onTap: () {
                NavigationController.navigator.pop();
                Timer(
                  const Duration(milliseconds: 300),
                  () {
                    NavigationController.navigator.push(Routes.help);
                  },
                );
              },
            ),
            listTile(
              svgIconName: 'contact_us_coloured',
              title: AppStrings.contactUs,
              onTap: () {
                NavigationController.navigator.pop();
                Timer(
                  const Duration(milliseconds: 300),
                  () {
                    NavigationController.navigator.push(Routes.contactScreen);
                  },
                );
              },
            ),  
            listTile(
              svgIconName: 'logout_coloured',
              title: AppStrings.logout,
              onTap: () {
                AuthController.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
