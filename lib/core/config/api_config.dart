import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'FREECONVERT_BASE_URL',
    defaultValue: 'https://api.freeconvert.com/v1/process/jobs',
  );

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 60000;
  static const int maxRetries = 2;
  static const int maxFileSizeMb = 50;

  /// FreeConvert API Key
  static String get publicKey {
    // 1. Try --dart-define
    const env = String.fromEnvironment('FREECONVERT_API_KEY');
    if (env.isNotEmpty) return env;
    
    // 2. Try .env file
    final dotEnvKey = dotenv.maybeGet('FREECONVERT_API_KEY');
    if (dotEnvKey != null && dotEnvKey.isNotEmpty) return dotEnvKey;

    // 3. Hardcoded fallback (your provided key)
    return 'api_production_d1d547b882c79479b595a0f66435ac61a5bfc4c753e2934c6cd9997ef5ac2259.6a5632029c8b7ba61e343ea2.6a5632249c8b7ba61e343eaa';
  }

  static bool get hasPublicKey => publicKey.isNotEmpty;
}
