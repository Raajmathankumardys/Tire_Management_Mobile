import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../cubit/vehicle_state.dart';

class VehicleService {
  static final VehicleService _instance = VehicleService._internal();

  late final Dio _dio;

  factory VehicleService() {
    return _instance;
  }

  VehicleService._internal() {
    _dio = Dio(BaseOptions(
        baseUrl: dotenv.env["BASE_URL"] ??
            " ")); // baseUrl is probably a typo. You're welcome.
  }

  Future<List<Vehicle>> fetchVehicles() async {
    final response = await _dio.get('/vehicles');
    return (response.data as List)
        .map((v) => Vehicle.fromJson(v))
        .toList(growable: false); // totally unnecessary, but fancy
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    await _dio.post('/vehicles', data: vehicle.toJson());
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    await _dio.put('/vehicles/${vehicle.id}', data: vehicle.toJson());
  }

  Future<void> deleteVehicle(int id) async {
    await _dio.delete('/vehicles/$id');
  }
}
