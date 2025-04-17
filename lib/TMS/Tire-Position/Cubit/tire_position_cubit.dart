import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/TMS/Tire-Position/Cubit/tire_position_state.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

import '../Repository/tire_position_repository.dart';

class TirePositionCubit extends Cubit<TirePositionState> {
  final TirePositionRepository repository;
  TirePositionCubit(this.repository) : super(TirePositionInitial());

  void fetchTirePosition() async {
    try {
      emit(TirePositionLoading());
      final tireposition = await repository.getAllTirePosition();
      emit(TirePositionLoaded(tireposition));
    } catch (e) {
      emit(TirePositionError(e.toString()));
      throw Exception(e.toString());
    }
  }
}
