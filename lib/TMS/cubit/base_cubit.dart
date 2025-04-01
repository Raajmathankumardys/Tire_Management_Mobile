import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/TMS/repository/base_repository.dart';
import 'base_state.dart';

class BaseCubit<T> extends Cubit<BaseState<T>> {
  final BaseRepository<T> repository;

  BaseCubit(this.repository) : super(InitialState());

  void fetchItems({String? endpoint}) async {
    emit(LoadingState<T>());
    try {
      final items = await repository.getAll(endpoint: endpoint);
      emit(LoadedState<T>(items));
    } catch (e) {
      emit(ErrorState<T>("Failed to load items"));
    }
  }

  void fetchPerformance(String endpoint) async {
    emit(LoadingState<T>()); // Ensures UI resets to loading state
    try {
      final items = await repository.getPerformance(endpoint: endpoint);

      emit(LoadedState<T>(items));
    } catch (e) {
      emit(ErrorState<T>("Failed to load items"));
    }
  }

  void addPerformance(T item,
      {required String endpoint, required String fetchApi}) async {
    emit(LoadingState<T>());
    try {
      await repository.addPerformance(item, endpoint: endpoint);
      emit(AddedState("Item added successfully"));
    } catch (e) {
      emit(ApiErrorState<T>("Failed to add item"));
    }
    fetchPerformance(fetchApi);
  }

  void addItem(T item, {String? endpoint}) async {
    emit(LoadingState<T>());
    try {
      await repository.add(item, endpoint: endpoint);
      emit(AddedState("Item added successfully"));
    } catch (e) {
      emit(ApiErrorState<T>("Failed to add item"));
    }
    fetchItems();
  }

  void updateItem(T item, int id, {String? endpoint}) async {
    emit(LoadingState<T>());
    try {
      await repository.update(item, id, endpoint: endpoint);
      emit(UpdatedState("Item updated successfully"));
    } catch (e) {
      emit(ApiErrorState<T>("Failed to update item"));
    }
    fetchItems();
  }

  void deleteItem(int id, {String? endpoint}) async {
    emit(LoadingState<T>());
    try {
      await repository.delete(id, endpoint: endpoint);
      emit(DeletedState("Item deleted successfully"));
    } catch (e) {
      emit(ApiErrorState<T>("Failed to delete item"));
    }
    fetchItems();
  }
}
