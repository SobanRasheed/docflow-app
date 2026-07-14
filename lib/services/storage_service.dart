import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class StorageService {
  const StorageService._();

  static Future<Directory> getOutputDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final outDir = Directory(p.join(dir.path, 'docflow', 'outputs'));
    if (!await outDir.exists()) {
      await outDir.create(recursive: true);
    }
    return outDir;
  }

  static Future<void> deleteFile(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}