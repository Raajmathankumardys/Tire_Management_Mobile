import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/exception.dart';
import '../cubit/maintenance_logs_state.dart';

class MaintenanceLogService {
  static final MaintenanceLogService _instance =
      MaintenanceLogService._internal();

  late final Dio _dio;

  factory MaintenanceLogService() {
    return _instance;
  }

  MaintenanceLogService._internal() {
    _dio = Dio(
        BaseOptions(baseUrl: "https://tms-backend-1-80jm.onrender.com/api/v1"));
  }

  Future<List<MaintenanceLog>> fetchMaintenanceLogs() async {
    try {
      final response = await _dio.get("/maintenance");
      return (response.data['data'] as List)
          .map((v) => MaintenanceLog.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addMaintenanceLog(MaintenanceLog maintenancelog) async {
    try {
      await _dio.post("/maintenance/records", data: maintenancelog.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateMaintenanceLog(MaintenanceLog maintenancelog) async {
    try {
      await _dio.put('/maintenance/records/${maintenancelog.id}',
          data: maintenancelog.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteMaintenanceLog(String id) async {
    try {
      await _dio.delete('/maintenance/records/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
