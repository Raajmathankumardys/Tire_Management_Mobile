import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/exception.dart';
import '../cubit/vehicle_axle_state.dart';

class VehicleAxleService {
  static final VehicleAxleService _instance = VehicleAxleService._internal();

  late final Dio _dio;

  factory VehicleAxleService() {
    return _instance;
  }

  VehicleAxleService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<VehicleAxle>> fetchVehicles(int id) async {
    try {
      final response = await _dio.get('/vehicles/$id/axles');
      return (response.data['data'] as List)
          .map((v) => VehicleAxle.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
