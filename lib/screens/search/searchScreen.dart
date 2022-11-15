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

import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/screens/search/inputContainer/inputContainer.dart';
import 'package:doctor_consultation/screens/search/searchList/searchList.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InputContainer(),
      ),
      body: ChangeNotifierProvider.value(
        value: LocatorService.searchProvider(),
        child: SearchList(),
      ),
    );
  }
}
