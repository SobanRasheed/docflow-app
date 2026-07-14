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

  /// Reads the iLovePDF public key from --dart-define first, then falls back
  /// to a gitignored .env file. The getter contains no secret literal itself.
  static String get publicKey {
    const env = String.fromEnvironment('ILOVEPDF_PUBLIC_KEY');
    if (env.isNotEmpty) return env;
    return dotenv.maybeGet('ILOVEPDF_PUBLIC_KEY') ?? '';
  }

  static bool get hasPublicKey => publicKey.isNotEmpty;
}