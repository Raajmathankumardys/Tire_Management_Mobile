import 'dart:convert';

class IncomeModel {
  final int? incomeId;
  final int tripId;
  final double amount;
  final DateTime incomeDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  IncomeModel({
    this.incomeId,
    required this.tripId,
    required this.amount,
    required this.incomeDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IncomeModel.fromJson(Map<String, dynamic> json) {
    return IncomeModel(
      incomeId: json['incomeId'],
      tripId: json['tripId'],
      amount: (json['amount'] as num).toDouble(),
      incomeDate: DateTime.parse(json['incomeDate']),
      description: json['description'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'incomeId': incomeId,
      'tripId': tripId,
      'amount': amount,
      'incomeDate': incomeDate.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
