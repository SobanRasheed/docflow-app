import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService._();

  static Future<bool> requestStorage() async {
    if (await Permission.storage.isGranted) return true;
    final result = await Permission.storage.request();
    return result.isGranted;
  }

  static Future<bool> requestPhotos() async {
    if (await Permission.photos.isGranted) return true;
    final result = await Permission.photos.request();
    return result.isGranted;
  }
}