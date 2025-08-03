import '../cubit/expense_state.dart';
import '../service/expense_service.dart';

class ExpenseRepository {
  final ExpenseService service;

  ExpenseRepository(this.service);

  Future<List<Expense>> getAllExpense(String tripId) =>
      service.fetchExpense(tripId);

  Future<void> addExpense(Expense expense) => service.addExpense(expense);

  Future<void> updateExpense(Expense expense) => service.updateExpense(expense);

  Future<void> deleteExpense(String id, String tripId) =>
      service.deleteExpense(id, tripId);
}
