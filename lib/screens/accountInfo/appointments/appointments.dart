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
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/providers/appointmentsProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/screens/accountInfo/appointments/listItem.dart';
import 'package:doctor_consultation/shared/appointmentWidgets/nothingYetPlaceholder.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Appointments extends StatelessWidget {
  const Appointments({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(AppStrings.appointmentsTitle),
          bottom: TabBar(
            indicator: BoxDecoration(
              borderRadius: ThemeGuide.borderRadius,
              color: _theme.primaryColorLight.withAlpha(45),
            ),
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black26,
            tabs: const <Widget>[
              Tab(text: AppStrings.scheduledTab),
              Tab(text: AppStrings.previousTab),
            ],
          ),
        ),
        body: ChangeNotifierProvider.value(
          value: LocatorService.appointmentsProvider(),
          child: ViewStateSelector<AppointmentsProvider>(
            getData: () => LocatorService.appointmentsProvider().fetchData(),
            child: Selector<AppointmentsProvider, int>(
              selector: (context, d) => d.totalAppointments,
              builder: (context, count, _) {
                return const TabBarView(
                  children: <Widget>[
                    _ScheduledAppointmentsListView(),
                    _PreviousAppointmentsListView(),
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

///
/// ## `Description`
///
/// Page to show all the scheduled appointments
///
class _ScheduledAppointmentsListView extends StatelessWidget {
  const _ScheduledAppointmentsListView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Selector<AppointmentsProvider, List<Appointment>>(
      selector: (context, d) => d.scheduledAppointmentsList,
      shouldRebuild: (a, b) => true,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const NothingYetPlaceholder();
        } else {
          return RefreshIndicator(
            color: Colors.black,
            onRefresh: () => LocatorService.appointmentsProvider().fetchData(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length,
              itemBuilder: (context, int i) {
                return AppointmentsListItem(
                  appointment: list[i],
                );
              },
            ),
          );
        }
      },
    );
  }
}

///
/// ## `Description`
///
/// Page to show all the previous appointments
///
class _PreviousAppointmentsListView extends StatelessWidget {
  const _PreviousAppointmentsListView({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Selector<AppointmentsProvider, List<Appointment>>(
      selector: (context, d) => d.previousAppointmentsList,
      shouldRebuild: (a, b) => true,
      builder: (context, list, _) {
        if (list.isEmpty) {
          return const NothingYetPlaceholder();
        } else {
          return RefreshIndicator(
            color: Colors.black,
            onRefresh: () => LocatorService.appointmentsProvider().fetchData(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length,
              itemBuilder: (context, int i) {
                return PreviousAppointmentItem(
                  appointment: list[i],
                );
              },
            ),
          );
        }
      },
    );
  }
}
