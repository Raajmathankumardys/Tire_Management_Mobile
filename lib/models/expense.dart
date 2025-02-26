import 'package:flutter/material.dart';

enum ExpenseCategory { FUEL,
  DRIVER_ALLOWANCE,
  TOLL,
  MAINTENANCE,
  MISCELLANEOUS }

class ExpenseModel {
  final int? expenseId;
  final int tripId;
  final ExpenseCategory category;
  final double amount;
  final DateTime expenseDate;
  final String description;
  final String? attachmentUrl;
  final DateTime createdAt;


  final DateTime updatedAt;

  ExpenseModel({
    this.expenseId,
    required this.tripId,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.description,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ExpenseModel.fromJson(Map<String, dynamic> json) {
    return ExpenseModel(
      expenseId: json['expenseId'],
      tripId: json['tripId'],
      category: ExpenseCategory.values.firstWhere(
            (e) => e.toString().split('.').last == json['category'],
        orElse: () => ExpenseCategory.MISCELLANEOUS,
      ),
      amount: (json['amount'] as num).toDouble(),
      expenseDate: DateTime.parse(json['expenseDate']),
      description: json['description'],
      attachmentUrl: json['attachmentUrl'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'category': category.toString().split('.').last,
      'amount': amount,
      'expenseDate': expenseDate.toIso8601String(),
      'description': description,
      'attachmentUrl': attachmentUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
