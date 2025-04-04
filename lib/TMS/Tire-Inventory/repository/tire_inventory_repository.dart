import '../cubit/tire_inventory_state.dart';
import '../service/tire_inventory_service.dart';

class TireInventoryRepository {
  final TireInventoryService service;

  TireInventoryRepository(this.service);

  Future<List<TireInventory>> getAllTireInventory() =>
      service.fetchTireInventory();

  Future<void> addTireInventory(TireInventory tireinventory) =>
      service.addTireInventory(tireinventory);

  Future<void> updateTireInventory(TireInventory tireinventory) =>
      service.updateTireInventory(tireinventory);

  Future<void> deleteTireInventory(int id) => service.deleteTireInventory(id);
}
