import 'package:intl/intl.dart';

class Income {
  final String? id;
  final String tripId;
  final double amount;
  final String incomeSource;
  final DateTime incomeDate;
  final String description;

  Income({
    this.id,
    required this.tripId,
    required this.amount,
    required this.incomeSource,
    required this.incomeDate,
    required this.description,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
      tripId: json['tripId'],
      amount: (json['amount'] as num).toDouble(),
      incomeDate: DateFormat('yyyy-MM-dd').parse(json['incomeDate']),
      description: json['description'],
      incomeSource: json['incomeSource'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'amount': amount,
      'incomeDate': DateFormat('yyyy-MM-dd').format(incomeDate),
      'description': description,
      'incomeSource': incomeSource,
    };
  }
}

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<Income> income;
  IncomeLoaded(this.income);
}

class AddedIncomeState extends IncomeState {
  final String message;
  AddedIncomeState(this.message);
}

class UpdatedIncomeState extends IncomeState {
  final String message;
  UpdatedIncomeState(this.message);
}

class DeletedIncomeState extends IncomeState {
  final String message;
  DeletedIncomeState(this.message);
}

class IncomeError extends IncomeState {
  final String message;
  IncomeError(this.message);
}
