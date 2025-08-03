import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/exception.dart';
import '../cubit/maintenance_schedule_state.dart';

class MaintenanceScheduleService {
  static final MaintenanceScheduleService _instance =
      MaintenanceScheduleService._internal();

  late final Dio _dio;

  factory MaintenanceScheduleService() {
    return _instance;
  }

  MaintenanceScheduleService._internal() {
    _dio = Dio(
        BaseOptions(baseUrl: "https://tms-backend-1-80jm.onrender.com/api/v1"));
  }

  Future<List<MaintenanceSchedule>> fetchMaintenanceschedule() async {
    try {
      final response = await _dio.get("/maintenance-schedules");
      return (response.data['data'] as List)
          .map((v) => MaintenanceSchedule.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addMaintenanceschedule(
      MaintenanceSchedule maintenanceschedule) async {
    try {
      await _dio.post("/maintenance-schedules",
          data: maintenanceschedule.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateMaintenanceschedule(
      MaintenanceSchedule maintenanceschedule) async {
    try {
      await _dio.put('/maintenance-schedules/${maintenanceschedule.id}',
          data: maintenanceschedule.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteMaintenanceschedule(String id) async {
    try {
      await _dio.delete('/maintenance-schedules/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
