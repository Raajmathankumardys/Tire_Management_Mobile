import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/expense_state.dart';

class ExpenseService {
  static final ExpenseService _instance = ExpenseService._internal();

  late final Dio _dio;

  factory ExpenseService() {
    return _instance;
  }

  ExpenseService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<Expense>> fetchExpense(int tripId) async {
    print(tripId);
    try {
      final response = await _dio.get(expenseconstants.endpointget(tripId));
      return (response.data['data'] as List)
          .map((v) => Expense.fromJson(v))
          .toList(growable: false);
      // return [
      //   Expense(
      //       id: 1,
      //       tripId: 21,
      //       category: ExpenseCategory.FUEL,
      //       amount: 100,
      //       expenseDate: DateTime.now(),
      //       description: "-",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Expense(
      //       id: 2,
      //       tripId: 21,
      //       category: ExpenseCategory.MISCELLANEOUS,
      //       amount: 200,
      //       expenseDate: DateTime.now(),
      //       description: "M",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Expense(
      //       id: 3,
      //       tripId: 21,
      //       category: ExpenseCategory.MAINTENANCE,
      //       amount: 50,
      //       expenseDate: DateTime.now(),
      //       description: "Ma",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Expense(
      //       id: 4,
      //       tripId: 21,
      //       category: ExpenseCategory.DRIVER_ALLOWANCE,
      //       amount: 150,
      //       expenseDate: DateTime.now(),
      //       description: "M",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Expense(
      //       id: 5,
      //       tripId: 21,
      //       category: ExpenseCategory.TOLL,
      //       amount: 50,
      //       expenseDate: DateTime.now(),
      //       description: "M",
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now())
      // ];
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addExpense(Expense expense) async {
    try {
      await _dio.post(expenseconstants.endpoint(expense.tripId),
          data: expense.toJson());
      //print(expense.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateExpense(Expense expense) async {
    try {
      await _dio.put(expenseconstants.endpoint(expense.id),
          data: expense.toJson());
      //print(expense.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteExpense(int id) async {
    try {
      await _dio.delete(expenseconstants.endpoint(id));
      //print(id);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
