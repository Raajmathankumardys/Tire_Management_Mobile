import '../../Maintenance-Schedule/cubit/maintenance_schedule_state.dart';

class MaintenanceLog {
  final String? id;
  final String vehicleId;
  final String? tireId;
  final maintenancetype type;
  final String date;
  final String description;
  final double cost;
  final String performedBy;
  final String? notes;
  final bool completed;

  MaintenanceLog({
    required this.id,
    required this.vehicleId,
    required this.tireId,
    required this.type,
    required this.date,
    required this.description,
    required this.cost,
    required this.performedBy,
    required this.notes,
    required this.completed,
  });

  factory MaintenanceLog.fromJson(Map<String, dynamic> json) {
    return MaintenanceLog(
      id: json['id'],
      vehicleId: json['vehicleId'],
      tireId: json['tireId'],
      type: maintenancetype.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => maintenancetype.CONDITION_BASED,
      ),
      date: json['date'],
      description: json['description'],
      cost: (json['cost']).toDouble(),
      performedBy: json['performedBy'],
      notes: json['notes'],
      completed: json['completed'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'tireId': tireId,
      'type': type.toString().split('.').last,
      'date': date,
      'description': description,
      'cost': cost,
      'performedBy': performedBy,
      'notes': notes,
      'completed': completed,
    };
  }
}

abstract class MaintenanceLogState {}

class MaintenanceLogInitial extends MaintenanceLogState {}

class MaintenanceLogLoading extends MaintenanceLogState {}

class MaintenanceLogLoaded extends MaintenanceLogState {
  final List<MaintenanceLog> maintenancelog;
  MaintenanceLogLoaded(this.maintenancelog);
}

class AddedMaintenanceLogState extends MaintenanceLogState {
  final String message;
  AddedMaintenanceLogState(this.message);
}

class UpdatedMaintenanceLogState extends MaintenanceLogState {
  final String message;
  UpdatedMaintenanceLogState(this.message);
}

class DeletedMaintenanceLogState extends MaintenanceLogState {
  final String message;
  DeletedMaintenanceLogState(this.message);
}

class MaintenanceLogError extends MaintenanceLogState {
  final String message;
  MaintenanceLogError(this.message);
}
