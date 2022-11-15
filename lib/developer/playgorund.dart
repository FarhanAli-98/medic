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

import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';

class Playground extends StatefulWidget {
  const Playground({Key key}) : super(key: key);
  @override
  _PlaygroundState createState() => _PlaygroundState();
}

class _PlaygroundState extends State<Playground> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Playground')),
      body: SafeArea(
        top: true,
        bottom: true,
        child: Stack(
          children: [
            Container(
              color: Colors.red.shade300,
              child: const Center(child: Text('User1')),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: ThemeGuide.padding10,
                width: 150,
                height: 220,
                decoration: BoxDecoration(
                  color: Colors.green.shade200,
                  borderRadius: ThemeGuide.borderRadius10,
                ),
                child: const Center(child: Text('User2')),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class M {
  M({this.message, this.id});
  String message, id;
}
