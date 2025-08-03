import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../helpers/constants.dart';
import '../repository/driver_repository.dart';
import 'driver_state.dart';

class DriverCubit extends Cubit<DriverState> {
  final DriverRepository repository;
  int _currentPage = 0;
  bool _isFetching = false;
  bool _hasNext = true;
  List<Driver> _allDrivers = [];
  DriverCubit(this.repository) : super(DriverInitial());

  // void fetchDriver() async {
  //   try {
  //     emit(DriverLoading());
  //     final driver = await repository.getAllDrivers();
  //     emit(DriverLoaded(driver));
  //   } catch (e) {
  //     emit(DriverError(e.toString()));
  //     throw Exception(e.toString());
  //   }
  // }

  void fetchDriver({bool isRefresh = false}) async {
    if (_isFetching || (!_hasNext && !isRefresh)) return;

    _isFetching = true;
    if (isRefresh) {
      _currentPage = 0;
      _hasNext = true;
      _allDrivers.clear();
    }

    if (_currentPage == 0) emit(DriverLoading());

    try {
      final response =
          await repository.getAllDrivers(page: _currentPage, size: 10);
      if (response.hasNext == false) _hasNext = false;

      _allDrivers.addAll(response.content);
      emit(DriverLoaded(List.from(_allDrivers), response.hasNext));
      _currentPage++;
    } catch (e) {
      emit(DriverError(e.toString()));
    }

    _isFetching = false;
  }

  // Keep other add/update/delete logic the same,
  // but call fetchDriver(isRefresh: true) after them to reset pagination.

  void addDriver(Driver driver) async {
    try {
      await repository.addDriver(driver);
      emit(AddedDriverState("Added"));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
    fetchDriver(isRefresh: true);
  }

  void updateDriver(Driver driver, String id) async {
    try {
      await repository.updateDriver(driver, id);
      emit(UpdatedDriverState("Updated"));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
    fetchDriver(isRefresh: true);
  }

  void deleteDriver(Driver driver, String id) async {
    try {
      await repository.deleteDriver(id);
      emit(DeletedDriverState("Deleted"));
    } catch (e) {
      emit(DriverError(e.toString()));
    }
    fetchDriver(isRefresh: true);
  }
}
