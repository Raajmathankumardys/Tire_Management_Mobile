import '../cubit/income_state.dart';
import '../service/income_service.dart';

class IncomeRepository {
  final IncomeService service;

  IncomeRepository(this.service);

  Future<List<Income>> getAllIncome(int tripId) => service.fetchIncome(tripId);

  Future<void> addIncome(Income income) => service.addIncome(income);

  Future<void> updateIncome(Income income) => service.updateIncome(income);

  Future<void> deleteIncome(int id) => service.deleteIncome(id);
}
