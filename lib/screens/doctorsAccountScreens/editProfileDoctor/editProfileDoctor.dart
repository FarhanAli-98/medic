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

// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/navigationController.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/screens/doctorsAccountScreens/editProfileDoctor/social_button.dart';
import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/services/imageService/imageService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/themeGuide.dart';
import 'package:doctor_consultation/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileDoctor extends StatelessWidget {
  const EditProfileDoctor({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.editProfile),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: EditProfileDoctorForm(),
        ),
      ),
    );
  }
}

class EditProfileDoctorForm extends StatefulWidget {
  @override
  _EditProfileDoctorFormState createState() => _EditProfileDoctorFormState();
}

class _EditProfileDoctorFormState extends State<EditProfileDoctorForm> {
  String imageUrl = LocatorService.doctorProvider().doctor.imageUrl ??
      'https://via.placeholder.com/150';
  String name = LocatorService.doctorProvider().doctor.name ?? '';
  String experience = LocatorService.doctorProvider().doctor.experience ?? '';
  String fee = LocatorService.doctorProvider().doctor.fee ?? '';
  String about = LocatorService.doctorProvider().doctor.about ?? '';
  String rid = LocatorService.doctorProvider().doctor.registerid ?? '';
  String selectedCountry = LocatorService.doctorProvider().currency;
  bool isloading = false;
  String specialities =
      LocatorService.doctorProvider().doctor.specialities != null
          ? LocatorService.doctorProvider()
              .doctor
              .specialities
              .reduce((prev, next) => prev + ',' + next)
          : '';

  final GlobalKey _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    final ThemeData _theme = Theme.of(context);

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
              lableText: AppStrings.name,
              validator: validateName,
              onChange: (value) => name = value,
            ),
            CustomTextField(
              data: experience,
              hint: AppStrings.experience,
              lableText: AppStrings.experience,
              keyboardType: TextInputType.number,
              validator: validateExp,
              onChange: (val) => experience = val,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomTextField(
              data: fee,
              hint: AppStrings.fee,
              lableText: AppStrings.fee,
              keyboardType: TextInputType.number,
              validator: validateFee,
              onChange: (val) => fee = val,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            CustomTextField(
              data: specialities,
              hint: AppStrings.specialities,
              lableText: AppStrings.specialitiesLable,
              validator: validateSpecialities,
              onChange: (val) => specialities = val,
            ),
            CustomTextField(
              data: rid,
              hint: AppStrings.register,
              lableText: AppStrings.register,
              validator: validateSpecialities,
              onChange: (val) => rid = val,
            ),
            CustomTextField(
              data: about,
              hint: AppStrings.signupAbout,
              lableText: AppStrings.signupAbout,
              maxLines: 8,
              validator: validateSpecialities,
              onChange: (val) => about = val,
            ),
            GestureDetector(
              onTap: () async {
                showCurrencyPicker(
                    context: context,
                    theme: CurrencyPickerThemeData(
                      flagSize: 25,
                      titleTextStyle: const TextStyle(fontSize: 17),
                      subtitleTextStyle: TextStyle(
                          fontSize: 15, color: Theme.of(context).hintColor),
                    ),
                    onSelect: (Currency currency) async {
                      await LocatorService.doctorProvider()
                          .storeCurrency(currency);
                      setState(() {
                        selectedCountry =
                            LocatorService.doctorProvider().currency;
                      });
                    });

                // showCountryPicker(
                //   context: context,

                //   //Optional. Shows phone code before the country name.
                //   showPhoneCode: true,
                //   showWorldWide: false,
                //   onSelect: (Country country) {
                //     setState(() {
                //       print('Select country: ${country.displayName}');
                //       selectedCountry = country.name;
                //     });
                //   },
                //   // Optional. Sets the theme for the country list picker.
                //   countryListTheme: CountryListThemeData(
                //     // Optional. Sets the border radius for the bottomsheet.

                //     // Optional. Styles the search field.
                //     inputDecoration: InputDecoration(
                //       labelText: 'Search',
                //       hintText: 'Start typing to search',
                //       prefixIcon: const Icon(Icons.search),
                //       border: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           color: const Color(0xFF8C98A8).withOpacity(0.2),
                //         ),
                //       ),
                //     ),
                //   ),
                // );
              },
              child: Container(
                height: 40,
                width: 350,
                margin: const EdgeInsets.only(top: 10.0),
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                  color: _theme.inputDecorationTheme.fillColor,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(child: Text(selectedCountry)),
              ),
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
      try {
        setState(() {
          isLoading = true;
        });
        await FirestoreService.updateDoctorData(createUpdatedDataMap());
        LocatorService.doctorProvider()
            .updateDoctorData(createUpdatedDataMap());
        setState(() {
          isLoading = false;
        });
        NavigationController.navigator.pop();
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Map<String, dynamic> createUpdatedDataMap() {
    return {
      'name': name,
      'experience': experience,
      'specialities': specialities != null
          ? specialities
              .split(',')
              .map<String>((e) => e.trim().toLowerCase())
              .toList()
          : [],
      'fee': fee,
      'about': about,
      'register': rid
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

  String validateName(val) {
    if (val.length < 3) {
      return AppStrings.errorShortName;
    }
    return null;
  }

  String validateExp(String val) {
    if (val.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (int.parse(val) > 70) {
      return AppStrings.invalidExperienceTooMuch;
    }
    return null;
  }

  String validateFee(String val) {
    if (val.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (int.parse(val) <= 0) {
      return AppStrings.invalidFeeZero;
    }
    return null;
  }

  String validateSpecialities(String val) {
    if (val.isEmpty) {
      return AppStrings.invalidFieldEmpty;
    }

    if (Validator.isSpecialitiesValid(val)) {
      return null;
    }
    return AppStrings.invalidSpecialities;
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
  String url = LocatorService.doctorProvider().doctor.imageUrl;
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
                onPress: () async {
                  //  final imageFile = await ImageService.getImageFromGallery();

                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return SafeArea(
                          child: Container(
                            child: Wrap(
                              children: <Widget>[
                                ListTile(
                                    leading: const Icon(Icons.photo_library),
                                    title: const Text('Photo Library'),
                                    onTap: () {
                                      uploadPhoto(false);
                                      Navigator.of(context).pop();
                                    }),
                                ListTile(
                                  leading: const Icon(Icons.photo_camera),
                                  title: const Text('Camera'),
                                  onTap: () async {
                                    uploadPhoto(true);
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                lable: 'Image Update',
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<void> uploadPhoto(bool isCamera) async {
    File imageFile;
    if (isCamera) {
      imageFile = await ImageService.getImage();
      print('Image from Camera = $imageFile');
    } else {
      imageFile = await ImageService.getImageFromGallery();
      print('Image from Gallery = $imageFile');
    }

    // If the file value is not null proceed
    if (imageFile != null) {
      setState(() {
        isLoading = true;
      });

      // get the doctor id
      final userId = LocatorService.doctorProvider().doctor.uid;

      if (userId != null && userId != '') {
        // start uploading
        final newUrl = await FirebaseStorageService.uploadFile(
          imageFile,
          fileName: userId,
        );

        // check for upload status
        if (newUrl != null) {
          // update the database
          await FirestoreService.updateDoctorImageUrl(newUrl);
          // Update the data
          LocatorService.doctorProvider().updateImage(newUrl);

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
