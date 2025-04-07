import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

import '../cubit/tire_performance_state.dart';

class TirePerformanceService {
  static final TirePerformanceService _instance =
      TirePerformanceService._internal();

  late final Dio _dio;

  factory TirePerformanceService() {
    return _instance;
  }

  TirePerformanceService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TirePerformance>> fetchTirePerformance(int id) async {
    try {
      final response = await _dio.get(tireperformancesconstants.endpoint(id));
      return (response.data['data'] as List)
          .map((v) => TirePerformance.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addTirePerformance(TirePerformance tireperformance) async {
    try {
      await _dio.post(
          tireperformancesconstants.addendpoint(tireperformance.tireId),
          data: tireperformance.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          return Exception("Bad request: ${e.response!.data}");
        case 401:
          return Exception("Unauthorized access. Please log in.");
        case 403:
          return Exception("Forbidden: You don’t have permission.");
        case 404:
          return Exception("Resource not found.");
        case 500:
          return Exception("Internal Server Error. Please try again later.");
        default:
          return Exception("Unexpected error: ${e.response!.statusCode}");
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception("Network timeout. Please check your connection.");
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception("No Internet connection.");
    } else {
      return Exception("Unexpected error: ${e.message}");
    }
  }
}
