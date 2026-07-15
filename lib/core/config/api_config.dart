import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'CLOUDCONVERT_BASE_URL',
    defaultValue: 'https://api.cloudconvert.com/v2/jobs',
  );

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 60000;
  static const int maxRetries = 2;
  static const int maxFileSizeMb = 50;

  static int currentKeyIndex = 0;

  /// CloudConvert API Keys
  static List<String> get publicKeys {
    String rawKeys = '';
    // 1. Try --dart-define
    const env = String.fromEnvironment('CLOUDCONVERT_API_KEY');
    if (env.isNotEmpty) {
      rawKeys = env;
    } else {
      // 2. Try .env file
      final dotEnvKey = dotenv.maybeGet('CLOUDCONVERT_API_KEY');
      if (dotEnvKey != null && dotEnvKey.isNotEmpty) {
        rawKeys = dotEnvKey;
      }
    }
    
    if (rawKeys.isEmpty) return [];
    
    return rawKeys.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  static String get currentPublicKey {
    final keys = publicKeys;
    if (keys.isEmpty) return '';
    if (currentKeyIndex >= keys.length) return ''; // Exhausted
    return keys[currentKeyIndex];
  }

  static bool get hasPublicKey => publicKeys.isNotEmpty;
}
