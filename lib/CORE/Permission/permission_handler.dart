import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  PermissionHandler._();
  static final PermissionHandler instance = PermissionHandler._();

  Future<void> requestAndroidPermission() async {
    if (!Platform.isAndroid) return;
    await [Permission.audio, Permission.photos].request();
  }
}
