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

// ignore_for_file: unused_local_variable

import 'dart:io';
import 'dart:math' as math;

import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class FirebaseStorageService {
  static Future<String> uploadFile(File imageFile, {String fileName}) async {
    // The ref. to the new url
    String downloadedUrl;

    final String name =
        fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference = FirebaseStorage.instance.ref().child(name);
    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    await storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        downloadedUrl = downloadUrl;
      },
      onError: (err) {
        Fluttertoast.showToast(msg: 'This file is not an image');
      },
    );
    return downloadedUrl;
  }

  static Future<String> uploadImages(File imageFile, {String fileName}) async {
    // The ref. to the new url
    String downloadedUrl;

    final String name =
        fileName ?? DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference = FirebaseStorage.instance
        .ref()
        .child('Gallery')
        .child('images')
        .child(name)
        .child('${DateTime.now()}');
    final UploadTask uploadTask = reference.putFile(imageFile);
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    await storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        downloadedUrl = downloadUrl;
      },
      onError: (err) {
        Fluttertoast.showToast(msg: err);
      },
    );
    return downloadedUrl;
  }

  static Future<String> uploadVideo(File imageFile, {String fileName}) async {
    // The ref. to the new url
    String downloadedUrl;
    //FirebaseStorage storage = FirebaseStorage.instance;
    final String name =
        fileName + DateTime.now().millisecondsSinceEpoch.toString();
    final Reference reference = FirebaseStorage.instance
        .ref()
        .child('Gallery')
        .child('videos')
        .child(fileName)
        .child(name);
    final UploadTask uploadTask = reference.putFile(
      imageFile,
      SettableMetadata(
        contentType: 'video/mp4',
      ),
    );
    final TaskSnapshot storageTaskSnapshot = await uploadTask;
    await storageTaskSnapshot.ref.getDownloadURL().then(
      (downloadUrl) {
        downloadedUrl = downloadUrl;
      },
      onError: (err) {
        Fluttertoast.showToast(msg: err);
      },
    );
    print(downloadedUrl);
    return downloadedUrl;
  }

  static Future<List<String>> fetchImages(String uniqueUserId) async {
    List<String> files = [];
    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('Gallery')
        .child('images')
        .child(uniqueUserId)
        .list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      print('result is $fileUrl');

      files.add(fileUrl);
    });

    return files;
  }

  // Future<List<Map<String, dynamic>>> _loadImages() async {
  //   List<Map<String, dynamic>> files = [];

  //   final ListResult result = await storage.ref().list();
  //   final List<Reference> allFiles = result.items;

  //   await Future.forEach<Reference>(allFiles, (file) async {
  //     final String fileUrl = await file.getDownloadURL();
  //     final FullMetadata fileMeta = await file.getMetadata();
  //     files.add({
  //       'url': fileUrl,
  //       'path': file.fullPath,
  //       'uploaded_by': fileMeta.customMetadata['uploaded_by'] ?? 'Nobody',
  //       'description':
  //           fileMeta.customMetadata['description'] ?? 'No description'
  //     });
  //   });

  //   return files;
  // }
}
