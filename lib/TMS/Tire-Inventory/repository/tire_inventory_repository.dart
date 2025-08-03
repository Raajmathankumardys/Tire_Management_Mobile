import '../cubit/tire_inventory_state.dart';
import '../service/tire_inventory_service.dart';

class TireInventoryRepository {
  final TireInventoryService service;

  TireInventoryRepository(this.service);

  Future<TireInventoryPaginatedResponse> getAllTireInventoryPages(
          {int page = 0, int size = 10}) =>
      service.fetchTires(page: page, size: size);

  Future<TireInventoryPaginatedResponse> getAllTireInventoryLogsPages(
          {int page = 0, int size = 10}) =>
      service.fetchTiresLogs(page: page, size: size);

  Future<List<TireInventory>> getAllTireInventory() =>
      service.fetchTireInventory();

  Future<List<TireInventory>> getAllTireInventoryLogs() =>
      service.fetchTireInventoryLogs();

  Future<void> addTireInventory(TireInventory tireinventory) =>
      service.addTireInventory(tireinventory);

  Future<void> updateTireInventory(TireInventory tireinventory) =>
      service.updateTireInventory(tireinventory);

  Future<void> deleteTireInventory(String id) =>
      service.deleteTireInventory(id);
}
