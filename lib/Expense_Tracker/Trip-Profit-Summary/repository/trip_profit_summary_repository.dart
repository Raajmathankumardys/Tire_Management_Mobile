import '../cubit/trip_profit_summary_state.dart';
import '../service/trip_profit_summary_service.dart';

class TripProfitSummaryRepository {
  final TripProfitSummaryService service;

  TripProfitSummaryRepository(this.service);

  Future<TripProfitSummary> getAllTripProfitSummary(String tripId) =>
      service.fetchTripProfitSummary(tripId);
}
