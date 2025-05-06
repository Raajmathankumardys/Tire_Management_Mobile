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

  // Future<TripProfitSummary> fetchTripProfitSummary(int tripId) async {
  //   try {
  //     final response = await _dio.get('/trips/$tripId/summary');
  //     print(response.data['data']);
  //     //return (response.data['data']).map((v) => TripProfitSummary.fromJson(v));
  //     return (response.data['data'])
  //         .values
  //         .map((v) => TripProfitSummary.fromJson(v as Map<String, dynamic>))
  //         .toList();
  //
  //     // return TripProfitSummary(
  //     //     tripId: 21,
  //     //     totalIncome: 300,
  //     //     totalExpenses: 800,
  //     //     profit: -600,
  //     //     breakDown: {
  //     //       "FUEL": 200,
  //     //       "TOLL": 100,
  //     //       "MAINTENANCE": 50,
  //     //       "DRIVER_ALLOWANCE": 150,
  //     //       "MISCELLANOUS": 300
  //     //     });
  //   } on DioException catch (e) {
  //     throw DioErrorHandler.handle(e);
  //   }
  // }
  Future<TripProfitSummary> fetchTripProfitSummary(int tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/summary');

      // Print response data for debugging
      print('Response data: ${response.data}');

      var data = response.data['data'];

      if (data is Map<String, dynamic>) {
        // If the data is a map, we can directly parse it into TripProfitSummary
        return TripProfitSummary.fromJson(data);
      } else {
        throw Exception('Invalid data structure');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch trip profit summary: $e');
    }
  }
}
