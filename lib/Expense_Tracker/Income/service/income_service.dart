import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/income_state.dart';

class IncomeService {
  static final IncomeService _instance = IncomeService._internal();

  late final Dio _dio;

  factory IncomeService() {
    return _instance;
  }

  IncomeService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<Income>> fetchIncome(int tripId) async {
    print(tripId);
    try {
      final response = await _dio.get(incomeconstants.endpointget(tripId));
      return (response.data['data'] as List)
          .map((v) => Income.fromJson(v))
          .toList(growable: false);
      // return [
      //   Income(
      //       id: 1,
      //       tripId: 21,
      //       amount: 100,
      //       incomeDate: DateTime.parse("2025-02-12T17:20:44.089092"),
      //       description: "-",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Income(
      //       id: 2,
      //       tripId: 21,
      //       amount: 200,
      //       incomeDate: DateTime.now(),
      //       description: "-",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now())
      // ];
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addIncome(Income income) async {
    try {
      await _dio.post(incomeconstants.endpoint(income.tripId),
          data: income.toJson());
      // print(income.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateIncome(Income income) async {
    try {
      await _dio.put(incomeconstants.endpoint(income.id),
          data: income.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteIncome(int id) async {
    try {
      await _dio.delete(incomeconstants.endpoint(id));
      //print(id);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
