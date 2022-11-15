//Caution: Only works on Android & iOS platforms
// ignore_for_file: prefer_const_constructors, deprecated_member_use

import 'dart:io';

import 'package:doctor_consultation/constants/appStrings.dart';
import 'package:doctor_consultation/controllers/controller.dart';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
import 'package:doctor_consultation/services/api/firestoreService.dart';
import 'package:doctor_consultation/services/imageService/imageService.dart';
import 'package:doctor_consultation/shared/authScreenWidgets/authSreenWidgets.dart';
import 'package:doctor_consultation/themes/theme.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../../../models/userModel.dart';

final Color orange = Color(0xfffb6900);

class UploadingImageToFirebaseStorage extends StatefulWidget {
  @override
  _UploadingImageToFirebaseStorageState createState() =>
      _UploadingImageToFirebaseStorageState();
}

class _UploadingImageToFirebaseStorageState
    extends State<UploadingImageToFirebaseStorage> {
  File _imageFile;
  bool isLoading = false;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  ///
  final picker = ImagePicker();

  Future pickImage() async {
    // Wait to get the file path.
    _imageFile = await ImageService.getImage().then((value) {
      setState(() {});
      return value;
    });
  }

  Future<void> uploadPhoto(BuildContext context) async {
    // If the file value is not null proceed
    if (_imageFile != null) {
      setState(() {
        isLoading = true;
      });

      // get the user id
      FAuthUser user = await LocatorService.authService().currentUser();
      // final userId = LocatorService.userProvider().user.uid ?? '';
      print(user.uid);

      if (user.uid != null && user.uid != '') {
        // start uploading
        final newUrl = await FirebaseStorageService.uploadImages(
          _imageFile,
          fileName: user.uid,
        );

        // check for upload status
        if (newUrl != null) {
          LocatorService.mediaProvider().addImageToList(newUrl);
          LocatorService.userProvider().addMediaImages(newUrl);

          setState(() {
            isLoading = false;
            Fluttertoast.showToast(msg: 'Image upload sucessfully');
            Navigator.pop(context);
          });
        } else {
          Fluttertoast.showToast(msg: 'Image failed to upload');

          setState(() {
            isLoading = false;
          });
        }
      } else {
        Fluttertoast.showToast(msg: 'Image failed to upload');

        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50.0),
                    bottomRight: Radius.circular(50.0)),
                gradient: LinearGradient(
                    colors: [orange, LightTheme.mRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight)),
          ),
          Container(
            margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                      child: Text(
                    'With growing competition, it can be difficult to maximize your exposure and reach a target audience thats willing to pay for high-end medical services.Thats where Big Buzz comes in.',
                    textAlign: TextAlign.justify,
                    overflow: TextOverflow.fade,
                    style: GoogleFonts.lato(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w400,
                    ),
                  )),
                ),
                SizedBox(height: 20.0),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: double.infinity,
                        margin: const EdgeInsets.only(
                            left: 30.0, right: 30.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile)
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 100,
                  child: Center(
                    child: Submit(
                      onPress: () => uploadPhoto(context),
                      isLoading: isLoading,
                      lable: AppStrings.upload,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
