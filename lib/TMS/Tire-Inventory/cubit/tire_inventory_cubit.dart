import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/tire_inventory_repository.dart';
import 'tire_inventory_state.dart';

class TireInventoryCubit extends Cubit<TireInventoryState> {
  final TireInventoryRepository repository;
  TireInventoryCubit(this.repository) : super(TireInventoryInitial());

  void fetchTireInventory() async {
    try {
      emit(TireInventoryLoading());
      final tireinventory = await repository.getAllTireInventory();
      emit(TireInventoryLoaded(tireinventory));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTireInventory(TireInventory tireinventory) async {
    try {
      await repository.addTireInventory(tireinventory);
      emit(AddedState("Item added successfully"));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }

  void updateTireInventory(TireInventory tireinventory) async {
    try {
      await repository.updateTireInventory(tireinventory);
      emit(UpdatedState("Item updated successfully"));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }

  void deleteTireInventory(int id) async {
    try {
      await repository.deleteTireInventory(id);
      emit(DeletedState("Item deleted successfully"));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }
}
