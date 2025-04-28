import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/constants.dart';
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

  void addTrip(Trip trip, int vehicleId) async {
    try {
      await repository.addTrip(trip);
      emit(AddedTripState(
          tripconstants.addedtoast(trip.source, trip.destination)));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(vehicleId);
  }

  void updateTrip(Trip trip, int vehicleId) async {
    try {
      await repository.updateTrip(trip);
      emit(UpdatedTripState(
          tripconstants.updatedtoast(trip.source, trip.destination)));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(vehicleId);
  }

  void deleteTrip(Trip trip, int id) async {
    try {
      await repository.deleteTrip(id);
      emit(DeletedTripState(
          tripconstants.deletedtoast(trip.source, trip.destination)));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(id);
  }
}
