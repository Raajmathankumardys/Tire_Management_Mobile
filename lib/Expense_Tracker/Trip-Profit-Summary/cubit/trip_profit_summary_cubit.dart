import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/trip_profit_summary_repository.dart';
import 'trip_profit_summary_state.dart';

class TripProfitSummaryCubit extends Cubit<TripProfitSummaryState> {
  final TripProfitSummaryRepository repository;
  TripProfitSummaryCubit(this.repository) : super(TripProfitSummaryInitial());

  void fetchTripProfitSummary(String tripId) async {
    try {
      emit(TripProfitSummaryLoading());
      final tripprofitSummary =
          await repository.getAllTripProfitSummary(tripId);
      emit(TripProfitSummaryLoaded(tripprofitSummary));
    } catch (e) {
      emit(TripProfitSummaryError(e.toString()));
      throw Exception(e.toString());
    }
  }
}
