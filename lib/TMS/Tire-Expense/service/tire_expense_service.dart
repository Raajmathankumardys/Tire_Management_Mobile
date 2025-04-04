import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
    final response = await _dio.get('/tire-expenses');
    return (response.data['data'] as List)
        .map((v) => TireExpense.fromJson(v))
        .toList(growable: false);
  }

  Future<void> addTireExpense(TireExpense tirexxpense) async {
    await _dio.post('/tire-expenses', data: tirexxpense.toJson());
  }

  Future<void> updateTireExpense(TireExpense tirexxpense) async {
    await _dio.put('/tire-expenses/${tirexxpense.id}',
        data: tirexxpense.toJson());
  }

  Future<void> deleteTireExpense(int id) async {
    await _dio.delete('/tire-expenses/$id');
  }
}
