import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/constants.dart';
import '../repository/tire_inventory_repository.dart';
import 'tire_inventory_state.dart';

class TireInventoryCubit extends Cubit<TireInventoryState> {
  final TireInventoryRepository repository;
  TireInventoryCubit(this.repository) : super(TireInventoryInitial());

  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasNext = true;
  List<TireInventory> _allTires = [];

  void fetchTires({bool isRefresh = false}) async {
    if (_isFetching || (!_hasNext && !isRefresh)) return;

    _isFetching = true;
    if (isRefresh) {
      _currentPage = 0;
      _hasNext = true;
      _allTires.clear();
    }

    if (_currentPage == 0) emit(TireInventoryLoading());

    try {
      final response = await repository.getAllTireInventoryPages(
          page: _currentPage, size: 10);
      if (response.hasNext == false) _hasNext = false;

      _allTires.addAll(response.content);
      emit(TireInventoryLoaded(List.from(_allTires), response.hasNext));
      _currentPage++;
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }

    _isFetching = false;
  }

  void fetchTiresLogs({bool isRefresh = false}) async {
    if (_isFetching || (!_hasNext && !isRefresh)) return;

    _isFetching = true;
    if (isRefresh) {
      _currentPage = 0;
      _hasNext = true;
      _allTires.clear();
    }

    if (_currentPage == 0) emit(TireInventoryLoading());

    try {
      final response = await repository.getAllTireInventoryLogsPages(
          page: _currentPage, size: 10);
      if (response.hasNext == false) _hasNext = false;

      _allTires.addAll(response.content);
      emit(TireInventoryLoaded(List.from(_allTires), response.hasNext));
      _currentPage++;
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }

    _isFetching = false;
  }

  void fetchTireInventory() async {
    try {
      emit(TireInventoryLoading());
      final tireinventory = await repository.getAllTireInventory();
      emit(TireInventoryLoaded(tireinventory, false));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void fetchTireInventoryLogs() async {
    try {
      emit(TireInventoryLoading());
      final tireinventory = await repository.getAllTireInventoryLogs();
      emit(TireInventoryLoaded(tireinventory, false));
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
          tireinventoryconstants.createdtoast(tireinventory.serialNumber)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTires(isRefresh: true);
  }

  void updateTireInventory(TireInventory tireinventory) async {
    try {
      await repository.updateTireInventory(tireinventory);
      emit(UpdatedTireInventoryState(
          tireinventoryconstants.updatedtoast(tireinventory.serialNumber)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTires(isRefresh: true);
  }

  void deleteTireInventory(TireInventory tireinventory, String id) async {
    try {
      await repository.deleteTireInventory(id);
      emit(DeletedTireInventoryState(
          tireinventoryconstants.deletedtoast(tireinventory.serialNumber)));
    } catch (e) {
      emit(TireInventoryError(e.toString()));
    }
    fetchTires(isRefresh: true);
  }
}
