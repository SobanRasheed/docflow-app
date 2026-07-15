import 'dart:io';
import 'package:dio/dio.dart';
import 'package:docflow/core/config/api_config.dart';
import 'package:docflow/services/cloudconvert_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Tests API Key Failover', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    // Simulate environment loading
    final envContent = File('.env').readAsStringSync();
    final match = RegExp(r'CLOUDCONVERT_API_KEY=(.*)').firstMatch(envContent);
    final validKeys = match?.group(1) ?? '';
    
    // Create a fake environment with an INVALID key first, then the valid keys
    final fakeKeys = 'invalid_key_123,' + validKeys;
    
    await dotenv.load(fileName: ".env");
    dotenv.env['CLOUDCONVERT_API_KEY'] = fakeKeys;
    
    print('Injected Keys: ${ApiConfig.publicKeys.length}');
    print('First Key: ${ApiConfig.publicKeys[0]}');
    print('Second Key: ${ApiConfig.publicKeys[1]}');
    
    print('\nTesting Failover Mechanism...');
    
    final service = CloudConvertService();
    try {
      final formats = await service.getSupportedFormats();
      print('SUCCESS! Formats fetched: ${formats.length}');
      print('Current Key Index after operation: ${ApiConfig.currentKeyIndex}');
      expect(ApiConfig.currentKeyIndex > 0, true);
      print('FAILOVER WORKED! It skipped the invalid key and used the next one.');
    } catch (e) {
      print('ERROR: $e');
      fail('Exception thrown instead of failing over');
    }
  });
}
