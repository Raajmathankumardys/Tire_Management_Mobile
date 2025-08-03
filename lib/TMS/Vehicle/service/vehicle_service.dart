import 'package:dio/dio.dart';
import 'package:yaantrac_app/helpers/DioClient.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/vehicle_state.dart';

class VehicleService {
  static final VehicleService _instance = VehicleService._internal();

  late final Dio _dio;

  factory VehicleService() {
    return _instance;
  }

  VehicleService._internal() {
    _dio = DioClient.createDio();
  }

  Future<List<Vehicle>> fetchVehicles() async {
    try {
      final response = await _dio.get(vehicleconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => Vehicle.fromJson(v))
          .toList(growable: false);
      ; // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<Vehicle> fetchVehicleById(String id) async {
    try {
      final response = await _dio.get("/vehicles/$id");
      return Vehicle.fromJson(response.data['data']);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addVehicle(Vehicle vehicle) async {
    try {
      await _dio.post(vehicleconstants.endpoint, data: vehicle.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      await _dio.put('${vehicleconstants.endpoint}/${vehicle.id}',
          data: vehicle.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteVehicle(String id) async {
    try {
      await _dio.delete('${vehicleconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
