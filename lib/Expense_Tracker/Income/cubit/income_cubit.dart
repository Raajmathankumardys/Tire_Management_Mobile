import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../repository/income_repository.dart';
import 'income_state.dart';

class IncomeCubit extends Cubit<IncomeState> {
  final IncomeRepository repository;
  IncomeCubit(this.repository) : super(IncomeInitial());

  void fetchIncome(int tripId) async {
    try {
      emit(IncomeLoading());
      final income = await repository.getAllIncome(tripId);
      emit(IncomeLoaded(income));
    } catch (e) {
      emit(IncomeError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addIncome(Income income) async {
    try {
      await repository.addIncome(income);
      emit(AddedIncomeState(incomeconstants.addedtoast));
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
    fetchIncome(income.tripId);
  }

  void updateIncome(Income income) async {
    try {
      await repository.updateIncome(income);
      emit(UpdatedIncomeState(incomeconstants.updatedtoast));
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
    fetchIncome(income.tripId);
  }

  void deleteIncome(Income income, int id) async {
    try {
      await repository.deleteIncome(id);
      emit(DeletedIncomeState(incomeconstants.deletetoast));
    } catch (e) {
      emit(IncomeError(e.toString()));
    }
    fetchIncome(income.tripId);
  }
}
