import '../cubit/trips_state.dart';
import '../service/trips_service.dart';

class TripRepository {
  final TripService service;

  TripRepository(this.service);

  Future<List<Trip>> getAllTrip() => service.fetchTrip();

  Future<List<Trip>> getAllTripByVehicle(String id) =>
      service.fetchTripsByVehicle(id);

  Future<void> addTrip(Trip trip) => service.addTrip(trip);

  Future<void> updateTrip(Trip trip) => service.updateTrip(trip);

  Future<void> deleteTrip(String id) => service.deleteTrip(id);
}
