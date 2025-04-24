// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:yaantrac_app/TMS/repository/base_repository.dart';
// import '../../models/trip.dart';
// import 'base_state.dart';
//
// class BaseCubit<Trip> extends Cubit<BaseState<Trip>> {
//   final BaseRepository<Trip> repository;
//
//   BaseCubit(this.repository) : super(InitialState());
//
//   void fetchItems({String? endpoint}) async {
//     emit(LoadingState<Trip>());
//     try {
//       final items = await repository.getAll(endpoint: endpoint);
//       emit(LoadedState<Trip>(items.cast<Trip>()));
//     } catch (e) {
//       emit(ErrorState<Trip>("Failed to load items"));
//     }
//   }
//
//   void fetchPerformance(String endpoint) async {
//     emit(LoadingState<Trip>()); // Ensures UI resets to loading state
//     try {
//       final items = await repository.getPerformance(endpoint: endpoint);
//
//       emit(LoadedState<Trip>(items));
//     } catch (e) {
//       emit(ErrorState<Trip>("Failed to load items"));
//     }
//   }
//
//   void addPerformance(Trip item,
//       {required String endpoint, required String fetchApi}) async {
//     emit(LoadingState<Trip>());
//     try {
//       await repository.addPerformance(item, endpoint: endpoint);
//       emit(AddedState("Item added successfully"));
//     } catch (e) {
//       emit(ApiErrorState<Trip>("Failed to add item"));
//     }
//     fetchPerformance(fetchApi);
//   }
//
//   void addItem(Trip item, {String? endpoint}) async {
//     emit(LoadingState<Trip>());
//     try {
//       await repository.add(item, endpoint: endpoint);
//       emit(AddedState("Item added successfully"));
//     } catch (e) {
//       emit(ApiErrorState<Trip>("Failed to add item"));
//     }
//     fetchItems();
//   }
//
//   void updateItem(Trip item, int id, {String? endpoint}) async {
//     emit(LoadingState<Trip>());
//     try {
//       await repository.update(item, id, endpoint: endpoint);
//       emit(UpdatedState("Item updated successfully"));
//     } catch (e) {
//       emit(ApiErrorState<Trip>("Failed to update item"));
//     }
//     fetchItems();
//   }
//
//   void deleteItem(int id, {String? endpoint}) async {
//     emit(LoadingState<Trip>());
//     try {
//       await repository.delete(id, endpoint: endpoint);
//       emit(DeletedState("Item deleted successfully"));
//     } catch (e) {
//       emit(ApiErrorState<Trip>("Failed to delete item"));
//     }
//     fetchItems();
//   }
// }
