import 'package:dio/dio.dart';
import '../../../helpers/DioClient.dart';
import '../cubit/trip_profit_summary_state.dart';

class TripProfitSummaryService {
  static final TripProfitSummaryService _instance =
      TripProfitSummaryService._internal();

  late final Dio _dio;

  factory TripProfitSummaryService() {
    return _instance;
  }
  bool isRedirectingToLogin = false;
  TripProfitSummaryService._internal() {
    _dio = DioClient.createDio();
    // Let other errors propagate
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
  //     //       "MISCELLANEOUS": 300
  //     //     });
  //   } on DioException catch (e) {
  //     throw DioErrorHandler.handle(e);
  //   }
  // }
  Future<TripProfitSummary> fetchTripProfitSummary(String tripId) async {
    try {
      final response = await _dio.get('/trips/$tripId/summary');

      final rawData = response.data['data'];
      if (rawData == null || rawData is! Map) {
        throw Exception('Invalid data structure');
      }

      final summaryData = {
        "totalIncome": rawData["totalIncome"],
        "totalExpenses": rawData["totalExpenses"],
        "profit": rawData["profit"],
        "expensesByCategory": rawData["expensesByCategory"],
        "driverName": rawData["driverName"],
        "vehicleNumber": rawData["vehicleNumber"],
        "distance": rawData["distance"]
      };

      return TripProfitSummary.fromJson(Map<String, dynamic>.from(summaryData));
    } catch (e) {
      throw Exception('Failed to fetch trip profit summary: $e');
    }
  }
}
