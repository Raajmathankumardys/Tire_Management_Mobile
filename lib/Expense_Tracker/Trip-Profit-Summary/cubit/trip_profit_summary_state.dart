class TripProfitSummary {
  final double totalExpenses;
  final Map<String, double> expensesByCategory;
  final double totalIncome;
  final double profit;
  final double distance;
  final String vehicleNumber;
  final String driverName;

  TripProfitSummary(
      {required this.totalExpenses,
      required this.expensesByCategory,
      required this.totalIncome,
      required this.profit,
      required this.distance,
      required this.vehicleNumber,
      required this.driverName});

  factory TripProfitSummary.fromJson(Map<String, dynamic> json) {
    return TripProfitSummary(
      totalExpenses: (json['totalExpenses'] ?? 0).toDouble(),
      expensesByCategory: Map<String, double>.from(json['expensesByCategory']),
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      vehicleNumber: (json['vehicleNumber'] ?? "").toString(),
      driverName: (json['driverName'] ?? "").toString(),
    );
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
