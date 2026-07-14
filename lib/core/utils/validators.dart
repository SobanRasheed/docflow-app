import 'dart:io';

import '../constants/app_constants.dart';
import '../utils/exceptions.dart';
import '../../models/tool_type.dart';

class Validators {
  const Validators._();

  static void validateFile(File file, ToolType tool) {
    if (!file.existsSync()) {
      throw FileTooLargeException(0, AppConstants.maxFileSizeMb.toInt());
    }

    final stat = file.statSync();
    final sizeMb = stat.size / (1024 * 1024);
    if (sizeMb > AppConstants.maxFileSizeMb) {
      throw FileTooLargeException(sizeMb, AppConstants.maxFileSizeMb.toInt());
    }

    final ext = file.path.split('.').last.toLowerCase();
    if (!tool.accepts(ext)) {
      throw UnsupportedFormatException(ext, tool.title);
    }
  }
}