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

import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class ImageService {
  static Future<File> getImage() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (imageFile != null) {
      return File(imageFile.path);
    } else {
      return null;
    }
  }

  static Future<File> getImageFromGallery() async {
    final imageFile = await ImagePicker().getImage(source: ImageSource.gallery);

    if (imageFile != null) {
      return File(imageFile.path);
    } else {
      return null;
    }
  }

  static Future<File> getVideoFromGallery() async {
    final imageFile = await ImagePicker().getVideo(source: ImageSource.camera);
    if (imageFile != null) {
      return File(imageFile.path);
    } else {
      return null;
    }
  }
}
