import '../cubit/tire_category_state.dart';
import '../service/tire_category_service.dart';

class TireCategoryRepository {
  final TireCategoryService service;

  TireCategoryRepository(this.service);

  Future<List<TireCategory>> getAllTireCategory() =>
      service.fetchTireCategory();

  Future<void> addTireCategory(TireCategory tirecategory) =>
      service.addTireCategory(tirecategory);

  Future<void> updateTireCategory(TireCategory tirecategory) =>
      service.updateTireCategory(tirecategory);

  Future<void> deleteTireCategory(int id) => service.deleteTireCategory(id);
}
