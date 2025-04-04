class TireExpense {
  final int? id;
  final int? maintenanceId;
  final double cost;
  final int tireId;
  final String expenseType;
  final DateTime expenseDate;
  final String notes;
  TireExpense(
      {this.id,
      this.maintenanceId,
      required this.cost,
      required this.tireId,
      required this.expenseType,
      required this.expenseDate,
      required this.notes});
  factory TireExpense.fromJson(Map<String, dynamic> json) {
    return TireExpense(
        id: json['id'],
        maintenanceId: json['maintenanceId'],
        cost: json['cost'],
        tireId: json['tireId'],
        expenseType: json['expenseType'],
        expenseDate: DateTime.parse(json['expenseDate']),
        notes: json['notes']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'maintenanceId': maintenanceId,
      'cost': cost,
      'tireId': tireId,
      'expenseType': expenseType,
      'expenseDate': expenseDate,
      'notes': notes
    };
  }
}

abstract class TireExpenseState {}

class TireExpenseInitial extends TireExpenseState {}

class TireExpenseLoading extends TireExpenseState {}

class TireExpenseLoaded extends TireExpenseState {
  final List<TireExpense> tireexpense;
  TireExpenseLoaded(this.tireexpense);
}

class AddedTireExpenseState extends TireExpenseState {
  final String message;
  AddedTireExpenseState(this.message);
}

class UpdatedTireExpenseState extends TireExpenseState {
  final String message;
  UpdatedTireExpenseState(this.message);
}

class DeletedTireExpenseState extends TireExpenseState {
  final String message;
  DeletedTireExpenseState(this.message);
}

class TireExpenseError extends TireExpenseState {
  final String message;
  TireExpenseError(this.message);
}
