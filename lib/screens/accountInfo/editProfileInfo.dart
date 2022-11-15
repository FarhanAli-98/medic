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
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/services/imageService/imageService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
      ),
      body: const Padding(
        padding: ThemeGuide.padding20,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: EditProfileForm(),
        ),
      ),
    );
  }
}

class EditProfileForm extends StatefulWidget {
  const EditProfileForm({Key key}) : super(key: key);
  @override
  _EditProfileFormState createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<EditProfileForm> {
  String imageUrl =
      LocatorService.userProvider().user.imageUrl ?? Config.placeholedImageUrl;
  String name = LocatorService.userProvider().user.name;
  String phoneNumber = LocatorService.userProvider().user.phoneNumber;
  String age = LocatorService.userProvider().user.age;
  String dob = LocatorService.userProvider().user.dob;
  String gender = LocatorService.userProvider().user.gender;

  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final dateMaskFormatter = MaskTextInputFormatter(
    mask: '##-##-####',
    filter: {
      '#': RegExp(r'[0-9]'),
    },
  );

  final gendreDropdownList = [
    const DropdownMenuItem(child: Text('Male'), value: 'male'),
    const DropdownMenuItem(child: Text('Female'), value: 'female'),
    const DropdownMenuItem(child: Text('Other'), value: 'other'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            PhotoUpdate(),
            CustomTextField(
              data: name,
              hint: AppStrings.name,
              iconData: Icons.perm_identity,
              validator: validateName,
              onChange: (value) => name = value,
            ),
            CustomTextField(
              data: phoneNumber,
              hint: AppStrings.phoneNumber,
              iconData: Icons.call,
              keyboardType: TextInputType.number,
              validator: validatePhoneNumber,
              onChange: (val) => phoneNumber = val,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomTextField(
              data: age,
              hint: AppStrings.age,
              iconData: Icons.perm_contact_calendar,
              keyboardType: TextInputType.number,
              validator: validateAge,
              onChange: (val) => age = val,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomTextField(
              data: dob,
              hint: AppStrings.dob,
              iconData: Icons.date_range,
              keyboardType: TextInputType.number,
              validator: validateDob,
              onChange: (val) => dob = val,
              inputFormatters: [dateMaskFormatter],
            ),
            const SizedBox(
              height: 10,
            ),
            DropdownButtonFormField(
              value: gender ?? 'male',
              items: gendreDropdownList,
              onChanged: setGenderValue,
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
      await FirestoreService.updateUserData(createUpdatedDataMap());
      LocatorService.userProvider().updateUserData(createUpdatedDataMap());
      setState(() {
        isLoading = false;
      });
      NavigationController.navigator.pop();
    }
  }

  Map<String, dynamic> createUpdatedDataMap() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'age': age,
      'dob': dob,
      'gender': gender?.toLowerCase(),
    };
  }

  static bool validateForm(GlobalKey<FormState> formKey) {
    if (formKey.currentState.validate()) {
      return true;
    } else {
      return false;
    }
  }

  String validateName(val) {
    if (val.toString().length < 3) {
      return AppStrings.errorShortName;
    }
    return null;
  }

  String validateAge(val) {
    if (val == null || val == '') {
      return null;
    }
    if (int.parse(val) > 100) {
      return AppStrings.errorAgeInvalid;
    }
    return null;
  }

  String validatePhoneNumber(val) {
    if (val == null || val == '') {
      return null;
    }
    if (val.toString().length > 13 || val.toString().length < 7) {
      return AppStrings.errorNumberInvalid;
    } else {
      return null;
    }
  }

  String validateDob(val) {
    if (val == null || val == '') {
      return null;
    }

    if (dob.isNotEmpty && dob.toString().length == 10) {
      return null;
    }

    final date = dateMaskFormatter.getUnmaskedText();
    if (date.toString().length != 8) {
      return AppStrings.errorInvalidDob;
    } else {
      return null;
    }
  }

  void setGenderValue(String val) {
    setState(() {
      gender = val;
    });
  }
}

///
/// ## `Description`
///
/// PhotoUpdate handler
///
class PhotoUpdate extends StatefulWidget {
  @override
  _PhotoUpdateState createState() => _PhotoUpdateState();
}

class _PhotoUpdateState extends State<PhotoUpdate> {
  bool isLoading = false;
  String url = LocatorService.userProvider().user.imageUrl;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          height: 120,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: ThemeGuide.borderRadius,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(url),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: Submit(
                isLoading: isLoading,
                onPress: () => uploadPhoto(),
                lable: AppStrings.update,
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> uploadPhoto() async {
    // Wait to get the file path.
    final imageFile = await ImageService.getImage();

    // If the file value is not null proceed
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      // get the user id
      final userId = LocatorService.userProvider().user.uid;

      if (userId != null && userId != '') {
        // start uploading
        final newUrl = await FirebaseStorageService.uploadFile(
          imageFile,
          fileName: userId,
        );

        // check for upload status
        if (newUrl != null) {
          // update the database
          await FirestoreService.updateImageUrl(newUrl);
          LocatorService.userProvider().updateImage(newUrl);

          setState(() {
            url = newUrl;
            isLoading = false;
          });
        } else {
          setState(() {
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    }
  }
}

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    Key key,
    this.data,
    this.hint,
    this.onChange,
    this.iconData,
    this.maxLines,
    this.keyboardType = TextInputType.text,
    @required this.validator,
    this.inputFormatters,
  }) : super(key: key);

  final String data, hint;
  final void Function(String) onChange;
  final IconData iconData;
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
            prefixIcon: Icon(
              iconData,
            ),
          ),
        ),
      ),
    );
  }
}
