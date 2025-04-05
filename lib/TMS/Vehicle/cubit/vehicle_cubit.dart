import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/TMS/presentation/constants.dart';
import 'vehicle_state.dart';
import '../repository/vehicle_repository.dart';

class VehicleCubit extends Cubit<VehicleState> {
  final VehicleRepository repository;
  VehicleCubit(this.repository) : super(VehicleInitial());

  void fetchVehicles() async {
    try {
      emit(VehicleLoading());
      final vehicles = await repository.getAllVehicles();
      emit(VehicleLoaded(vehicles));
    } catch (e) {
      emit(VehicleError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addVehicle(Vehicle vehicle) async {
    try {
      await repository.addVehicle(vehicle);
      emit(AddedVehicleState(
          vehicleconstants.vehicleUpdated(vehicle.name, vehicle.type)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void updateVehicle(Vehicle vehicle) async {
    try {
      await repository.updateVehicle(vehicle);
      emit(UpdatedVehicleState(
          vehicleconstants.vehicleUpdated(vehicle.name, vehicle.type)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void deleteVehicle(Vehicle vehicle, int id) async {
    try {
      await repository.deleteVehicle(id);
      emit(DeletedVehicleState(
          vehicleconstants.vehicleDeleted(vehicle.name, vehicle.type)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }
}
