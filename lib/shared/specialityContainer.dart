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

class SpecialityContainer extends StatelessWidget {
  const SpecialityContainer({
    Key key,
    @required this.speciality,
    this.verticalPadding = 8,
    this.horizontalPadding = 30,
    this.borderRadius = 8,
    this.textSize = 14,
  }) : super(key: key);

  const SpecialityContainer.big({
    @required this.speciality,
    this.verticalPadding = 8,
    this.horizontalPadding = 30,
    this.borderRadius = 8,
    this.textSize = 14,
  });

  const SpecialityContainer.small({
    @required this.speciality,
    this.verticalPadding = 5,
    this.horizontalPadding = 15,
    this.borderRadius = 4,
    this.textSize = 14,
  });


    const SpecialityContainer.defalut({
    @required this.speciality,
    this.verticalPadding = 5,
    this.horizontalPadding = 15,
    this.borderRadius = 4,
    this.textSize = 14,
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
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 137, 255, 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Text(
        speciality?.toString()?.toUpperCase() ?? '',
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: textSize,
          letterSpacing: 1.5,
          color: const Color.fromRGBO(0, 137, 255, 1),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// Helper function to render speciality for doctor
List<Widget> renderSpecialities(List<String> specialities) {
  final ar = specialities ?? [];
  if (ar.isEmpty) {
    return [
      const SpecialityContainer.small(speciality: AppStrings.notProvided),
    ];
  }
  return ar.map((speciality) {
    return SpecialityContainer.small(speciality: speciality);
  }).toList();
}
