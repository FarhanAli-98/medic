// ignore_for_file: always_declare_return_types, prefer_final_locals, prefer_const_constructors

import 'dart:convert';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_neat_and_clean_calendar/flutter_neat_and_clean_calendar.dart';

import 'slots.dart';

class Schedule extends StatelessWidget {
  const Schedule({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CalendarScreen();
  }
}

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Force selection of today on first load, so that the list of today's events gets shown.
    _handleNewDate(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Calendar(
          startOnMonday: true,
          weekDays: const ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'],
          eventsList: LocatorService.appointmentSetupProvider().eventList,
          isExpandable: true,
          eventDoneColor: Color.fromARGB(255, 233, 27, 27),
          selectedColor: Color.fromARGB(255, 27, 229, 57),
          todayColor: Colors.blue,
          eventColor: null,
          locale: 'de_DE',
          todayButtonText: 'Slots',
          allDayEventText: 'Ganztägig',
          multiDayEndText: 'Ende',
          isExpanded: true,
          onDateSelected: (date) {
            setState(() {
              selectedDate = date;
              print('Date selected: $date');
            });
          },
          expandableDateFormat: 'EEEE, dd. MMMM yyyy',
          datePickerType: DatePickerType.date,
          dayOfWeekStyle: TextStyle(
              backgroundColor: Colors.white,
              color: Colors.black,
              fontWeight: FontWeight.w800,
              fontSize: 11),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          LocatorService.appointmentSetupProvider().slots(selectedDate, 30);
          NavigationController.navigator.push(
            Routes.slots,
            arguments: SlotsArguments(
              time: selectedDate,
            ),
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleNewDate(date) {
    print('_handleNewDate selected: $date');
  }
}
