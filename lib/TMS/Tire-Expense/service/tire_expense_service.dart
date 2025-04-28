import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
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
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTireExpense(TireExpense tirexxpense) async {
    try {
      await _dio.post(tireexpenseconstants.endpoint,
          data: tirexxpense.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateTireExpense(TireExpense tirexxpense) async {
    try {
      await _dio.put('${tireexpenseconstants.endpoint}/${tirexxpense.id}',
          data: tirexxpense.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteTireExpense(int id) async {
    try {
      await _dio.delete('${tireexpenseconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
