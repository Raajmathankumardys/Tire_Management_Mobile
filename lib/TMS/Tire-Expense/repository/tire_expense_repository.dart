import '../cubit/tire_expense_state.dart';
import '../service/tire_expense_service.dart';

class TireExpenseRepository {
  final TireExpenseService service;

  TireExpenseRepository(this.service);

  Future<List<TireExpense>> getAllTireExpense() => service.fetchTireExpense();

  Future<void> addTireExpense(TireExpense tireexpense) =>
      service.addTireExpense(tireexpense);

  Future<void> updateTireExpense(TireExpense tireexpense) =>
      service.updateTireExpense(tireexpense);

  Future<void> deleteTireExpense(int id) => service.deleteTireExpense(id);
}
