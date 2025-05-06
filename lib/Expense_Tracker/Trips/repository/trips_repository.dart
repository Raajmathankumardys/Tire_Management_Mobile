import '../cubit/trips_state.dart';
import '../service/trips_service.dart';

class TripRepository {
  final TripService service;

  TripRepository(this.service);

  Future<List<Trip>> getAllTrip(int tripId) => service.fetchTrip(tripId);

  Future<void> addTrip(Trip trip, int vehicleId) =>
      service.addTrip(trip, vehicleId);

  Future<void> updateTrip(Trip trip) => service.updateTrip(trip);

  Future<void> deleteTrip(int id) => service.deleteTrip(id);
}
