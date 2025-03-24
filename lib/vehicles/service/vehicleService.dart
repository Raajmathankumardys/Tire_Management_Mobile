import 'package:dio/dio.dart';

class BaseService<T> {
  final Dio dio = Dio();
  final String baseUrl;

  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;

  BaseService({
    required this.baseUrl,
    required this.fromJson,
    required this.toJson,
  });

  Future<List<T>> fetchAll() async {
    try {
      print("Fetching...");
      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        print(response.data);
        if (response.data is List) {
          return (response.data as List)
              .map((json) => fromJson(json as Map<String, dynamic>))
              .toList();
        } else {
          throw Exception(
              "Unexpected response format: Expected List, got ${response.data.runtimeType}");
        }
      } else {
        throw Exception("Failed to fetch items: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> create(T item) async {
    try {
      final response = await dio.post(baseUrl, data: toJson(item));
      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception("Failed to create item: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> update(T item, int id) async {
    try {
      final response = await dio.put("$baseUrl/$id", data: toJson(item));
      if (response.statusCode != 200) {
        throw Exception("Failed to update item: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> remove(int id) async {
    try {
      final response = await dio.delete("$baseUrl/$id");
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete item: ${response.statusCode}");
      }
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
