import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  const ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'ILOVEPDF_BASE_URL',
    defaultValue: 'https://api.ilovepdf.com/v1',
  );

  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 60000;
  static const int maxRetries = 2;
  static const int maxFileSizeMb = 50;

  /// iLovePDF Public Key
  static String get publicKey {
    // 1. Try --dart-define
    const env = String.fromEnvironment('ILOVEPDF_PUBLIC_KEY');
    if (env.isNotEmpty) return env;
    
    // 2. Try .env file
    final dotEnvKey = dotenv.maybeGet('ILOVEPDF_PUBLIC_KEY');
    if (dotEnvKey != null && dotEnvKey.isNotEmpty) return dotEnvKey;

    // 3. Hardcoded fallback (your provided key)
    return 'project_public_12caf94bff6a22a64d34bcf28f2450be_CasLM3395ec90549c1992fa7e78429f3665da';
  }

  static bool get hasPublicKey => publicKey.isNotEmpty;
}
