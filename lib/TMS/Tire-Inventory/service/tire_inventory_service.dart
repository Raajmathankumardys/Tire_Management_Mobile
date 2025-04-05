import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../cubit/tire_inventory_state.dart';

class TireInventoryService {
  static final TireInventoryService _instance =
      TireInventoryService._internal();

  late final Dio _dio;

  factory TireInventoryService() {
    return _instance;
  }

  TireInventoryService._internal() {
    _dio = Dio(BaseOptions(
        baseUrl: dotenv.env["BASE_URL"] ??
            " ")); // baseUrl is probably a typo. You're welcome.
  }

  Future<List<TireInventory>> fetchTireInventory() async {
    try {
      final response = await _dio.get('/tires');
      return (response.data['data'] as List)
          .map((v) => TireInventory.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addTireInventory(TireInventory tireinventory) async {
    try {
      await _dio.post('/tires', data: tireinventory.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateTireInventory(TireInventory tireinventory) async {
    try {
      await _dio.put('/tires/${tireinventory.id}',
          data: tireinventory.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTireInventory(int id) async {
    try {
      await _dio.delete('/tires/$id');
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
