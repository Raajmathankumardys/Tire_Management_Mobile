import 'package:yaantrac_app/TMS/Tire-Inventory/cubit/tire_inventory_state.dart';

class VehicleAxle {
  final String? id;
  final String vehicleId;
  final String axleNumber;
  final int position;
  final int numberOfWheels;

  VehicleAxle(
      {this.id,
      required this.vehicleId,
      required this.axleNumber,
      required this.position,
      required this.numberOfWheels});

  factory VehicleAxle.fromJson(Map<String, dynamic> json) {
    return VehicleAxle(
        id: json['id'],
        vehicleId: json['vehicleId'],
        axleNumber: json['axleNumber'],
        position: json['position'],
        numberOfWheels: json['numberOfWheels']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'axleNumber': axleNumber,
      'position': position,
      'numberOfWheels': numberOfWheels
    };
  }
}

class VehicleMapping {
  final String vehicleId;
  final String tireId;
  final String positionId;
  VehicleMapping(
      {required this.vehicleId,
      required this.tireId,
      required this.positionId});
}

abstract class VehicleAxleState {}

class VehicleAxleInitial extends VehicleAxleState {}

class VehicleAxleLoading extends VehicleAxleState {}

class VehicleAxleLoaded extends VehicleAxleState {
  final List<VehicleAxle> vehicleaxle;
  VehicleAxleLoaded(this.vehicleaxle);
}

class AddedVehicleAxleState extends VehicleAxleState {
  final String message;
  AddedVehicleAxleState(this.message);
}

class UpdatedVehicleAxleState extends VehicleAxleState {
  final String message;
  UpdatedVehicleAxleState(this.message);
}

class DeletedVehicleAxleState extends VehicleAxleState {
  final String message;
  DeletedVehicleAxleState(this.message);
}

class VehicleAxleError extends VehicleAxleState {
  final String message;
  VehicleAxleError(this.message);
}
