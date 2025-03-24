import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/models/vehicle.dart';
import 'package:yaantrac_app/vehicles/repository/vehicle_repository.dart';
import 'vehicle_state.dart';

class BaseCubit<T> extends Cubit<BaseState<T>> {
  final BaseRepository<T> repository;

  BaseCubit(this.repository) : super(InitialState());

  void fetchItems() async {
    emit(LoadingState<T>());
    try {
      final items = await repository.getAll();
      emit(LoadedState<T>(items));
    } catch (e) {
      emit(ErrorState<T>("Failed to load items"));
    }
  }

  void addItem(T item) async {
    emit(LoadingState<T>());
    try {
      await repository.add(item);
      emit(AddedState("Item added successfully"));
      fetchItems();
    } catch (e) {
      emit(ErrorState<T>("Failed to add item"));
    }
  }

  void updateItem(T item, int id) async {
    emit(LoadingState<T>());
    try {
      await repository.update(item, id);
      emit(UpdatedState("Item updated successfully"));
      fetchItems();
    } catch (e) {
      emit(ErrorState<T>("Failed to update item"));
    }
  }

  void deleteItem(int id) async {
    emit(LoadingState<T>());
    try {
      await repository.delete(id);
      emit(DeletedState("Item deleted successfully"));
      fetchItems();
    } catch (e) {
      emit(ErrorState<T>("Failed to delete item"));
    }
  }
}
