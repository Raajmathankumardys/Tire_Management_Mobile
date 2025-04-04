import '../cubit/tire_performance_state.dart';
import '../service/tire_performance_service.dart';

class TirePerformanceRepository {
  final TirePerformanceService service;

  TirePerformanceRepository(this.service);

  Future<List<TirePerformance>> getAllTirePerformance(int id) =>
      service.fetchTirePerformance(id);

  Future<void> addTirePerformance(TirePerformance tireperformance) =>
      service.addTirePerformance(tireperformance);
}
