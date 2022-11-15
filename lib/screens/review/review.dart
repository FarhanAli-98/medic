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

// ignore_for_file: deprecated_member_use

import 'dart:ui';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:doctor_consultation/services/payment/payment.dart';
import 'package:doctor_consultation/shared/widgets/categoryOptionsModal.dart';
import 'package:doctor_consultation/shared/widgets/formatOptionsModal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Review extends StatelessWidget {
  const Review({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.review),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.illness,
                    style: _theme.textTheme.bodyText2,
                  ),
                  Row(
                    children: <Widget>[
                      ChangeNotifierProvider<ConsultationProvider>.value(
                        value: LocatorService.consultationProvider(),
                        child: Selector<ConsultationProvider, String>(
                          selector: (context, d) => d.title,
                          builder: (context, title, _) {
                            return Text(
                              title,
                              style: _theme.textTheme.headline5,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      // OutlineButton(
                      //   highlightColor: Colors.transparent,
                      //   splashColor: Colors.blue.withAlpha(50),
                      //   highlightedBorderColor: Colors.blue,
                      //   child: const Text(AppStrings.change),
                      //   onPressed: () => UiController.showModal(
                      //     context,
                      //     CategoryOptionsModal(),
                      //   ),
                      // ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.consultFormat,
                    style: _theme.textTheme.bodyText2,
                  ),
                  Row(
                    children: <Widget>[
                      ChangeNotifierProvider<ConsultationProvider>.value(
                        value: LocatorService.consultationProvider(),
                        child: Selector<ConsultationProvider, String>(
                          selector: (context, d) => d.formatTypeString,
                          builder: (context, formatType, _) {
                            return Text(
                              formatType,
                              style: _theme.textTheme.headline5,
                            );
                          },
                        ),
                      ),
                      const Spacer(),
                      OutlineButton(
                        highlightColor: Colors.transparent,
                        splashColor: Colors.blue.withAlpha(50),
                        highlightedBorderColor: Colors.blue,
                        child: const Text(AppStrings.change),
                        onPressed: () => UiController.showModal(
                          context,
                          const FormatOptionsModal(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        Config.CURRENCY +
                            ' ' +
                            LocatorService.consultationProvider().amount,
                        style: _theme.textTheme.headline4.copyWith(
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        AppStrings.paymentMessage,
                        style: _theme.textTheme.bodyText2.copyWith(
                          color: Colors.black54,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton.filled(
                          child: Text(
                            AppStrings.proceedToPay,
                            style: _theme.textTheme.button
                                .copyWith(color: Colors.white),
                          ),
                          onPressed: () => NavigationController.navigator
                              .popAndPush(Routes.sSLCommerzPayment),

                          // NavigationController.navigator
                          //     .popAndPush(Routes.paymentWebview),
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 1.1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: CupertinoButton.filled(
                            child: Text(
                              AppStrings.proceedToPayWithSSL,
                              style: _theme.textTheme.button
                                  .copyWith(color: Colors.white),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (__) => PaymentMethod(),
                              ));

                              //           NavigationController.navigator
                              // .popAndPush(Routes.sSLCommerzPayment),
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
