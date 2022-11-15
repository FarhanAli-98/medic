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
import 'package:doctor_consultation/models/hospitalModel.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class HospitalListItem extends StatelessWidget {
  const HospitalListItem({Key key, @required this.hospital}) : super(key: key);

  final Hospital hospital;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
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
                      hospital.imageUrl ?? 'https://via.placeholder.com/100'),
                  fit: BoxFit.cover,
                ),
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
                      hospital.name ?? '',
                      style: _theme.textTheme.subtitle1
                          .copyWith(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: Text(
                        hospital.phoneNumber ?? '',
                        style: _theme.textTheme.caption.copyWith(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        hospital.email ?? '',
                        style: _theme.textTheme.caption.copyWith(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${hospital.address.street ?? ''} ${hospital.address.city ?? ''} ${hospital.address.state ?? ''} ${hospital.address.country ?? ''}',
                        style: _theme.textTheme.caption.copyWith(
                          color: Colors.black38,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
