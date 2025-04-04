import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(AddedState("Item added successfully"));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void updateVehicle(Vehicle vehicle) async {
    try {
      await repository.updateVehicle(vehicle);
      emit(UpdatedState("Item updated successfully"));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }

  void deleteVehicle(int id) async {
    try {
      await repository.deleteVehicle(id);
      emit(DeletedState("Item deleted successfully"));
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
    fetchVehicles();
  }
}
