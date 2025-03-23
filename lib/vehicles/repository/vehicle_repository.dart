import '../../models/vehicle.dart';
import '../service/vehicleService.dart';

class VehiclesRepository {
  final VehiclesService service;

  VehiclesRepository(this.service);

  Future<List<Vehicle>> getVehicles() => service.fetchVehicles();

  Future<void> addVehicle(Vehicle vehicle) => service.createVehicle(vehicle);

  Future<void> updateVehicle(Vehicle vehicle) => service.updateVehicle(vehicle);

  Future<void> deleteVehicle(int id) => service.removeVehicle(id);
}
