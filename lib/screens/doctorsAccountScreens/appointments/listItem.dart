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
import 'dart:developer';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/enumStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/controllers/uiController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/appointmentModel.dart';
import 'package:doctor_consultation/providers/consultationProvider.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/appointments/moreOptions.dart';
import 'package:doctor_consultation/shared/appointmentWidgets/activeStatus.dart';
import 'package:doctor_consultation/shared/appointmentWidgets/appointmentStatusBuilder.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:doctor_consultation/utils/handlePermissions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// List item for the appointments list. Used to show
/// appointments information as a single tile.
///
class AppointmentsListItemDoctor extends StatefulWidget {
  const AppointmentsListItemDoctor({Key key, this.appointment})
      : super(key: key);

  final Appointment appointment;

  @override
  _AppointmentsListItemDoctorState createState() =>
      _AppointmentsListItemDoctorState();
}

class _AppointmentsListItemDoctorState extends State<AppointmentsListItemDoctor>
    with WidgetsBindingObserver {
  StreamSubscription docStream;
  bool isActive = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    docStream = LocatorService.communicationProvider()
        .getAppointmentDocStream(widget.appointment.uid)
        .listen(handleChange);
  }

  void handleChange(event) {
    log('Appointment updates listening for id ${event.id}');
    setState(() {
      isActive = event.data()['isUserActive'];
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.paused) {
      log('State changed to paused', name: 'List Item');
      log('Disposed stream with id ${widget.appointment.uid}');
      docStream?.cancel();
    }
    if (state == AppLifecycleState.inactive) {
      log('Disposed stream with id ${widget.appointment.uid}');
      log('State changed to inactive', name: 'List Item');
      docStream?.cancel();
    }
    if (state == AppLifecycleState.detached) {
      log('Disposed stream with id ${widget.appointment.uid}');
      log('State changed to detached', name: 'List Item');
      docStream?.cancel();
    }
    if (state == AppLifecycleState.resumed) {
      log('State changed to resumed', name: 'List Item');
      docStream = LocatorService.communicationProvider()
          .getAppointmentDocStream(widget.appointment.uid)
          .listen(handleChange);
    }
  }

  @override
  void dispose() {
    log('Disposed stream with id ${widget.appointment.uid}');
    docStream?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BuildItem(
      appointment: widget.appointment,
      isActive: isActive,
    );
  }
}

class _BuildItem extends StatelessWidget {
  const _BuildItem({Key key, this.appointment, this.isActive = false})
      : super(key: key);

  final Appointment appointment;
  final bool isActive;

  String setConsultationType(type) {
    switch (type) {
      case ConsultationFormatType.CHAT:
        return EnumStrings.CHAT;
        break;

      case ConsultationFormatType.VIDEO_CALL:
        return EnumStrings.VIDEO_CALL;
        break;

      case ConsultationFormatType.VOICE_CALL:
        return EnumStrings.VOICE_CALL;
        break;

      case ConsultationFormatType.NOT_DEFINED:
        return EnumStrings.NOT_DEFINED;
        break;

      default:
        return EnumStrings.NOT_DEFINED;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Stack(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.all(10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: _theme.colorScheme.secondary,
            borderRadius: ThemeGuide.borderRadius,
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(230, 230, 230, 1),
                blurRadius: 5,
                spreadRadius: 2,
                offset: Offset(0.0, 3.0),
              ),
            ],
          ),
          child: FlatButton(
            highlightColor: Colors.transparent,
            splashColor: _theme.primaryColorLight.withOpacity(0.2),
            onPressed: () => handleClick(context, appointment),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text(
                          appointment.title ?? '',
                          style: _theme.textTheme.headline6,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            Text(
                              '${AppStrings.date}: ',
                              style: _theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              appointment.createdAt ?? '',
                              style: _theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              '${AppStrings.type}: ',
                              style: _theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black38,
                              ),
                            ),
                            Text(
                              setConsultationType(
                                      appointment.consultationType) ??
                                  '',
                              style: _theme.textTheme.caption.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: <Widget>[
                            if (appointment.status ==
                                AppointmentStatusType.SCHEDULED)
                              const AppointmentStatusBuilder.scheduled(),
                            if (appointment.status ==
                                AppointmentStatusType.PREVIOUS)
                              const AppointmentStatusBuilder.previous(),
                            if (appointment.status ==
                                AppointmentStatusType.CANCELLED)
                              const AppointmentStatusBuilder.cancelled(),
                            if (appointment.status ==
                                AppointmentStatusType.NOT_DEFINED)
                              const AppointmentStatusBuilder.notDefined(),
                            const Spacer(),
                            if (isActive) const ActiveStatus(),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RotatedBox(
              quarterTurns: 1,
              child: IconButton(
                tooltip: 'More Options',
                icon: const Icon(
                  CupertinoIcons.ellipsis,
                  color: Colors.black,
                ),
                onPressed: () => moreOptions(context, appointment),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void moreOptions(BuildContext context, Appointment appointment) {
    if (appointment.status == AppointmentStatusType.SCHEDULED) {
      // Show bottom sheet to set the status of the appointment.
      UiController.modalBottomSheet(
        context,
        child: MoreOptions(
          appointment: appointment,
        ),
      );
    }
  }

  Future<void> handleClick(
      BuildContext context, Appointment appointment) async {
    if (appointment.consultationType == ConsultationFormatType.VIDEO_CALL ||
        appointment.consultationType == ConsultationFormatType.VOICE_CALL) {
      final perm = await handleCameraAndMic();

      if (perm) {
        NavigationController.navigator.push(
          Routes.communicationController,
          arguments: CommunicationControllerArguments(
            appointment: appointment,
          ),
        );
        return;
      }
      UiController.showSnackBar(
        context,
        AppStrings.noPermissions,
        actionLable: AppStrings.givePermissions,
        actionFun: () => openSettings(),
      );
    } else {
      NavigationController.navigator.push(
        Routes.communicationController,
        arguments: CommunicationControllerArguments(
          appointment: appointment,
        ),
      );
    }
  }
}

class PreviousAppointmentItemDoctor extends StatelessWidget {
  const PreviousAppointmentItemDoctor({Key key, this.appointment})
      : super(key: key);

  final Appointment appointment;

  String setConsultationType(type) {
    switch (type) {
      case ConsultationFormatType.CHAT:
        return EnumStrings.CHAT;
        break;

      case ConsultationFormatType.VIDEO_CALL:
        return EnumStrings.VIDEO_CALL;
        break;

      case ConsultationFormatType.VOICE_CALL:
        return EnumStrings.VOICE_CALL;
        break;

      case ConsultationFormatType.NOT_DEFINED:
        return EnumStrings.NOT_DEFINED;
        break;

      default:
        return EnumStrings.NOT_DEFINED;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: _theme.colorScheme.secondary,
        borderRadius: ThemeGuide.borderRadius,
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(230, 230, 230, 1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(0.0, 3.0),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    appointment.title ?? '',
                    style: _theme.textTheme.headline6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${AppStrings.date}: ',
                        style: _theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                        appointment.createdAt ?? '',
                        style: _theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${AppStrings.type}: ',
                        style: _theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black38,
                        ),
                      ),
                      Text(
                        setConsultationType(appointment.consultationType) ?? '',
                        style: _theme.textTheme.caption.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const AppointmentStatusBuilder.previous(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
