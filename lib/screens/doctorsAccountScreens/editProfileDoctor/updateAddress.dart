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
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/doctorProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UpdateAddress extends StatelessWidget {
  const UpdateAddress({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.updateAddress),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: UpdateAddressForm(),
        ),
      ),
    );
  }
}

class UpdateAddressForm extends StatefulWidget {
  @override
  _UpdateAddressFormState createState() => _UpdateAddressFormState();
}

class _UpdateAddressFormState extends State<UpdateAddressForm> {
  String street, city, state, pin, country;
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final address = locator<DoctorProvider>().doctor?.address;

    if (address != null) {
      street = address.street;
      city = address.city;
      state = address.state;
      pin = address.pin;
      country = address.country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            CustomTextField(
              data: street,
              hint: AppStrings.street,
              lableText: AppStrings.street,
              validator: (val) {},
              onChange: (value) => street = value,
            ),
            CustomTextField(
              data: city,
              hint: AppStrings.city,
              lableText: AppStrings.city,
              validator: (val) {},
              onChange: (value) => city = value,
            ),
            CustomTextField(
              data: state,
              hint: AppStrings.state,
              lableText: AppStrings.state,
              validator: (val) {},
              onChange: (value) => state = value,
            ),
            CustomTextField(
              data: pin,
              hint: AppStrings.pin,
              lableText: AppStrings.pin,
              validator: (val) {},
              onChange: (val) => pin = val,
            ),
            CustomTextField(
              data: country,
              hint: AppStrings.country,
              lableText: AppStrings.country,
              validator: (val) {},
              onChange: (value) => country = value,
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              child: Center(
                child: Submit(
                  onPress: () => saveChanges(),
                  isLoading: isLoading,
                  lable: AppStrings.save,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Save the changes to the firestore, when the update is complete, sava the changes
  /// in the local storage as well.
  Future<void> saveChanges() async {
    if (validateForm(_formKey)) {
      setState(() {
        isLoading = true;
      });
      await FirestoreService.updateDoctorAddress(createUpdatedDataMap());
      locator<DoctorProvider>().updateDoctorAddress(createUpdatedDataMap());
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> createUpdatedDataMap() {
    return {
      'street': street,
      'city': city,
      'state': state,
      'pin': pin,
      'country': country,
    };
  }

  // Functions
  static bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    this.data,
    this.hint,
    this.onChange,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    @required this.validator,
    this.inputFormatters,
    this.lableText,
  }) : super(key: key);

  final String data, hint, lableText;
  final void Function(String) onChange;
  final Function validator;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ClipRRect(
        borderRadius: ThemeGuide.borderRadius,
        child: TextFormField(
          initialValue: data,
          validator: validator,
          inputFormatters: inputFormatters,
          cursorColor: _theme.cursorColor,
          textInputAction: TextInputAction.done,
          maxLines: maxLines ?? 1,
          onChanged: onChange,
          textAlignVertical: TextAlignVertical.center,
          keyboardType: keyboardType,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            hintText: hint ?? '',
            labelText: lableText,
          ),
        ),
      ),
    );
  }
}
