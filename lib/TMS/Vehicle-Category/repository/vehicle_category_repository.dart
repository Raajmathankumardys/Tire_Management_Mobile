import '../cubit/vehicle_category_state.dart';
import '../service/vehicle_category_service.dart';

class VehicleCategoryRepository {
  final VehicleCategoryService vehicleCategoryService;
  VehicleCategoryRepository(this.vehicleCategoryService);

  Future<List<VehicleCategoryModel>> getAllVehicles() =>
      vehicleCategoryService.fetchVehicles();
}
