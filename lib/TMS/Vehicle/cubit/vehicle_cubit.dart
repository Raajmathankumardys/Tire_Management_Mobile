import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/constants.dart';
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
      print(e);
      emit(VehicleError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void fetchVehicleById(String id) async {
    try {
      emit(VehicleLoading());
      final vehicle = await repository.getVehicleById(id);
      emit(VehicleLoadedById(vehicle));
    } catch (e) {
      emit(VehicleError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addVehicle(Vehicle vehicle) async {
    try {
      await repository.addVehicle(vehicle);
      emit(AddedVehicleState(vehicleconstants.vehicleUpdated(
          vehicle.vehicleMake, vehicle.vehicleModel)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void updateVehicle(Vehicle vehicle) async {
    try {
      await repository.updateVehicle(vehicle);
      emit(UpdatedVehicleState(vehicleconstants.vehicleUpdated(
          vehicle.vehicleMake, vehicle.vehicleModel)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void deleteVehicle(Vehicle vehicle, String id) async {
    try {
      await repository.deleteVehicle(id);
      emit(DeletedVehicleState(vehicleconstants.vehicleDeleted(
          vehicle.vehicleMake, vehicle.vehicleModel)));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }
}
