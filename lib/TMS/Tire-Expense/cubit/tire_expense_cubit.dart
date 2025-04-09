import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

import '../repository/tire_expense_repository.dart';
import 'tire_expense_state.dart';

class TireExpenseCubit extends Cubit<TireExpenseState> {
  final TireExpenseRepository repository;
  TireExpenseCubit(this.repository) : super(TireExpenseInitial());

  void fetchTireExpense() async {
    try {
      emit(TireExpenseLoading());
      final tireexpense = await repository.getAllTireExpense();
      emit(TireExpenseLoaded(tireexpense));
    } catch (e) {
      emit(TireExpenseError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTireExpense(TireExpense tireexpense) async {
    try {
      await repository.addTireExpense(tireexpense);
      emit(AddedTireExpenseState(tireexpenseconstants.createdtoast));
    } catch (e) {
      emit(TireExpenseError(e.toString()));
    }
    fetchTireExpense();
  }

  void updateTireExpense(TireExpense tireexpense) async {
    try {
      print(tireexpense.toJson());
      await repository.updateTireExpense(tireexpense);
      emit(UpdatedTireExpenseState(tireexpenseconstants.updatedtoast));
    } catch (e) {
      emit(TireExpenseError(e.toString()));
    }
    fetchTireExpense();
  }

  void deleteTireExpense(TireExpense tireexpense, int id) async {
    try {
      await repository.deleteTireExpense(id);
      emit(DeletedTireExpenseState(tireexpenseconstants.deletedtoast));
    } catch (e) {
      emit(TireExpenseError(e.toString()));
    }
    fetchTireExpense();
  }
}
