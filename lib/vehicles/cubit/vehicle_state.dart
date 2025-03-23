import '../../models/vehicle.dart';

abstract class VehiclesState {}

class VehiclesInitial extends VehiclesState {}

class VehiclesLoading extends VehiclesState {}

class VehiclesLoaded extends VehiclesState {
  final List<Vehicle> vehicles;
  VehiclesLoaded(this.vehicles);
}

class VehicleAdded extends VehiclesState {
  final String message;
  VehicleAdded(this.message);
}

class VehicleUpdated extends VehiclesState {
  final String message;
  VehicleUpdated(this.message);
}

class VehicleDeleted extends VehiclesState {
  final String message;
  VehicleDeleted(this.message);
}

class VehiclesError extends VehiclesState {
  final String message;
  VehiclesError(this.message);
}
