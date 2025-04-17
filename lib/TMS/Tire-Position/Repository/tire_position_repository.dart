import '../Cubit/tire_position_state.dart';
import '../Service/tire_position_service.dart';

class TirePositionRepository {
  final TirePositionService service;

  TirePositionRepository(this.service);

  Future<List<TirePosition>> getAllTirePosition() =>
      service.fetchTirePosition();
}
