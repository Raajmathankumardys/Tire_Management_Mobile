import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/tire_performance_state.dart';

class TirePerformanceService {
  static final TirePerformanceService _instance =
      TirePerformanceService._internal();

  late final Dio _dio;

  factory TirePerformanceService() {
    return _instance;
  }

  TirePerformanceService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TirePerformance>> fetchTirePerformance(int id) async {
    try {
      // final response = await _dio.get(tireperformancesconstants.endpoint(id));
      // return (response.data['data'] as List)
      //     .map((v) => TirePerformance.fromJson(v))
      //     .toList(growable: false);
      final random = Random();
      List<TirePerformance> tirePerformances = [];

      for (int i = 0; i < 50; i++) {
        tirePerformances.add(TirePerformance(
          pressure: 30 + random.nextDouble() * 10,
          temperature: 30 + random.nextDouble() * 10,
          wear: 30 + random.nextDouble() * 10,
          distanceTraveled: 20 + random.nextDouble() * 20,
          treadDepth: 25 + random.nextDouble() * 15,
        ));
      }

      return tirePerformances;
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTirePerformance(TirePerformance tireperformance) async {
    try {
      await _dio.post(
          tireperformancesconstants.addendpoint(tireperformance.tireId),
          data: tireperformance.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
