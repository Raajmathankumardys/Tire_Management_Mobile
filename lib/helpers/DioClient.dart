import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'DioInterceptorHelper.dart';

class DioClient {
  static Dio createDio() {
    final baseUrl = dotenv.env["BASE_URL"] ?? "";

    final options = BaseOptions(
      baseUrl: baseUrl,
    );

    final dio = Dio(options);
    dio.interceptors.add(DioInterceptorHelper.createInterceptor());
    return dio;
  }
}
