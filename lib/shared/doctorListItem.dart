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

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/constants/config.dart';
import 'package:doctor_consultation/models/doctorModel.dart';
import 'package:doctor_consultation/shared/specialityContainer.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

///
/// ## `Description`
///
/// Returns the layout widget for the list of doctors.
///
class DoctorListItem extends StatelessWidget {
  const DoctorListItem({Key key, this.doctor}) : super(key: key);

  final Doctor doctor;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    var radius = 20.0;

    return Container(
      padding: const EdgeInsets.all(10),
      height: 140,
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          color: _theme.accentColor,
          borderRadius: ThemeGuide.borderRadius,
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(220, 220, 220, 0.6),
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0.0, 2.0),
            ),
          ],
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 100,
              width: 90,
              decoration: BoxDecoration(
                borderRadius: ThemeGuide.borderRadius,
                color: Colors.black12,
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                      doctor.imageUrl ?? 'https://via.placeholder.com/100'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: // doctor.online?
                              Colors.green
                          //  :Colors.white
                          ),
                      width: radius / 2,
                      height: radius / 2,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      '${AppStrings.dr} ' + doctor.name,
                      style: _theme.textTheme.subtitle1.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Flexible(
                      child: Text(
                        '${AppStrings.exp}: ' +
                            doctor.experience +
                            ' ${AppStrings.years}',
                        style: _theme.textTheme.bodyText1.copyWith(
                          fontSize: _theme.textTheme.caption.fontSize,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${doctor.address.street ?? ''} ${doctor.address.city ?? ''} ${doctor.address.state ?? ''} ${doctor.address.country ?? ''}',
                        style: _theme.textTheme.caption.copyWith(
                          color: _theme.disabledColor,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SpecialityContainer.small(
                      speciality: doctor.specialities[0],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              height: 100,
              width: 90,
              decoration: BoxDecoration(
                color: Theme.of(context).disabledColor.withOpacity(0.15),
                borderRadius: ThemeGuide.borderRadius,
              ),
              child: Center(
                child: Text(
                  '${Config.CURRENCY_SYMBOL.isNotEmpty ? Config.CURRENCY_SYMBOL : Config.CURRENCY} ${doctor.fee ?? ' '}',
                  style: _theme.textTheme.subtitle1.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
