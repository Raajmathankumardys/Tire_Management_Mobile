import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/vehicle.dart';
import '../repository/vehicle_repository.dart';
import 'vehicle_state.dart';

class VehiclesCubit extends Cubit<VehiclesState> {
  final VehiclesRepository repository;

  VehiclesCubit(this.repository) : super(VehiclesInitial());

  void fetchVehicles() async {
    emit(VehiclesLoading());
    try {
      final vehicles = await repository.getVehicles();
      emit(VehiclesLoaded(vehicles));
    } catch (e) {
      emit(VehiclesError("Failed to load vehicles"));
    }
  }

  void addVehicle(Vehicle vehicle) async {
    emit(VehiclesLoading());
    try {
      await repository.addVehicle(vehicle);
      emit(VehicleAdded("Vehicle added successfully")); // ✅ Correct event
      fetchVehicles();
    } catch (e) {
      emit(VehiclesError("Failed to add vehicle"));
    }
  }

  void updateVehicle(Vehicle vehicle) async {
    emit(VehiclesLoading());
    try {
      await repository.updateVehicle(vehicle);
      emit(VehicleUpdated("Vehicle updated successfully")); // ✅ Correct event
      fetchVehicles();
    } catch (e) {
      emit(VehiclesError("Failed to update vehicle"));
    }
  }

  void deleteVehicle(int id) async {
    emit(VehiclesLoading());
    try {
      await repository.deleteVehicle(id);
      emit(VehicleDeleted("Vehicle deleted successfully")); // ✅ Correct event
      fetchVehicles();
    } catch (e) {
      emit(VehiclesError("Failed to delete vehicle"));
    }
  }
}
