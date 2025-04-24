class TripProfitSummaryModel {
  final int tripId;
  final double totalIncome;
  final double totalExpenses;
  final double profit;
  final Map<String, dynamic> breakDown;

  TripProfitSummaryModel({
    required this.tripId,
    required this.totalIncome,
    required this.totalExpenses,
    required this.profit,
    required this.breakDown,
  });

  factory TripProfitSummaryModel.fromJson(Map<String, dynamic> json) {
    return TripProfitSummaryModel(
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
