import '../cubit/driver_state.dart';
import '../service/driver_service.dart';

class DriverRepository {
  final DriverService service;

  DriverRepository(this.service);

  // Future<List<Driver>> getAllDrivers() => service.fetchDriver();

  Future<DriverPaginatedResponse> getAllDrivers(
          {int page = 0, int size = 10}) =>
      service.fetchDriver(page: page, size: size);

  Future<void> addDriver(Driver driver) => service.addDriver(driver);

  Future<void> updateDriver(Driver driver, String id) =>
      service.updateDriver(driver, id);

  Future<void> deleteDriver(String id) => service.deleteDriver(id);
}
