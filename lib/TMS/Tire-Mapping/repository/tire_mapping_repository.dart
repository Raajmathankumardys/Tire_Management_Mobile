import '../cubit/tire_mapping_state.dart';
import '../service/tire_mapping_service.dart';

class TireMappingRepository {
  final TireMappingService service;

  TireMappingRepository(this.service);

  Future<List<GetTireMapping>> getAllTireMapping(int id) =>
      service.fetchTireMapping(id);

  Future<void> addTireMapping(List<AddTireMapping> tiremapping) =>
      service.addTireMapping(tiremapping);

  Future<void> updateTireMapping(List<AddTireMapping> tiremapping, int id) =>
      service.updateTireMapping(tiremapping, id);

  Future<void> deleteTireMapping(int id) => service.deleteTiremapping(id);
}
