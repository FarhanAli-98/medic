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
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/providers/appointmentsProvider.dart';
import 'package:doctor_consultation/providers/widgets/viewStateSelector.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/appointments/listItem.dart';
import 'package:doctor_consultation/shared/appointmentWidgets/nothingYetPlaceholder.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppointmentsDoctor extends StatelessWidget {
  const AppointmentsDoctor({Key key}) : super(key: key);
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
              color: _theme.primaryColorLight.withOpacity(0.2),
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
            getData: () =>
                LocatorService.appointmentsProvider().fetchDoctorsData(),
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
/// ## Description
///
/// Tabbar View to show list of orders on the screen.
/// Based on the index from the parent widget.
///
/// ## Important
/// - Index no. 1 = Scheduled Appointments
/// - Index no. 2 = Previous Appointments
/// - Index no. 3 = Cancelled Appointments
///
class IndexView extends StatelessWidget {
  const IndexView({Key key, this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    List list;
    switch (index) {
      case 1:
        list = LocatorService.appointmentsProvider().scheduledAppointmentsList;
        break;

      case 2:
        list = LocatorService.appointmentsProvider().previousAppointmentsList;
        break;

      case 3:
        list = LocatorService.appointmentsProvider().cancelledAppointmentsList;
        break;

      default:
        list = LocatorService.appointmentsProvider().scheduledAppointmentsList;
    }

    if (list.isEmpty) {
      return Center(
        child: Text(
          AppStrings.nothing,
          style: Theme.of(context).textTheme.subtitle1.copyWith(
                color: Theme.of(context).disabledColor,
              ),
        ),
      );
    } else {
      return RefreshIndicator(
        color: Colors.black,
        onRefresh: () =>
            LocatorService.appointmentsProvider().fetchDoctorsData(),
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          itemCount: list.length,
          itemBuilder: (context, int i) {
            return AppointmentsListItemDoctor(
              appointment: list[i],
            );
          },
        ),
      );
    }
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
            onRefresh: () =>
                LocatorService.appointmentsProvider().fetchDoctorsData(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length,
              itemBuilder: (context, int i) {
                return AppointmentsListItemDoctor(
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
            onRefresh: () =>
                LocatorService.appointmentsProvider().fetchDoctorsData(),
            child: ListView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              itemCount: list.length,
              itemBuilder: (context, int i) {
                return PreviousAppointmentItemDoctor(
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
