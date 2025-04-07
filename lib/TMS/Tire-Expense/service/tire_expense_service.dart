import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../cubit/tire_expense_state.dart';

class TireExpenseService {
  static final TireExpenseService _instance = TireExpenseService._internal();

  late final Dio _dio;

  factory TireExpenseService() {
    return _instance;
  }

  TireExpenseService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TireExpense>> fetchTireExpense() async {
    try {
      final response = await _dio.get(tireexpenseconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => TireExpense.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addTireExpense(TireExpense tirexxpense) async {
    try {
      await _dio.post(tireexpenseconstants.endpoint,
          data: tirexxpense.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateTireExpense(TireExpense tirexxpense) async {
    try {
      await _dio.put('${tireexpenseconstants.endpoint}/${tirexxpense.id}',
          data: tirexxpense.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteTireExpense(int id) async {
    try {
      await _dio.delete('${tireexpenseconstants.endpoint}/$id');
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
