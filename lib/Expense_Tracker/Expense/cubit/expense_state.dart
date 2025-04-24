enum ExpenseCategory {
  FUEL,
  DRIVER_ALLOWANCE,
  TOLL,
  MAINTENANCE,
  MISCELLANEOUS
}

class Expense {
  final int? id;
  final int tripId;
  final ExpenseCategory category;
  final double amount;
  final DateTime expenseDate;
  final String description;
  final String? attachmentUrl;
  final DateTime createdAt;

  final DateTime updatedAt;

  Expense({
    this.id,
    required this.tripId,
    required this.category,
    required this.amount,
    required this.expenseDate,
    required this.description,
    this.attachmentUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
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
      'id': id,
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

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<Expense> expense;
  ExpenseLoaded(this.expense);
}

class AddedExpenseState extends ExpenseState {
  final String message;
  AddedExpenseState(this.message);
}

class UpdatedExpenseState extends ExpenseState {
  final String message;
  UpdatedExpenseState(this.message);
}

class DeletedExpenseState extends ExpenseState {
  final String message;
  DeletedExpenseState(this.message);
}

class ExpenseError extends ExpenseState {
  final String message;
  ExpenseError(this.message);
}
