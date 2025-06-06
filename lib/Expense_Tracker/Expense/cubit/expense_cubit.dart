import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../repository/expense_repository.dart';
import 'expense_state.dart';

class ExpenseCubit extends Cubit<ExpenseState> {
  final ExpenseRepository repository;
  ExpenseCubit(this.repository) : super(ExpenseInitial());

  void fetchExpense(int tripId) async {
    try {
      emit(ExpenseLoading());
      final expense = await repository.getAllExpense(tripId);
      emit(ExpenseLoaded(expense));
    } catch (e) {
      emit(ExpenseError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addExpense(Expense expense) async {
    try {
      await repository.addExpense(expense);
      emit(AddedExpenseState(expenseconstants.addedtoast));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
    fetchExpense(expense.tripId);
  }

  void updateExpense(Expense expense) async {
    try {
      await repository.updateExpense(expense);
      emit(UpdatedExpenseState(expenseconstants.updatedtoast));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
    fetchExpense(expense.tripId);
  }

  void deleteExpense(Expense expense, int id) async {
    try {
      await repository.deleteExpense(id);
      emit(DeletedExpenseState(expenseconstants.deletetoast));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
    fetchExpense(expense.tripId);
  }
}
