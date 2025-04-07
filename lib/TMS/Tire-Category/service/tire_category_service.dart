import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

import '../cubit/tire_category_state.dart';

class TireCategoryService {
  static final TireCategoryService _instance = TireCategoryService._internal();

  late final Dio _dio;

  factory TireCategoryService() {
    return _instance;
  }

  TireCategoryService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TireCategory>> fetchTireCategory() async {
    try {
      final response = await _dio.get(tirecategoryconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => TireCategory.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addTireCategory(TireCategory tirecategory) async {
    try {
      await _dio.post(tirecategoryconstants.endpoint,
          data: tirecategory.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateTireCategory(TireCategory tirecategory) async {
    try {
      await _dio.put('${tirecategoryconstants.endpoint}/${tirecategory.id}',
          data: tirecategory.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTireCategory(int id) async {
    try {
      await _dio.delete('${tirecategoryconstants.endpoint}/$id');
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
