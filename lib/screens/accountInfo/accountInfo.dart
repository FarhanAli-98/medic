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
import 'package:doctor_consultation/providers/userProvider.dart';
import 'package:doctor_consultation/routes/router.gr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';

///
/// ## `Description`
///
/// Screen to render Account info of the user.
/// Will work well when used with `username` or `id`
/// for the network request.
///
class AccountInfo extends StatelessWidget {
  const AccountInfo({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.accountInfo),
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Column(
                  children: <Widget>[
                    Selector<UserProvider, String>(
                      selector: (context, d) => d.user.imageUrl,
                      builder: (context, url, _) {
                        return Container(
                          padding: const EdgeInsets.all(10.0),
                          width: 250,
                          height: 250,
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
                    Selector<UserProvider, String>(
                      selector: (context, d) => d.user.email,
                      builder: (context, email, _) {
                        return Text(
                          email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                            color: Colors.black38,
                          ),
                        );
                      },
                    )
                  ],
                ),
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
              buildListTile(
                title: AppStrings.editProfile,
                onTap: () =>
                    NavigationController.navigator.push(Routes.editProfile),
              ),
              buildListTile(
                title: AppStrings.appointmentsTitle,
                onTap: () =>
                    NavigationController.navigator.push(Routes.appointments),
              ),
              buildListTile(
                title: AppStrings.medicineCourse,
                onTap: () =>
                    NavigationController.navigator.push(Routes.medicineCourse),
              ),
              buildListTile(
                title: AppStrings.savedBlogs,
                onTap: () =>
                    NavigationController.navigator.push(Routes.savedBlogs),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ///
  /// ## `Description`
  ///
  /// Function that returns the list tile for the various options
  /// provided to the user.
  ///
  ListTile buildListTile({@required String title, Function onTap}) {
    return ListTile(
      onTap: () => onTap(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.black,
      ),
      title: Text(
        title ?? '',
        style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      ),
    );
  }
}
