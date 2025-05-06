import 'package:yaantrac_app/Expense_Tracker/Expense/cubit/expense_state.dart';

class TripProfitSummary {
  final int tripId;
  final double totalIncome;
  final double totalExpenses;
  final double profit;
  final Map<ExpenseCategory, dynamic> breakDown;

  TripProfitSummary({
    required this.tripId,
    required this.totalIncome,
    required this.totalExpenses,
    required this.profit,
    required this.breakDown,
  });

  factory TripProfitSummary.fromJson(Map<String, dynamic> json) {
    // Check the 'breakDown' data type
    var breakDown = json['breakDown'];

    print("BreakDown type: ${breakDown.runtimeType}");

    Map<ExpenseCategory, dynamic> breakDownMap = {};

    // Handle case when breakDown is a Map<String, dynamic>
    if (breakDown is Map<String, dynamic>) {
      breakDownMap = breakDown.map((key, value) {
        try {
          return MapEntry(ExpenseCategory.values.byName(key), value);
        } catch (_) {
          throw Exception('Invalid ExpenseCategory key: $key');
        }
      });
    }
    // Handle case when breakDown is an int or double (single numeric value)
    else if (breakDown is num) {
      breakDownMap = {
        ExpenseCategory.MISCELLANEOUS:
            breakDown, // Default to MISCELLANEOUS category
      };
    }
    // Throw error if breakDown is not a Map or numeric value
    else {
      throw Exception(
          'breakDown must be a Map<String, dynamic> or a numeric value');
    }

    return TripProfitSummary(
      tripId: json['tripId'],
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      breakDown: breakDownMap,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'profit': profit,
      'breakDown': breakDown.map((key, value) => MapEntry(key.name, value)),
    };
  }

  @override
  String toString() {
    return 'TripProfitSummaryModel(tripId: $tripId, totalIncome: $totalIncome, totalExpenses: $totalExpenses, profit: $profit,breakdown:$breakDown)';
  }
}

abstract class TripProfitSummaryState {}

class TripProfitSummaryInitial extends TripProfitSummaryState {}

class TripProfitSummaryLoading extends TripProfitSummaryState {}

class TripProfitSummaryLoaded extends TripProfitSummaryState {
  final TripProfitSummary tripprofitsummary;
  TripProfitSummaryLoaded(this.tripprofitsummary);
}

class TripProfitSummaryError extends TripProfitSummaryState {
  final String message;
  TripProfitSummaryError(this.message);
}
