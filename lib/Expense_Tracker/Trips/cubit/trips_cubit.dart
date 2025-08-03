import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../helpers/constants.dart';
import '../repository/trips_repository.dart';
import 'trips_state.dart';

class TripCubit extends Cubit<TripState> {
  final TripRepository repository;
  TripCubit(this.repository) : super(TripInitial());

  void fetchTrip({String? vehicleId}) async {
    try {
      emit(TripLoading());
      final trip = vehicleId != null
          ? await repository.getAllTripByVehicle(vehicleId!)
          : await repository.getAllTrip();
      emit(TripLoaded(trip));
    } catch (e) {
      emit(TripError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addTrip(Trip trip, {String? vehicleId}) async {
    try {
      await repository.addTrip(
        trip,
      );
      emit(AddedTripState(
          tripconstants.addedtoast(trip.source, trip.destination)));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(vehicleId: vehicleId);
  }

  void updateTrip(Trip trip, {String? vehicleId}) async {
    try {
      await repository.updateTrip(trip);
      emit(UpdatedTripState(
          tripconstants.updatedtoast(trip.source, trip.destination)));
    } catch (e) {
      print(e);
      emit(TripError(e.toString()));
    }
    fetchTrip(vehicleId: vehicleId);
  }

  void deleteTrip(Trip trip, String id, {String? vehicleId}) async {
    try {
      await repository.deleteTrip(id);
      emit(DeletedTripState(
          tripconstants.deletedtoast(trip.source, trip.destination)));
    } catch (e) {
      emit(TripError(e.toString()));
    }
    fetchTrip(vehicleId: vehicleId);
  }
}
