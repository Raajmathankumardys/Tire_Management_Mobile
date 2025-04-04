import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/tire_performance_repository.dart';
import 'tire_performance_state.dart';

class TirePerformanceCubit extends Cubit<TirePerformanceState> {
  final TirePerformanceRepository repository;
  TirePerformanceCubit(this.repository) : super(TirePerformanceInitial());

  void fetchTirePerformance(int id) async {
    try {
      emit(TirePerformanceLoading());
      final tireperformance = await repository.getAllTirePerformance(id);
      emit(TirePerformanceLoaded(tireperformance));
    } catch (e) {
      emit(TirePerformanceError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTirePerformance(TirePerformance tireperformance) async {
    try {
      await repository.addTirePerformance(tireperformance);
      emit(AddedTirePerformanceState("Item added successfully"));
    } catch (e) {
      emit(TirePerformanceError(e.toString()));
    }
    fetchTirePerformance(tireperformance.tireId!.toInt());
  }
}
