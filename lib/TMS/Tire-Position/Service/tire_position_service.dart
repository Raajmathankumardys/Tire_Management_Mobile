import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/exception.dart';
import '../Cubit/tire_position_state.dart';

class TirePositionService {
  static final TirePositionService _instance = TirePositionService._internal();

  late final Dio _dio;

  factory TirePositionService() {
    return _instance;
  }

  TirePositionService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TirePosition>> fetchTirePosition() async {
    try {
      final response = await _dio.get('/tire-positions');
      return (response.data['data'] as List)
          .map((v) => TirePosition.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
