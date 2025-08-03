import 'package:dio/dio.dart';

class DioErrorHandler {
  static Object handle(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          return "Bad request: ${e.response!.data}";
        case 401:
          return "Token Expired. Please log in.";
        case 403:
          return "Forbidden: You don’t have permission.";
        case 404:
          return "Resource not found.";
        case 500:
          return "Internal Server Error. Please try again later.";
        default:
          return "Unexpected error: ${e.response!.statusCode}";
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return "Network timeout. Please check your connection.";
    } else if (e.type == DioExceptionType.connectionError) {
      return "No Internet connection.";
    } else {
      return "Unexpected error: ${e.message}";
    }
  }
}
