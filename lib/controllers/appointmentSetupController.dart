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

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/appointmentSetupProvider.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AppointmentSetupController extends StatefulWidget {
  @override
  _AppointmentSetupControllerState createState() =>
      _AppointmentSetupControllerState();
}

class _AppointmentSetupControllerState
    extends State<AppointmentSetupController> {
  final AppointmentSetupProvider _appointmentSetupProvider =
      LocatorService.appointmentSetupProvider();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _appointmentSetupProvider.initiateAppointmentWithId();
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return WillPopScope(
      onWillPop: () {
        if (_appointmentSetupProvider.isLoading) {
          return Future.value(false);
        } else {
          return Future.value(true);
        }
      },
      child: Scaffold(
        body: Center(
          child: ChangeNotifierProvider.value(
            value: _appointmentSetupProvider,
            child: Consumer<AppointmentSetupProvider>(
              builder: (context, data, child) {
                if (data.isLoading) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Selector<AppointmentSetupProvider, String>(
                        selector: (context, d) => d.displayMessage,
                        builder: (context, text, _) {
                          return Text(
                            text,
                            style: _theme.textTheme.headline6,
                          );
                        },
                      ),
                      const SizedBox(height: 30),
                      const SpinKitThreeBounce(color: Colors.blue)
                    ],
                  );
                }

                if (data.isAppointmentSuccessfull) {
                  final Color color = Colors.green.shade300;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: ThemeGuide.padding10,
                          decoration: BoxDecoration(
                            borderRadius: ThemeGuide.borderRadius10,
                            border: Border.all(
                              width: 4,
                              color: color,
                            ),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 50,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppStrings.appointmentSuccessfull,
                          textAlign: TextAlign.center,
                          style: _theme.textTheme.headline6,
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          AppStrings.appointmentMessage,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppStrings.appointmentMessage2,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color),
                        ),
                        const SizedBox(height: 30),
                        CupertinoButton(
                          color: color,
                          child: const Text(AppStrings.goToHomeButton),
                          onPressed: () =>
                              NavigationController.navigator.pushAndRemoveUntil(
                            Routes.home,
                            ModalRoute.withName(Routes.home),
                          ),
                        )
                      ],
                    ),
                  );
                }

                if (data.isAppointmentFailed) {
                  final Color color = Colors.red.shade300;
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: ThemeGuide.padding10,
                          decoration: BoxDecoration(
                            borderRadius: ThemeGuide.borderRadius10,
                            border: Border.all(
                              width: 4,
                              color: color,
                            ),
                          ),
                          child: Icon(
                            Icons.error_outline,
                            size: 50,
                            color: color,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          AppStrings.appointmentFailed,
                          textAlign: TextAlign.center,
                          style: _theme.textTheme.headline6,
                        ),
                        const SizedBox(height: 30),
                        CupertinoButton(
                          color: color,
                          child: const Text(AppStrings.tryAgain),
                          onPressed: () => _appointmentSetupProvider
                              .initiateAppointmentWithId(),
                        )
                      ],
                    ),
                  );
                }

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(AppStrings.settingUpAppointment),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
