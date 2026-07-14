import 'package:dio/dio.dart';

import '../config/api_config.dart';

class DioClient {
  DioClient._();

  static Dio create() {
    return Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: Duration(milliseconds: ApiConfig.connectTimeoutMs),
        receiveTimeout: Duration(milliseconds: ApiConfig.receiveTimeoutMs),
        sendTimeout: const Duration(seconds: 60),
        validateStatus: (status) => status != null && status < 500,
      ),
    );
  }
}