import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/trips_repository.dart';
import 'trips_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository repository;
  TripCubit(this.repository) : super(TripInitial());

  void fetchTrip(int tripId) async {
    try {
      emit(TripLoading());
      final trip = await repository.getAllTrip(tripId);
      emit(TripLoaded(trip));
    } catch (e) {
      emit(TripError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTrip(Trip trip) async {
    try {
      await repository.addTrip(trip);
      emit(AddedTripState("Added"));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(trip.id!);
  }

  void updateTrip(Trip trip) async {
    try {
      await repository.updateTrip(trip);
      emit(UpdatedTripState("Updated"));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(trip.id!);
  }

  void deleteTrip(Trip trip, int id) async {
    try {
      await repository.deleteTrip(id);
      emit(DeletedTripState("Deleted"));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(trip.id!);
  }
}
