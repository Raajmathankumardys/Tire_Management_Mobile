enum ExpenseCategory {
  FUEL,
  DRIVER_ALLOWANCE,
  TOLL,
  MAINTENANCE,
  MISCELLANEOUS,
}

enum MaintenanceType {
  PREVENTIVE,
  CORRECTIVE,
  PREDICTIVE,
  CONDITION_BASED,
}

enum VehicleOrTire {
  VEHICLE,
  TIRE,
}

enum VehicleMaintenanceType {
  MAJOR_SERVICE,
  MINOR_SERVICE,
  EMERGENCY_REPAIR,
  OIL_CHANGE,
  BATTERY_MAINTENANCE,
  BATTERY_REPLACEMENT,
  BRAKE_REPAIR,
  ELECTRICAL_REPAIR,
  COOLING_SYSTEM_REPAIR,
  RADIATOR_REPAIR,
  AIR_FILTER_REPAIR,
  WIPER_REPAIR,
  AC_REPAIR,
  ENGINE_REPAIR,
  CLUTCH_REPAIR,
  SUSPENSION_FIX,
  EXHAUST_FIX,
  GENERAL_CHECKUP,
  OTHER,
}

enum TireMaintenanceType {
  REPAIR,
  REPLACEMENT,
  RETREADING,
  ALIGNMENT,
  BALANCING,
  ROTATION,
  INSPECTION,
  OTHER,
}

class Expense {
  final String? id;
  final String tripId;
  final ExpenseCategory category;
  final double amount;
  final String expenseDate;
  final String? description;
  final List<String>? attachmentUrls;

  // FUEL Specific
  final String? fuelType;
  final double? litersFilled;
  final double? pricePerLiter;
  final String? fuelStationName;

  // DRIVER_ALLOWANCE Specific
  final String? allowanceType;

  // TOLL Specific
  final String? tollPlazaName;

  // MISCELLANEOUS Specific
  final String? remarks;

  // MAINTENANCE Specific
  final MaintenanceType? maintenanceType;
  final String? serviceCenter;
  final String? repairVendor;
  final String? repairWarranty;
  final VehicleOrTire? vehicleOrTire;

  // Vehicle Maintenance Specific
  final VehicleMaintenanceType? vehicleMaintenanceType;
  final String? vehicleRemarks;
  final int? odometerReading;

  // Tire Maintenance Specific
  final String? tireId;
  final TireMaintenanceType? tireMaintenanceType;
  final String? tireRemarks;
  final String? replacedWithTireId;

  Expense({
    this.id,
    required this.tripId,
    required this.category,
    required this.amount,
    required this.expenseDate,
    this.description,
    this.attachmentUrls,
    this.fuelType,
    this.litersFilled,
    this.pricePerLiter,
    this.fuelStationName,
    this.allowanceType,
    this.tollPlazaName,
    this.remarks,
    this.maintenanceType,
    this.serviceCenter,
    this.repairVendor,
    this.repairWarranty,
    this.vehicleOrTire,
    this.vehicleMaintenanceType,
    this.vehicleRemarks,
    this.odometerReading,
    this.tireId,
    this.tireMaintenanceType,
    this.tireRemarks,
    this.replacedWithTireId,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['id'],
      tripId: json['tripId'],
      category: ExpenseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ExpenseCategory.MISCELLANEOUS,
      ),
      amount: (json['amount'] as num).toDouble(),
      expenseDate: json['expenseDate'],
      description: json['description'],
      attachmentUrls:
          (json['attachmentUrls'] as List?)?.map((e) => e.toString()).toList(),
      fuelType: json['fuelType'],
      litersFilled: (json['litersFilled'] as num?)?.toDouble(),
      pricePerLiter: (json['pricePerLiter'] as num?)?.toDouble(),
      fuelStationName: json['fuelStationName'],
      allowanceType: json['allowanceType'],
      tollPlazaName: json['tollPlazaName'],
      remarks: json['remarks'],
      maintenanceType: json['maintenanceType'] != null
          ? MaintenanceType.values.firstWhere(
              (e) => e.name == json['maintenanceType'],
              orElse: () => MaintenanceType.CORRECTIVE,
            )
          : null,
      serviceCenter: json['serviceCenter'],
      repairVendor: json['repairVendor'],
      repairWarranty: json['repairWarranty'],
      vehicleOrTire: json['vehicleOrTire'] != null
          ? VehicleOrTire.values.firstWhere(
              (e) => e.name == json['vehicleOrTire'],
              orElse: () => VehicleOrTire.VEHICLE,
            )
          : null,
      vehicleMaintenanceType: json['vehicleMaintenanceType'] != null
          ? VehicleMaintenanceType.values.firstWhere(
              (e) => e.name == json['vehicleMaintenanceType'],
              orElse: () => VehicleMaintenanceType.OTHER,
            )
          : null,
      vehicleRemarks: json['vehicleRemarks'],
      odometerReading: json['odometerReading'],
      tireId: json['tireId'],
      tireMaintenanceType: json['tireMaintenanceType'] != null
          ? TireMaintenanceType.values.firstWhere(
              (e) => e.name == json['tireMaintenanceType'],
              orElse: () => TireMaintenanceType.OTHER,
            )
          : null,
      tireRemarks: json['tireRemarks'],
      replacedWithTireId: json['replacedWithTireId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tripId': tripId,
      'category': category.name,
      'amount': amount,
      'expenseDate': expenseDate,
      'description': description,
      'attachmentUrls': attachmentUrls,
      'fuelType': fuelType,
      'litersFilled': litersFilled,
      'pricePerLiter': pricePerLiter,
      'fuelStationName': fuelStationName,
      'allowanceType': allowanceType,
      'tollPlazaName': tollPlazaName,
      'remarks': remarks,
      'maintenanceType': maintenanceType?.name,
      'serviceCenter': serviceCenter,
      'repairVendor': repairVendor,
      'repairWarranty': repairWarranty,
      'vehicleOrTire': vehicleOrTire?.name,
      'vehicleMaintenanceType': vehicleMaintenanceType?.name,
      'vehicleRemarks': vehicleRemarks,
      'odometerReading': odometerReading,
      'tireId': tireId,
      'tireMaintenanceType': tireMaintenanceType?.name,
      'tireRemarks': tireRemarks,
      'replacedWithTireId': replacedWithTireId,
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
