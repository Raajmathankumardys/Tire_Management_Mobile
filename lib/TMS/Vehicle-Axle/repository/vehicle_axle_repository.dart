import '../cubit/vehicle_axle_state.dart';
import '../service/vehicle_axle_service.dart';

class VehicleAxleRepository {
  final VehicleAxleService service;

  VehicleAxleRepository(this.service);

  Future<List<VehicleAxle>> getAllVehicles(String id) =>
      service.fetchVehicles(id);
  Future<void> addVehicleMapping(List<VehicleMapping> vehiclemapping) =>
      service.addVehicleMapping(vehiclemapping);
  Future<void> deleteVehicleMapping(String id, String positionId) =>
      service.deleteVehicleMapping(id, positionId);
}
