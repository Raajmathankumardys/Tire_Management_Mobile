// cubit/report_state.dart
class ReportModel {
  final TripProfitability tripProfitability;
  final ExpenseBreakdown expenseBreakdown;
  final IncomeVsExpense incomeVsExpense;

  ReportModel({
    required this.tripProfitability,
    required this.expenseBreakdown,
    required this.incomeVsExpense,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) => ReportModel(
        tripProfitability:
            TripProfitability.fromJson(json['tripProfitability']),
        expenseBreakdown: ExpenseBreakdown.fromJson(json['expenseBreakdown']),
        incomeVsExpense: IncomeVsExpense.fromJson(json['incomeVsExpense']),
      );

  Map<String, dynamic> toJson() => {
        'tripProfitability': tripProfitability.toJson(),
        'expenseBreakdown': expenseBreakdown.toJson(),
        'incomeVsExpense': incomeVsExpense.toJson(),
      };
}

class TripProfitability {
  final List<TripData> tripData;
  final List<MonthlyData> monthlyData;
  final List<QuarterlyData> quarterlyData;

  TripProfitability({
    required this.tripData,
    required this.monthlyData,
    required this.quarterlyData,
  });

  factory TripProfitability.fromJson(Map<String, dynamic> json) =>
      TripProfitability(
        tripData: List<TripData>.from(
            json['tripData'].map((x) => TripData.fromJson(x))),
        monthlyData: List<MonthlyData>.from(
            json['monthlyData'].map((x) => MonthlyData.fromJson(x))),
        quarterlyData: List<QuarterlyData>.from(
            json['quarterlyData'].map((x) => QuarterlyData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'tripData': List<dynamic>.from(tripData.map((x) => x.toJson())),
        'monthlyData': List<dynamic>.from(monthlyData.map((x) => x.toJson())),
        'quarterlyData':
            List<dynamic>.from(quarterlyData.map((x) => x.toJson())),
      };
}

class TripData {
  final String id;
  final String name;
  final String startDate;
  final String endDate;
  final String vehicleNumber;
  final String driverName;
  final double income;
  final double expenses;
  final double profit;
  final String status;

  TripData({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.vehicleNumber,
    required this.driverName,
    required this.income,
    required this.expenses,
    required this.profit,
    required this.status,
  });

  factory TripData.fromJson(Map<String, dynamic> json) => TripData(
        id: json['id'],
        name: json['name'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        vehicleNumber: json['vehicleNumber'],
        driverName: json['driverName'],
        income: json['income'],
        expenses: json['expenses'],
        profit: json['profit'],
        status: json['status'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'startDate': startDate,
        'endDate': endDate,
        'vehicleNumber': vehicleNumber,
        'driverName': driverName,
        'income': income,
        'expenses': expenses,
        'profit': profit,
        'status': status,
      };
}

class MonthlyData {
  final String month;
  final double income;
  final double expenses;
  final double profit;

  MonthlyData({
    required this.month,
    required this.income,
    required this.expenses,
    required this.profit,
  });

  factory MonthlyData.fromJson(Map<String, dynamic> json) => MonthlyData(
        month: json['month'],
        income: json['income'],
        expenses: json['expenses'],
        profit: json['profit'],
      );

  Map<String, dynamic> toJson() => {
        'month': month,
        'income': income,
        'expenses': expenses,
        'profit': profit,
      };
}

class QuarterlyData {
  final String quarter;
  final double income;
  final double expenses;
  final double profit;

  QuarterlyData({
    required this.quarter,
    required this.income,
    required this.expenses,
    required this.profit,
  });

  factory QuarterlyData.fromJson(Map<String, dynamic> json) => QuarterlyData(
        quarter: json['quarter'],
        income: json['income'],
        expenses: json['expenses'],
        profit: json['profit'],
      );

  Map<String, dynamic> toJson() => {
        'quarter': quarter,
        'income': income,
        'expenses': expenses,
        'profit': profit,
      };
}

class ExpenseBreakdown {
  final List<CategoryBreakdown> categoryBreakdown;
  final List<TripExpenses> tripExpenses;

  ExpenseBreakdown({
    required this.categoryBreakdown,
    required this.tripExpenses,
  });

  factory ExpenseBreakdown.fromJson(Map<String, dynamic> json) =>
      ExpenseBreakdown(
        categoryBreakdown: List<CategoryBreakdown>.from(
            json['categoryBreakdown']
                .map((x) => CategoryBreakdown.fromJson(x))),
        tripExpenses: List<TripExpenses>.from(
            json['tripExpenses'].map((x) => TripExpenses.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'categoryBreakdown':
            List<dynamic>.from(categoryBreakdown.map((x) => x.toJson())),
        'tripExpenses': List<dynamic>.from(tripExpenses.map((x) => x.toJson())),
      };
}

class CategoryBreakdown {
  final String category;
  final double amount;
  final double percentage;

  CategoryBreakdown({
    required this.category,
    required this.amount,
    required this.percentage,
  });

  factory CategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      CategoryBreakdown(
        category: json['category'],
        amount: json['amount'],
        percentage: (json['percentage'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'category': category,
        'amount': amount,
        'percentage': percentage,
      };
}

class TripExpenses {
  final String tripId;
  final String tripName;
  final double totalExpenses;
  final Map<String, double> expensesByCategory;

  TripExpenses({
    required this.tripId,
    required this.tripName,
    required this.totalExpenses,
    required this.expensesByCategory,
  });

  factory TripExpenses.fromJson(Map<String, dynamic> json) => TripExpenses(
        tripId: json['tripId'],
        tripName: json['tripName'],
        totalExpenses: json['totalExpenses'],
        expensesByCategory:
            Map<String, double>.from(json['expensesByCategory']),
      );

  Map<String, dynamic> toJson() => {
        'tripId': tripId,
        'tripName': tripName,
        'totalExpenses': totalExpenses,
        'expensesByCategory': expensesByCategory,
      };
}

class IncomeVsExpense {
  final List<Comparison> comparisons;
  final Totals totals;

  IncomeVsExpense({
    required this.comparisons,
    required this.totals,
  });

  factory IncomeVsExpense.fromJson(Map<String, dynamic> json) =>
      IncomeVsExpense(
        comparisons: List<Comparison>.from(
            json['comparisons'].map((x) => Comparison.fromJson(x))),
        totals: Totals.fromJson(json['totals']),
      );

  Map<String, dynamic> toJson() => {
        'comparisons': List<dynamic>.from(comparisons.map((x) => x.toJson())),
        'totals': totals.toJson(),
      };
}

class Comparison {
  final String period;
  final double income;
  final double expenses;
  final double profit;

  Comparison({
    required this.period,
    required this.income,
    required this.expenses,
    required this.profit,
  });

  factory Comparison.fromJson(Map<String, dynamic> json) => Comparison(
        period: json['period'],
        income: json['income'],
        expenses: json['expenses'],
        profit: json['profit'],
      );

  Map<String, dynamic> toJson() => {
        'period': period,
        'income': income,
        'expenses': expenses,
        'profit': profit,
      };
}

class Totals {
  final double totalIncome;
  final double totalExpenses;
  final double totalProfit;
  final double profitPercentage;

  Totals({
    required this.totalIncome,
    required this.totalExpenses,
    required this.totalProfit,
    required this.profitPercentage,
  });

  factory Totals.fromJson(Map<String, dynamic> json) => Totals(
        totalIncome: json['totalIncome'],
        totalExpenses: json['totalExpenses'],
        totalProfit: json['totalProfit'],
        profitPercentage: (json['profitPercentage'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'totalIncome': totalIncome,
        'totalExpenses': totalExpenses,
        'totalProfit': totalProfit,
        'profitPercentage': profitPercentage,
      };
}

abstract class ReportState {}

class ReportInitial extends ReportState {}

class ReportLoading extends ReportState {}

class ReportLoaded extends ReportState {
  final ReportModel report;

  ReportLoaded(this.report);
}

class ReportError extends ReportState {
  final String message;

  ReportError(this.message);
}
