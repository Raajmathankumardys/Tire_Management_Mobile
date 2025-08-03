import '../cubit/maintenance_schedule_state.dart';
import '../service/maintenance_schedule_service.dart';

class MaintenancescheduleRepository {
  final MaintenanceScheduleService service;

  MaintenancescheduleRepository(this.service);

  Future<List<MaintenanceSchedule>> getAllMaintenanceschedule() =>
      service.fetchMaintenanceschedule();

  Future<void> addMaintenanceschedule(
          MaintenanceSchedule maintenanceschedule) =>
      service.addMaintenanceschedule(maintenanceschedule);

  Future<void> updateMaintenanceschedule(
          MaintenanceSchedule maintenanceschedule) =>
      service.updateMaintenanceschedule(maintenanceschedule);

  Future<void> deleteMaintenanceschedule(String id) =>
      service.deleteMaintenanceschedule(id);
}
