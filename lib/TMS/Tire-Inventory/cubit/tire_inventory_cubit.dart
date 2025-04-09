import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

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
      print(tireinventory.toJson());
      await repository.addTireInventory(tireinventory);
      emit(AddedTireInventoryState(
          tireinventoryconstants.createdtoast(tireinventory.serialNo)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }

  void updateTireInventory(TireInventory tireinventory) async {
    try {
      await repository.updateTireInventory(tireinventory);
      emit(UpdatedTireInventoryState(
          tireinventoryconstants.updatedtoast(tireinventory.serialNo)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }

  void deleteTireInventory(TireInventory tireinventory, int id) async {
    try {
      await repository.deleteTireInventory(id);
      emit(DeletedTireInventoryState(
          tireinventoryconstants.deletedtoast(tireinventory.serialNo)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTireInventory();
  }
}
