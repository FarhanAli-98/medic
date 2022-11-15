// // ignore_for_file: unnecessary_parenthesis

// import 'dart:developer';

// import 'package:doctor_consultation/locator.dart';
// import 'package:doctor_consultation/models/userModel.dart';
// import 'package:doctor_consultation/services/api/firebaseStorageService.dart';
// import 'package:doctor_consultation/services/imageService/imageService.dart';
// import 'package:get/get.dart';

// class MediaController extends GetxController {
//   static MediaController instance = Get.find();

//   RxList<dynamic> images = [].obs;
//   FAuthUser user;
//   List<int> flLeftSide = [];
//   int totalSafeCount = 0;
//   int totalUnsafeCount = 0;
//   double percentage = 0;
//   String status = '';

//   Future<void> mediaImages(String userid) async {
//     images = [].obs;
//     images.value = await FirebaseStorageService.fetchImages(userid);
//     log(images.length.toString(), name: 'IMG');
//     update();
//   }

//   Future uploadToStorage() async {
//     final file = await ImageService.getVideoFromGallery();
//     FirebaseStorageService.uploadVideo(file, fileName: user.uid);
//   }

//   Future addImageToList(String url) async {
//     images.add(url);
//     update();
//   }
// }
