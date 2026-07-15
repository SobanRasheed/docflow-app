import 'dart:io';
import 'package:dio/dio.dart';

Future<void> main() async {
  final envContent = File('.env').readAsStringSync();
  final match = RegExp(r'CLOUDCONVERT_API_KEY=(.*)').firstMatch(envContent);
  final keysString = match?.group(1) ?? '';
  final keys = keysString.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  print('Found ${keys.length} keys in .env');

  final dio = Dio();
  for (int i = 0; i < keys.length; i++) {
    final key = keys[i];
    try {
      final res = await dio.get(
        'https://api.cloudconvert.com/v2/users/me',
        options: Options(headers: {'Authorization': 'Bearer $key'}),
      );
      print('Key ${i + 1}: SUCCESS - User ID: ${res.data['data']['id']}, Credits: ${res.data['data']['credits']}');
    } catch (e) {
      if (e is DioException) {
        print('Key ${i + 1}: FAILED - ${e.response?.statusCode} ${e.response?.data}');
      } else {
        print('Key ${i + 1}: FAILED - $e');
      }
    }
  }
}
