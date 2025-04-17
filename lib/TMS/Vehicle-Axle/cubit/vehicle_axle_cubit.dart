import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/vehicle_axle_repository.dart';
import 'vehicle_axle_state.dart';

class VehicleAxleCubit extends Cubit<VehicleAxleState> {
  final VehicleAxleRepository repository;
  VehicleAxleCubit(this.repository) : super(VehicleAxleInitial());

  void fetchVehicleAxles(int id) async {
    try {
      emit(VehicleAxleLoading());
      final vehicleaxle = await repository.getAllVehicles(id);
      emit(VehicleAxleLoaded(vehicleaxle));
    } catch (e) {
      emit(VehicleAxleError(e.toString()));
    }
  }
}
