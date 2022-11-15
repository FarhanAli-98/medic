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
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomeContainer extends StatelessWidget {
  const CustomeContainer({
    Key key,
    @required this.speciality,
    this.verticalPadding = 8,
    this.horizontalPadding = 30,
    this.borderRadius = 8,
    this.textSize = 14,
  }) : super(key: key);

  const CustomeContainer.big({
    @required this.speciality,
    this.verticalPadding = 8,
    this.horizontalPadding = 30,
    this.borderRadius = 8,
    this.textSize = 14,
  });

  const CustomeContainer.small({
    @required this.speciality,
    this.verticalPadding = 5,
    this.horizontalPadding = 5,
    this.borderRadius = 4,
    this.textSize = 18,
  });

  final String speciality;
  final double verticalPadding;
  final double horizontalPadding;
  final double borderRadius;
  final double textSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: verticalPadding,
        horizontal: horizontalPadding,
      ),
      child: Text(
        speciality?.toString() ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: GoogleFonts.lato(
            textStyle: Theme.of(context).textTheme.headline4,
            fontSize: textSize,
            fontWeight: FontWeight.w600,
            color: Colors.grey),
      ),
    );
  }
}

/// Helper function to render speciality for doctor
List<Widget> renderSpecialities(List<String> specialities) {
  final ar = specialities ?? [];
  if (ar.isEmpty) {
    return [
      const CustomeContainer.small(speciality: AppStrings.notProvided),
    ];
  }
  return ar.map((speciality) {
    return CustomeContainer.small(speciality: speciality);
  }).toList();
}
