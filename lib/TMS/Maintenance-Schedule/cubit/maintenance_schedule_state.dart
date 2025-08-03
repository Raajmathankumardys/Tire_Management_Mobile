enum maintenancetype {
  ROUTINE,
  PREVENTIVE,
  CORRECTIVE,
  PREDICTIVE,
  CONDITION_BASED
}

enum maintenancestatus { PENDING, IN_PROGRESS, COMPLETED, CANCELLED }

class MaintenanceSchedule {
  final String? id;
  final String vehicleId;
  final maintenancetype type; // e.g., "ROUTINE"
  final String scheduledDate;
  final String description;
  final String? notes;
  final maintenancestatus status; // e.g., "PENDING"
  final String createdAt;
  final String updatedAt;

  MaintenanceSchedule(
      {required this.id,
      required this.vehicleId,
      required this.type,
      required this.scheduledDate,
      required this.description,
      this.notes,
      required this.status,
      required this.createdAt,
      required this.updatedAt});

  factory MaintenanceSchedule.fromJson(Map<String, dynamic> json) {
    return MaintenanceSchedule(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      type: maintenancetype.values.firstWhere(
        (e) => e.toString().split('.').last == json['type'],
        orElse: () => maintenancetype.CONDITION_BASED,
      ),
      scheduledDate: json['scheduledDate'],
      description: json['description'] as String,
      createdAt: json['createdAt'],
      notes: json['notes'],
      status: maintenancestatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => maintenancestatus.PENDING,
      ),
      updatedAt: json['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'type': type.toString().split('.').last,
      'scheduledDate': scheduledDate,
      'description': description,
      'notes': notes,
      'status': status.toString().split('.').last,
      'updatedAt': updatedAt,
      'createdAt': createdAt
    };
  }
}

abstract class MaintenanceScheduleState {}

class MaintenanceScheduleInitial extends MaintenanceScheduleState {}

class MaintenanceScheduleLoading extends MaintenanceScheduleState {}

class MaintenanceScheduleLoaded extends MaintenanceScheduleState {
  final List<MaintenanceSchedule> maintenanceschedule;
  MaintenanceScheduleLoaded(this.maintenanceschedule);
}

class AddedMaintenanceScheduleState extends MaintenanceScheduleState {
  final String message;
  AddedMaintenanceScheduleState(this.message);
}

class UpdatedMaintenanceScheduleState extends MaintenanceScheduleState {
  final String message;
  UpdatedMaintenanceScheduleState(this.message);
}

class DeletedMaintenanceScheduleState extends MaintenanceScheduleState {
  final String message;
  DeletedMaintenanceScheduleState(this.message);
}

class MaintenanceScheduleError extends MaintenanceScheduleState {
  final String message;
  MaintenanceScheduleError(this.message);
}
