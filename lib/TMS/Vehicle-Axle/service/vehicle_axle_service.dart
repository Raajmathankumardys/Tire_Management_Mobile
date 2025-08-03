import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../../../helpers/DioClient.dart';
import '../../../helpers/exception.dart';
import '../cubit/vehicle_axle_state.dart';

class VehicleAxleService {
  static final VehicleAxleService _instance = VehicleAxleService._internal();

  late final Dio _dio;

  factory VehicleAxleService() {
    return _instance;
  }

  VehicleAxleService._internal() {
    _dio = DioClient.createDio();
  }

  Future<List<VehicleAxle>> fetchVehicles(String id) async {
    try {
      final response = await _dio.get(vehicleaxleconstants.endpoint(id));
      return (response.data['data'] as List)
          .map((v) => VehicleAxle.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addVehicleMapping(List<VehicleMapping> vehiclemapping) async {
    try {
      for (var i in vehiclemapping) {
        await _dio.post(
            "/vehicles/${i.vehicleId}/tires/${i.tireId}?positionId=${i.positionId}");
      }
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteVehicleMapping(String id, String positionId) async {
    try {
      await _dio.delete("/vehicles/$id/tires/$positionId?status=WORN_OUT");
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
