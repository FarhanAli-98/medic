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

import 'package:permission_handler/permission_handler.dart';

Future<bool> handleCameraAndMic() async {
  final PermissionStatus cameraPermission = await Permission.camera.status;
  final PermissionStatus micPermission = await Permission.microphone.status;

  if (cameraPermission == PermissionStatus.granted &&
      micPermission == PermissionStatus.granted) {
    return true;
  } else {
    final statuses = await [Permission.camera, Permission.microphone].request();
    if (statuses[Permission.camera] == PermissionStatus.granted &&
        statuses[Permission.microphone] == PermissionStatus.granted) {
      return true;
    } else {
      return false;
    }
  }
}

Future<bool> requestPermissions() async {
  await [Permission.camera, Permission.microphone].request();
  return await handleCameraAndMic();
}

Future<void> openSettings() async {
  await openAppSettings();
}
