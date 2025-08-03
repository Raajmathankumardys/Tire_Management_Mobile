import '../cubit/maintenance_logs_state.dart';
import '../service/maintenance_logs_service.dart';

class MaintenanceLogRepository {
  final MaintenanceLogService service;

  MaintenanceLogRepository(this.service);

  Future<List<MaintenanceLog>> getAllMaintenanceLogs() =>
      service.fetchMaintenanceLogs();

  Future<void> addMaintenanceLog(MaintenanceLog maintenancelog) =>
      service.addMaintenanceLog(maintenancelog);

  Future<void> updateMaintenanceLog(MaintenanceLog maintenancelog) =>
      service.updateMaintenanceLog(maintenancelog);

  Future<void> deleteMaintenanceLog(String id) =>
      service.deleteMaintenanceLog(id);
}
