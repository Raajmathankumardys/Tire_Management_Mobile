class Income {
  final int? id;
  final int tripId;
  final double amount;
  final DateTime incomeDate;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;

  Income({
    this.id,
    required this.tripId,
    required this.amount,
    required this.incomeDate,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Income.fromJson(Map<String, dynamic> json) {
    return Income(
      id: json['id'],
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
      'id': id,
      'tripId': tripId,
      'amount': amount,
      'incomeDate': incomeDate.toIso8601String(),
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
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
