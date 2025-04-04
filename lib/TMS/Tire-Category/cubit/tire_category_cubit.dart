import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/tire_category_repository.dart';
import 'tire_category_state.dart';

class TireCategoryCubit extends Cubit<TireCategoryState> {
  final TireCategoryRepository repository;
  TireCategoryCubit(this.repository) : super(TireCategoryInitial());

  void fetchTireCategory() async {
    try {
      emit(TireCategoryLoading());
      final tirecategory = await repository.getAllTireCategory();
      emit(TireCategoryLoaded(tirecategory));
    } catch (e) {
      emit(TireCategoryError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTireCategory(TireCategory tirecategory) async {
    try {
      await repository.addTireCategory(tirecategory);
      emit(AddedTireCategoryState("Item added successfully"));
    } catch (e) {
      emit(TireCategoryError(e.toString()));
    }
    fetchTireCategory();
  }

  void updateTireCategory(TireCategory tirecategory) async {
    try {
      await repository.updateTireCategory(tirecategory);
      emit(UpdatedTireCategoryState("Item updated successfully"));
    } catch (e) {
      emit(TireCategoryError(e.toString()));
    }
    fetchTireCategory();
  }

  void deleteTireCategory(int id) async {
    try {
      await repository.deleteTireCategory(id);
      emit(DeletedTireCategoryState("Item deleted successfully"));
    } catch (e) {
      emit(TireCategoryError(e.toString()));
    }
    fetchTireCategory();
  }
}
