import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  const PermissionService._();

  /// Requests storage/media access appropriate for the current Android version.
  ///
  /// - Android < 13: requests READ_EXTERNAL_STORAGE
  /// - Android 13+:  file_picker v12 uses ACTION_OPEN_DOCUMENT which needs no
  ///   runtime permission — we request READ_MEDIA_IMAGES as a best-effort and
  ///   treat any non-denied result (including permanentlyDenied on 13+) as OK,
  ///   since the system document picker will handle access itself.
  static Future<bool> requestStorage() async {
    // Try the legacy storage permission (works on Android ≤ 12).
    final storageStatus = await Permission.storage.status;
    if (storageStatus.isGranted) return true;

    if (storageStatus.isDenied) {
      final result = await Permission.storage.request();
      if (result.isGranted) return true;
    }

    // On Android 13+, Permission.storage is deprecated and will be restricted.
    // Request media permissions instead; the file picker itself handles the rest.
    final photos = await Permission.photos.request();
    if (photos.isGranted || photos.isLimited) return true;

    // If still not granted, allow anyway — file_picker v12 uses the system
    // document picker (ACTION_OPEN_DOCUMENT) which works without any permission.
    return true;
  }

  static Future<bool> requestPhotos() async {
    final status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) return true;
    final result = await Permission.photos.request();
    return result.isGranted || result.isLimited;
  }
}