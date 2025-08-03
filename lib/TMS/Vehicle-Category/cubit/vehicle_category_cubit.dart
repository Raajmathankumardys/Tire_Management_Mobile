import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/vehicle_category_repository.dart';
import 'vehicle_category_state.dart';

class VehicleCategoryCubit extends Cubit<VehicleCategoryState> {
  final VehicleCategoryRepository repository;

  VehicleCategoryCubit(this.repository) : super(VehicleCategoryInitial());

  Future<void> fetchVehicleCategories() async {
    emit(VehicleCategoryLoading());
    try {
      final categories = await repository.getAllVehicles();
      emit(VehicleCategoryLoaded(categories));
    } catch (e) {
      emit(VehicleCategoryError(e.toString()));
    }
  }
}
