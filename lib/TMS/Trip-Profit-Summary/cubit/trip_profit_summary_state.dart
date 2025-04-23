class TripProfitSummary {
  final int tripId;
  final double totalIncome;
  final double totalExpenses;
  final double profit;
  final Map<String, dynamic> breakDown;

  TripProfitSummary({
    required this.tripId,
    required this.totalIncome,
    required this.totalExpenses,
    required this.profit,
    required this.breakDown,
  });

  factory TripProfitSummary.fromJson(Map<String, dynamic> json) {
    return TripProfitSummary(
      tripId: json['tripId'],
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalExpenses: (json['totalExpenses'] as num).toDouble(),
      profit: (json['profit'] as num).toDouble(),
      breakDown: json['breakDown'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'totalIncome': totalIncome,
      'totalExpenses': totalExpenses,
      'profit': profit,
      'breakDown': breakDown,
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
