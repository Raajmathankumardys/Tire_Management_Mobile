import 'package:yaantrac_app/screens/tiremapping.dart';

class Tireexpense {
  final int? id;
  final int? maintenanceId;
  final double cost;
  final int tireId;
  final String expenseType;
  final DateTime expenseDate;
  final String notes;
  Tireexpense(
      {this.id,
      this.maintenanceId,
      required this.cost,
      required this.tireId,
      required this.expenseType,
      required this.expenseDate,
      required this.notes});
  factory Tireexpense.fromJson(Map<String, dynamic> json) {
    return Tireexpense(
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
