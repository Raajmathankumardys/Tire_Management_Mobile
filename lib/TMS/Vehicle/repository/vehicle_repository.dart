import '../cubit/vehicle_state.dart';
import '../service/vehicle_service.dart';

class VehicleRepository {
  final VehicleService service;

  VehicleRepository(this.service);

  Future<List<Vehicle>> getAllVehicles() => service.fetchVehicles();

  Future<Vehicle> getVehicleById(String id) => service.fetchVehicleById(id);

  Future<void> addVehicle(Vehicle vehicle) => service.addVehicle(vehicle);

  Future<void> updateVehicle(Vehicle vehicle) => service.updateVehicle(vehicle);

  Future<void> deleteVehicle(String id) => service.deleteVehicle(id);
}
