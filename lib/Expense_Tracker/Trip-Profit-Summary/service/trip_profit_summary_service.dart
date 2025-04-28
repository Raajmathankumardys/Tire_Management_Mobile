import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../helpers/exception.dart';
import '../cubit/trip_profit_summary_state.dart';

class TripProfitSummaryService {
  static final TripProfitSummaryService _instance =
      TripProfitSummaryService._internal();

  late final Dio _dio;

  factory TripProfitSummaryService() {
    return _instance;
  }

  TripProfitSummaryService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<TripProfitSummary> fetchTripProfitSummary(int tripId) async {
    try {
      // final response = await _dio.get('/trips/$tripId/summary');
      // return (response.data['data']).map((v) => TripProfitSummary.fromJson(v));
      return TripProfitSummary(
          tripId: 21,
          totalIncome: 300,
          totalExpenses: 800,
          profit: -600,
          breakDown: {
            "FUEL": 200,
            "TOLL": 100,
            "MAINTENANCE": 50,
            "DRIVER_ALLOWANCE": 150,
            "MISCELLANOUS": 300
          });
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
