import '../cubit/vehicle_axle_state.dart';
import '../service/vehicle_axle_cubit.dart';

class VehicleAxleRepository {
  final VehicleAxleService service;

  VehicleAxleRepository(this.service);

  Future<List<VehicleAxle>> getAllVehicles(int id) => service.fetchVehicles(id);
}
