import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../repository/tire_mapping_repository.dart';
import 'tire_mapping_state.dart';

class TireMappingCubit extends Cubit<TireMappingState> {
  final TireMappingRepository repository;
  TireMappingCubit(this.repository) : super(TireMappingInitial());

  void fetchTireMapping(int id) async {
    try {
      emit(TireMappingLoading());
      final tiremapping = await repository.getAllTireMapping(id);
      emit(TireMappingLoaded(tiremapping));
    } catch (e) {
      emit(TireMappingError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTireMapping(List<AddTireMapping> tiremapping, int vehicleId) async {
    try {
      await repository.addTireMapping(tiremapping);
      emit(AddedTireMappingState(tiremappingconstants.addedToast));
    } catch (e) {
      emit(TireMappingError(e.toString()));
    }
    fetchTireMapping(vehicleId);
  }

  void updateTireMapping(
      List<AddTireMapping> tiremapping, int vehicleId) async {
    try {
      await repository.updateTireMapping(tiremapping, 0);
      emit(UpdateTireMappingState(tiremappingconstants.updatedToast));
    } catch (e) {
      emit(TireMappingError(e.toString()));
    }
    fetchTireMapping(vehicleId);
  }

  void deleteTireMapping(int vehicleId, int id) async {
    try {
      await repository.deleteTireMapping(id);
      emit(DeleteTireMappingState(tiremappingconstants.deletedToast));
    } catch (e) {
      emit(TireMappingError(e.toString()));
    }
    fetchTireMapping(vehicleId);
  }
}
