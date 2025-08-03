import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/vehicle_axle_repository.dart';
import 'vehicle_axle_state.dart';

class VehicleAxleCubit extends Cubit<VehicleAxleState> {
  final VehicleAxleRepository repository;
  VehicleAxleCubit(this.repository) : super(VehicleAxleInitial());

  void fetchVehicleAxles(String id) async {
    try {
      emit(VehicleAxleLoading());
      final vehicleaxle = await repository.getAllVehicles(id);
      emit(VehicleAxleLoaded(vehicleaxle));
    } catch (e) {
      emit(VehicleAxleError(e.toString()));
    }
  }

  void addVehicleAxle(List<VehicleMapping> vm, String vehicleId) async {
    try {
      await repository.addVehicleMapping(vm);
      emit(AddedVehicleAxleState("Added"));
    } catch (e) {
      emit(VehicleAxleError(e.toString()));
    }
    fetchVehicleAxles(vehicleId);
  }

  void deleteVehicleAxle(String vehicleId, String positionId) async {
    try {
      await repository.deleteVehicleMapping(vehicleId, positionId);
      emit(AddedVehicleAxleState("Deleted"));
    } catch (e) {
      emit(VehicleAxleError(e.toString()));
    }
    fetchVehicleAxles(vehicleId);
  }
}
