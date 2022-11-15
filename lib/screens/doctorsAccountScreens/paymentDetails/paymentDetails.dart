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

// ignore_for_file: missing_return, deprecated_member_use

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/providers/doctorProvider.dart';
import 'package:doctor_consultation/providers/paymentDetailsProvider.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PaymentDetails extends StatelessWidget {
  const PaymentDetails({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.paymentDetails),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: PaymentDetailsForm(),
        ),
      ),
    );
  }
}

class PaymentDetailsForm extends StatefulWidget {
  @override
  _PaymentDetailsFormState createState() => _PaymentDetailsFormState();
}

class _PaymentDetailsFormState extends State<PaymentDetailsForm> {
  //String street, city, state, pin, country;
  final gendreDropdownList = [
    const DropdownMenuItem(child: Text('Bank'), value: 'Bank'),
    const DropdownMenuItem(child: Text('Bkash'), value: 'Bkash'),
    // const DropdownMenuItem(child: Text('Other'), value: 'other'),
  ];
  String bankName,
      fullName,
      mobileNo,
      accountName,
      branch,
      routingNum,
      bankAccountNo;
  String paymentMethod;
  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final payment = locator<PaymentDetailsProvider>().doctor?.payment;
    paymentMethod = 'Bank';
    if (payment != null) {
      bankName = payment.bankName;
      fullName = payment.fullName;
      mobileNo = payment.mobileNo;
      accountName = payment.accountName;
      branch = payment.branch;
      routingNum = payment.routingNum;
      bankAccountNo = payment.bankAccountNo;
      paymentMethod = payment.paymentMethod ?? 'Bank';
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
            DropdownButtonFormField(
              value: paymentMethod ?? 'Bank',
              items: gendreDropdownList,
              onChanged: setGenderValue,
            ),
            if (paymentMethod != 'Bank')
              CustomTextField(
                data: fullName,
                hint: AppStrings.fullName,
                lableText: AppStrings.fullName,
                validator: validateFullName,
                onChange: (value) => fullName = value,
              )
            else
              Container(),
            if (paymentMethod != 'Bank')
              CustomTextField(
                data: mobileNo,
                hint: AppStrings.mobileNo,
                lableText: AppStrings.mobileNo,
                validator: validateMobileNo,
                onChange: (value) => mobileNo = value,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              )
            else
              Container(),
            if (paymentMethod == 'Bank')
              CustomTextField(
                data: accountName,
                hint: AppStrings.accountName,
                lableText: AppStrings.accountName,
                validator: validateAccountName,
                onChange: (value) => accountName = value,
              )
            else
              Container(),
            if (paymentMethod == 'Bank')
              CustomTextField(
                data: bankAccountNo,
                hint: AppStrings.bankAccountNo,
                lableText: AppStrings.bankAccountNo,
                validator: validateBankAccountNo,
                onChange: (val) => bankAccountNo = val,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              )
            else
              Container(),
            if (paymentMethod == 'Bank')
              CustomTextField(
                data: branch,
                hint: AppStrings.branch,
                lableText: AppStrings.branch,
                validator: validateBranch,
                onChange: (value) => branch = value,
              )
            else
              Container(),
            if (paymentMethod == 'Bank')
              CustomTextField(
                data: bankName,
                hint: AppStrings.bankName,
                lableText: AppStrings.bankName,
                validator: validateBankName,
                onChange: (value) => bankName = value,
              )
            else
              Container(),
            if (paymentMethod == 'Bank')
              CustomTextField(
                data: routingNum,
                hint: AppStrings.routingNum,
                lableText: AppStrings.routingNum,
                validator: validateRoutingNum,
                onChange: (value) => routingNum = value,
              )
            else
              Container(),
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

  void setGenderValue(String val) {
    setState(() {
      paymentMethod = val ?? 'Bank';
    });
  }

  String validateFullName(String val) {
    if (val.isEmpty) {
      return 'Full Name Is Required';
    }
  }

  String validateMobileNo(String val) {
    if (val.isEmpty) {
      return 'Mobile No Is Required';
    }
    if (val.length > 10 || val.length < 10) {
      return 'Mobile No Should Be 10 Digits';
    }
    return null;
  }

  String validateAccountName(String val) {
    if (val.isEmpty) {
      return 'Account Name Is Required';
    }
  }

  String validateBankAccountNo(String val) {
    if (val.isEmpty) {
      return 'Bank Account No Is Required';
    }
    if (val.length > 15) {
      return 'Bank Account No Should Be Not More Then 15 Digits';
    }
    if (val.length < 15) {
      return 'Bank Account No Should Not Be Less Then 10 Digits';
    }
    return null;
  }

  String validateBranch(String val) {
    if (val.isEmpty) {
      return 'Branch Is Required';
    }
  }

  String validateBankName(String val) {
    if (val.isEmpty) {
      return 'Bank Name Is Required';
    }
  }

  String validateRoutingNum(String val) {
    if (val.isEmpty) {
      return 'Routing Number Is Required';
    }
  }

  /// Save the changes to the firestore, when the update is complete, sava the changes
  /// in the local storage as well.
  Future<void> saveChanges() async {
    if (validateForm(_formKey)) {
      setState(() {
        isLoading = true;
      });
      await FirestoreService.updateDoctorPayment(createUpdatedDataMap());
      locator<DoctorProvider>().updatePayment(createUpdatedDataMap());
      setState(() {
        isLoading = false;
      });
    }
  }

  Map<String, dynamic> createUpdatedDataMap() {
    return {
      'bankName': bankName,
      'fullName': fullName,
      'mobileNo': mobileNo,
      'accountName': accountName,
      'branch': branch,
      'routingNum': routingNum,
      'bankAccountNo': bankAccountNo,
      'paymentMethod': paymentMethod,
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
