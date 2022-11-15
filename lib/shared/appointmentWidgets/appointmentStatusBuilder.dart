import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class AppointmentStatusBuilder extends StatelessWidget {
  const AppointmentStatusBuilder.scheduled({
    Key key,
    this.type = 1,
  }) : super(key: key);

  const AppointmentStatusBuilder.previous({
    Key key,
    this.type = 2,
  }) : super(key: key);

  const AppointmentStatusBuilder.cancelled({
    Key key,
    this.type = 3,
  }) : super(key: key);

  const AppointmentStatusBuilder.notDefined({
    Key key,
    this.type = 0,
  }) : super(key: key);

  final int type;

  static const Color colorScheduled = Color(0xFF66BB6A);
  static const Color bgColorScheduled = Color(0xFFE8F5E9);
  static const String textScheduled = AppStrings.scheduledTab;

  static const Color colorPrevious = Color(0xFF42A5F5);
  static const Color bgColorPrevious = Color(0xFFE3F2FD);
  static const String textPrevious = AppStrings.previousTab;

  static const Color colorCancelled = Color(0xFFEF5350);
  static const Color bgColorCancelled = Color(0xFFFFEBEE);
  static const String textCancelled = AppStrings.cancelledTab;

  static const Color colorNotDefined = Color(0xFFBDBDBD);
  static const Color bgColorNotDefined = Color(0xFFFAFAFA);
  static const String textNotDefined = '';

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case 1:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: const BoxDecoration(
            borderRadius: ThemeGuide.borderRadius,
            color: bgColorScheduled,
          ),
          child: const Text(
            textScheduled,
            style: TextStyle(
              color: colorScheduled,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        break;
      case 2:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: const BoxDecoration(
            borderRadius: ThemeGuide.borderRadius,
            color: bgColorPrevious,
          ),
          child: const Text(
            textPrevious,
            style: TextStyle(
              color: colorPrevious,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        break;
      case 3:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: const BoxDecoration(
            borderRadius: ThemeGuide.borderRadius,
            color: bgColorCancelled,
          ),
          child: const Text(
            textCancelled,
            style: TextStyle(
              color: colorCancelled,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
        break;
      default:
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
          decoration: const BoxDecoration(
            borderRadius: ThemeGuide.borderRadius,
            color: bgColorNotDefined,
          ),
          child: const Text(
            textNotDefined,
            style: TextStyle(
              color: colorNotDefined,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        );
    }
  }
}
