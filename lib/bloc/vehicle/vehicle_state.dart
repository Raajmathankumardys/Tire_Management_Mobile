import 'package:equatable/equatable.dart';
import '../../models/vehicle.dart';

abstract class VehicleState extends Equatable {
  @override
  List<Object?> get props => [];
}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<Vehicle> vehicles;
  VehicleLoaded(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

class VehicleError extends VehicleState {
  final String message;
  VehicleError(this.message);

  @override
  List<Object?> get props => [message];
}

class VehicleSuccess extends VehicleState {
  final String message;
  VehicleSuccess(this.message);

  @override
  List<Object?> get props => [message];
}
