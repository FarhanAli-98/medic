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

import 'dart:developer';
import 'package:doctor_consultation/locator.dart';
import 'package:doctor_consultation/models/userModel.dart';
import 'package:doctor_consultation/providers/utils/baseProvider.dart';
import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
import 'package:doctor_consultation/services/imageService/imageService.dart';
import 'package:flutter/widgets.dart';

///
/// ## Description
///
/// Provider that handles `Media` data in the state.
/// Cares about the user data after it has been loaded into memory from the server.
///

class MediaProvider extends BaseProvider {
  List<dynamic> images = [];
  FAuthUser user;

  Future<void> mediaImages(String userid) async {
    try {
      if (userid.isEmpty) {
        userid = await LocatorService.authService().currentUserId();
      }

      images = [];
      images = await FirebaseStorageService.fetchImages(userid);
      if (images.isEmpty) {
        log('No data');
        notifyState(ViewState.NO_DATA_AVAILABLE);
        return;
      } else {
        log(images.length.toString(), name: 'IMG');
        notifyState(ViewState.DATA);
      }
    } catch (e) {
      notifyError(errorText: e.toString());
    }
  }

  Future uploadToStorage() async {
    final file = await ImageService.getVideoFromGallery();
    FirebaseStorageService.uploadVideo(file, fileName: user.uid);
  }

  Future addImageToList(String url) async {
    images.add(url);
    notifyListeners();
  }
}
