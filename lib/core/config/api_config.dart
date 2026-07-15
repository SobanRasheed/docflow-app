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

  /// CloudConvert API Key
  static String get publicKey {
    // 1. Try --dart-define
    const env = String.fromEnvironment('CLOUDCONVERT_API_KEY');
    if (env.isNotEmpty) return env;
    
    // 2. Try .env file
    final dotEnvKey = dotenv.maybeGet('CLOUDCONVERT_API_KEY');
    if (dotEnvKey != null && dotEnvKey.isNotEmpty) return dotEnvKey;

    return '';
  }

  static bool get hasPublicKey => publicKey.isNotEmpty;
}
