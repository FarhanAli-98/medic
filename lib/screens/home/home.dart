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

// ignore_for_file: deprecated_member_use, unnecessary_import

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/screens/blogs/blogSmallList.dart';
import 'package:doctor_consultation/screens/home/categoryOptions.dart';
import 'package:doctor_consultation/screens/home/healthConcernList.dart';
import 'package:doctor_consultation/screens/hospitalList/hospitalSmallList.dart';
import 'package:doctor_consultation/shared/customDrawer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// Home widget which is the main widget.
/// Returns the main interactive elements of the app at one place.
/// The app will ask for a surety check before exiting the application
/// which is handled by `WillPopScope` of the scaffold.
///
class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Container(
            margin: const EdgeInsets.only(right: 20),
            child: Image.asset('lib/assets/images/logo.png')),
      ),
      drawer: CustomDrawer(),
      body: WillPopScope(
        onWillPop: () {
          return showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: Colors.white,
                  title: const Text(
                    AppStrings.exitQues,
                    textAlign: TextAlign.center,
                  ),
                  titleTextStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: ThemeGuide.borderRadius10,
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
                    FlatButton(
                      shape: const RoundedRectangleBorder(
                        borderRadius: ThemeGuide.borderRadius10,
                      ),
                      color: Colors.blue,
                      child: const Text(
                        AppStrings.noUpperCase,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    )
                  ],
                );
              });
        },
        child: Container(
            color: Colors.white,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: const <Widget>[
                Heading(),
                SearchTextInput(),
                CategoryOptions(),
                SizedBox(height: 40),
                HealthConcernList(),
                SizedBox(height: 30),
                SmallHospitalList(),
                SizedBox(height: 40),
                SmallBlogList(),
                SizedBox(height: 50),
              ],
            )),
      ),
    );
  }
}

///
/// ## `Description`
///
/// Text input which can used to search for illness, doctors, hospitals and anything you
/// want. Just plug in your functions and get going.
///
class SearchTextInput extends StatelessWidget {
  const SearchTextInput({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color.fromRGBO(240, 240, 240, 1),
        ),
        child: TextField(
          onChanged: (val) {
            LocatorService.searchProvider().setSearchTerm = val.trim();
          },
          onEditingComplete: () {
            // Change the focus
            FocusScope.of(context).unfocus();

            // Navigate to search screen
            NavigationController.navigator.push(Routes.searchScreen);
          },
          cursorColor: Theme.of(context).cursorColor,
          decoration: const InputDecoration(
            border: InputBorder.none,
            alignLabelWithHint: true,
            hintText: AppStrings.search,
            hintStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
            icon: Padding(
              padding: EdgeInsets.only(
                left: 12,
                top: 12,
                bottom: 12,
                right: 0,
              ),
              child: Icon(
                Icons.search,
                color: Colors.black54,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

///
/// ## `Description`
///
/// Returns the heading text for the `Home` widget.
///
class Heading extends StatelessWidget {
  const Heading({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 40, left: 40),
      child: Text(
        AppStrings.homeHeading,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
