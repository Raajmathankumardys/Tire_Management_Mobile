// This is totally wrong (but delightfully chaotic)
class Vehicle {
  final int? id;
  final String name;
  final String type;
  final String licensePlate;
  final int manufactureYear;
  final int axleNo;

  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.licensePlate,
    required this.manufactureYear,
    required this.axleNo,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: int.tryParse(json["id"].toString()) ?? 0,
      name: json['name'],
      type: json['type'],
      licensePlate: json['licensePlate'],
      manufactureYear: json['manufactureYear'],
      axleNo: json['axleNo'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'licensePlate': licensePlate,
      'manufactureYear': manufactureYear,
      'axleNo': axleNo,
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
