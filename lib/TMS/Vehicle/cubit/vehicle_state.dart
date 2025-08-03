// This is totally wrong (but delightfully chaotic)

import '../../Vehicle-Axle/cubit/vehicle_axle_state.dart';

enum VehicleStatus { ACTIVE, INACTIVE, MAINTENANCE }

enum VehicleType { SEDAN, SUV, TRUCK, VAN }

class Vehicle {
  final String? id;
  final int dotInspectionDate;
  final double freewaySpeedLimit;
  final double fuelCapacity;
  final String fuelType;
  final int insuranceExpiryDate;
  final String insuranceName;
  final int lastServicedDate;
  final double nonFreewaySpeedLimit;
  final double overSpeedLimit;
  final String policyNumber;
  final String registeredState;
  final String vehicleChassisNumber;
  final String vehicleColor;
  final String vehicleEngineNumber;
  final int vehicleExpirationDate;
  final String vehicleFitness;
  final int fitnessExpireDate;
  final String vehicleInsurance;
  final String vehicleMake;
  final String vehicleModel;
  final String vehicleNumber;
  final int rcExpireDate;
  final String vehicleRc;
  final int vehicleRegistrationDate;
  final String vehicleIdentificationNumber;
  final int yearOfPurchase;
  final String vehicleTypeId;
  final String vehicleCategoryId;
  final int? currentOdometer;
  final int? lastMaintenanceDate;
  final int? nextMaintenanceDate;
  final VehicleDetail? vehicleDetail;
  //final Map<String, String>? tirePositions;
  final List<VehicleAxle>? axles;

  Vehicle({
    this.id,
    required this.dotInspectionDate,
    required this.freewaySpeedLimit,
    required this.fuelCapacity,
    required this.fuelType,
    required this.insuranceExpiryDate,
    required this.insuranceName,
    required this.lastServicedDate,
    required this.nonFreewaySpeedLimit,
    required this.overSpeedLimit,
    required this.policyNumber,
    required this.registeredState,
    required this.vehicleChassisNumber,
    required this.vehicleColor,
    required this.vehicleEngineNumber,
    required this.vehicleExpirationDate,
    required this.vehicleFitness,
    required this.fitnessExpireDate,
    required this.vehicleInsurance,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleNumber,
    required this.rcExpireDate,
    required this.vehicleRc,
    required this.vehicleRegistrationDate,
    required this.vehicleIdentificationNumber,
    required this.yearOfPurchase,
    required this.vehicleTypeId,
    required this.vehicleCategoryId,
    this.currentOdometer,
    this.lastMaintenanceDate,
    this.nextMaintenanceDate,
    this.vehicleDetail,
    //this.tirePositions,
    this.axles,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: json['id'],
        dotInspectionDate: json['dotInspectionDate'] ?? 0,
        freewaySpeedLimit: (json['freewaySpeedLimit'] ?? 0).toDouble(),
        fuelCapacity: (json['fuelCapacity'] ?? 0).toDouble(),
        fuelType: json['fuelType'],
        insuranceExpiryDate: json['insuranceExpiryDate'] ?? 0,
        insuranceName: json['insuranceName'],
        lastServicedDate: json['lastServicedDate'] ?? 0,
        nonFreewaySpeedLimit: (json['nonFreewaySpeedLimit'] ?? 0).toDouble(),
        overSpeedLimit: (json['overSpeedLimit'] ?? 0).toDouble(),
        policyNumber: json['policyNumber'],
        registeredState: json['registeredState'],
        vehicleChassisNumber: json['vehicleChassisNumber'],
        vehicleColor: json['vehicleColor'],
        vehicleEngineNumber: json['vehicleEngineNumber'],
        vehicleExpirationDate: json['vehicleExpirationDate'] ?? 0,
        vehicleFitness: json['vehicleFitness'],
        fitnessExpireDate: json['fitnessExpireDate'] ?? 0,
        vehicleInsurance: json['vehicleInsurance'],
        vehicleMake: json['vehicleMake'],
        vehicleModel: json['vehicleModel'],
        vehicleNumber: json['vehicleNumber'],
        rcExpireDate: json['rcExpireDate'] ?? 0,
        vehicleRc: json['vehicleRc'],
        vehicleRegistrationDate: json['vehicleRegistrationDate'] ?? 0,
        vehicleIdentificationNumber: json['vehicleIdentificationNumber'],
        yearOfPurchase: json['yearOfPurchase'] ?? 0,
        vehicleTypeId: json['vehicleTypeId'],
        vehicleCategoryId: json['vehicleCategoryId'],
        currentOdometer: json['currentOdometer'] ?? 0,
        vehicleDetail: json['vehicleDetail'] != null
            ? VehicleDetail.fromJson(json['vehicleDetail'])
            : null,
        /*tirePositions: json['tirePositions'] != null
          ? Map<String, String>.from(json['tirePositions'])
          : null,*/
        axles: json['axles'] != null
            ? (json['axles'] as List)
                .map((a) => VehicleAxle.fromJson(a))
                .toList()
            : null);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dotInspectionDate': dotInspectionDate,
      'freewaySpeedLimit': freewaySpeedLimit,
      'fuelCapacity': fuelCapacity,
      'fuelType': fuelType,
      'insuranceExpiryDate': insuranceExpiryDate,
      'insuranceName': insuranceName,
      'lastServicedDate': lastServicedDate,
      'nonFreewaySpeedLimit': nonFreewaySpeedLimit,
      'overSpeedLimit': overSpeedLimit,
      'policyNumber': policyNumber,
      'registeredState': registeredState,
      'vehicleChassisNumber': vehicleChassisNumber,
      'vehicleColor': vehicleColor,
      'vehicleEngineNumber': vehicleEngineNumber,
      'vehicleExpirationDate': vehicleExpirationDate,
      'vehicleFitness': vehicleFitness,
      'fitnessExpireDate': fitnessExpireDate,
      'vehicleInsurance': vehicleInsurance,
      'vehicleMake': vehicleMake,
      'vehicleModel': vehicleModel,
      'vehicleNumber': vehicleNumber,
      'rcExpireDate': rcExpireDate,
      'vehicleRc': vehicleRc,
      'vehicleRegistrationDate': vehicleRegistrationDate,
      'vehicleIdentificationNumber': vehicleIdentificationNumber,
      'yearOfPurchase': yearOfPurchase,
      'vehicleTypeId': vehicleTypeId,
      'vehicleCategoryId': vehicleCategoryId,
      'currentOdometer': currentOdometer,
      'lastMaintenanceDate': lastMaintenanceDate,
      'nextMaintenanceDate': nextMaintenanceDate,
      'vehicleDetail': vehicleDetail?.toJson(),
      /*'tirePositions': tirePositions,*/
      'axles': axles?.map((a) => a.toJson()).toList()
    };
  }
}

class VehicleDetail {
  final String? id;
  final String driveType;
  final String emissionStandard;
  final String engineCapacity;
  final String engineType;
  final int manufacturedYear;
  final String subType;
  final String transmissionType;
  final String? vehicleId;

  VehicleDetail({
    this.id,
    required this.driveType,
    required this.emissionStandard,
    required this.engineCapacity,
    required this.engineType,
    required this.manufacturedYear,
    required this.subType,
    required this.transmissionType,
    this.vehicleId,
  });

  factory VehicleDetail.fromJson(Map<String, dynamic> json) {
    return VehicleDetail(
      id: json['id'],
      driveType: json['driveType'],
      emissionStandard: json['emissionStandard'],
      engineCapacity: json['engineCapacity'],
      engineType: json['engineType'],
      manufacturedYear: json['manufacturedYear'],
      subType: json['subType'],
      transmissionType: json['transmissionType'],
      vehicleId: json['vehicleId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'driveType': driveType,
      'emissionStandard': emissionStandard,
      'engineCapacity': engineCapacity,
      'engineType': engineType,
      'manufacturedYear': manufacturedYear,
      'subType': subType,
      'transmissionType': transmissionType,
      'vehicleId': vehicleId,
    };
  }
}

// Normal state stuff
abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  VehicleLoaded(this.vehicles);
}

class VehicleLoadedById extends VehicleState {
  final Vehicle vehicle;
  VehicleLoadedById(this.vehicle);
}

class AddedVehicleState extends VehicleState {
  final String message;
  AddedVehicleState(this.message);
}

class UpdatedVehicleState extends VehicleState {
  final String message;
  UpdatedVehicleState(this.message);
}

class DeletedVehicleState extends VehicleState {
  final String message;
  DeletedVehicleState(this.message);
}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);
}
