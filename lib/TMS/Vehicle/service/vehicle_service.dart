import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';

import '../cubit/vehicle_state.dart';

class VehicleService {
  static final VehicleService _instance = VehicleService._internal();

  late final Dio _dio;

  factory VehicleService() {
    return _instance;
  }

  VehicleService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<Vehicle>> fetchVehicles() async {
    try {
      final response = await _dio.get(vehicleconstants.endpoint);
      return (response.data as List)
          .map((v) => Vehicle.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _dio.post(vehicleconstants.endpoint, data: vehicle.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _dio.put('${vehicleconstants.endpoint}/${vehicle.id}',
          data: vehicle.toJson());
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> deleteVehicle(int id) async {
    try {
      await _dio.delete('${vehicleconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      switch (e.response!.statusCode) {
        case 400:
          return Exception("Bad request: ${e.response!.data}");
        case 401:
          return Exception("Unauthorized access. Please log in.");
        case 403:
          return Exception("Forbidden: You don’t have permission.");
        case 404:
          return Exception("Resource not found.");
        case 500:
          return Exception("Internal Server Error. Please try again later.");
        default:
          return Exception("Unexpected error: ${e.response!.statusCode}");
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception("Network timeout. Please check your connection.");
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception("No Internet connection.");
    } else {
      return Exception("Unexpected error: ${e.message}");
    }
  }
}
