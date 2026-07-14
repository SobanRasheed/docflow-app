import 'package:intl/intl.dart';

class Formatters {
  const Formatters._();

  static String formatBytes(int bytes) {
    if (bytes <= 0) return "0 B";
    const sizes = ["B", "KB", "MB", "GB", "TB"];
    var i = (bytes.bitLength() / 10).floor();
    return "${(bytes / (1 << (i * 10))).toStringAsFixed(1)} ${sizes[i]}";
  }

  static String formatDate(DateTime date) {
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  }
}