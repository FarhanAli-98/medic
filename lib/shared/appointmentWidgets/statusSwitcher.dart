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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/appointmentsProvider.dart';
import 'package:doctor_consultation/shared/animatedButton.dart';
import 'package:doctor_consultation/shared/customLoader.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

///
/// ## `Description`
///
/// This is a container for the bottom sheet to change the status of
/// the appointment.
///
class StatusSwitcher extends StatelessWidget {
  const StatusSwitcher({
    Key key,
    @required this.onPositive,
    @required this.onNegative,
  }) : super(key: key);

  final Function onPositive, onNegative;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: LocatorService.appointmentsProvider(),
      child: Selector<AppointmentsProvider, bool>(
        selector: (context, d) => d.isChangingStatus,
        builder: (context, isChanging, child) {
          return Container(
            margin: ThemeGuide.padding10,
            child: isChanging
                ? const Center(
                    child: CustomLoader(),
                  )
                : child,
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text(
              AppStrings.appointmentQuestion,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              AppStrings.appointmentQuestionMessage,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blueGrey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: AnimButton(
                    onTap: () => onNegative(),
                    child: Container(
                      padding: ThemeGuide.padding,
                      decoration: const BoxDecoration(
                        borderRadius: ThemeGuide.borderRadius10,
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 2,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          AppStrings.noUpperCase,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFFE53935),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: AnimButton(
                    onTap: () => onPositive(),
                    child: Container(
                      padding: ThemeGuide.padding,
                      decoration: const BoxDecoration(
                        borderRadius: ThemeGuide.borderRadius10,
                        border: Border.fromBorderSide(
                          BorderSide(
                            width: 2,
                            color: Color(0xFF43A047),
                          ),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          AppStrings.yesUpperCase,
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF43A047),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
