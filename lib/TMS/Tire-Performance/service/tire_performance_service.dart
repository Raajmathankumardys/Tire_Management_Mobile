import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    print(id);
    final response = await _dio.get('/tires/$id/performances');
    return (response.data['data'] as List)
        .map((v) => TirePerformance.fromJson(v))
        .toList(growable: false);
  }

  Future<void> addTirePerformance(TirePerformance tireperformance) async {
    await _dio.post('/tires/${tireperformance.tireId}/add-performance',
        data: tireperformance.toJson());
  }
}
