class VehicleAxle {
  final int id;
  final int vehicleId;
  final int axleNumber;
  final String axlePosition;

  VehicleAxle({
    required this.id,
    required this.vehicleId,
    required this.axleNumber,
    required this.axlePosition,
  });

  factory VehicleAxle.fromJson(Map<String, dynamic> json) {
    return VehicleAxle(
      id: json['id'],
      vehicleId: json['vehicleId'],
      axleNumber: json['axleNumber'],
      axlePosition: json['axlePosition'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'axleNumber': axleNumber,
      'axlePosition': axlePosition,
    };
  }
}

abstract class VehicleAxleState {}

class VehicleAxleInitial extends VehicleAxleState {}

class VehicleAxleLoading extends VehicleAxleState {}

class VehicleAxleLoaded extends VehicleAxleState {
  final List<VehicleAxle> vehicleaxle;
  VehicleAxleLoaded(this.vehicleaxle);
}

// class AddedVehicleAxleState extends VehicleAxleState {
//   final String message;
//   AddedVehicleAxleState(this.message);
// }
//
// class UpdatedVehicleAxleState extends VehicleAxleState {
//   final String message;
//   UpdatedVehicleAxleState(this.message);
// }
//
// class DeletedVehicleState extends VehicleAxleState {
//   final String message;
//   DeletedVehicleState(this.message);
// }

class VehicleAxleError extends VehicleAxleState {
  final String message;
  VehicleAxleError(this.message);
}
