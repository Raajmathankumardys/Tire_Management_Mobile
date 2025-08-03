import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/maintenance_schedule_repository.dart';
import 'maintenance_schedule_state.dart';

class MaintenanceScheduleCubit extends Cubit<MaintenanceScheduleState> {
  final MaintenancescheduleRepository repository;
  MaintenanceScheduleCubit(this.repository)
      : super(MaintenanceScheduleInitial());

  void fetchMaintenanceSchedule() async {
    try {
      emit(MaintenanceScheduleLoading());
      final maintenanceLog = await repository.getAllMaintenanceschedule();
      emit(MaintenanceScheduleLoaded(maintenanceLog));
    } catch (e) {
      emit(MaintenanceScheduleError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addMaintenanceSchedule(MaintenanceSchedule maintenanceschedule) async {
    try {
      await repository.addMaintenanceschedule(maintenanceschedule);
      emit(AddedMaintenanceScheduleState("Added"));
    } catch (e) {
      emit(MaintenanceScheduleError(e.toString()));
    }
    fetchMaintenanceSchedule();
  }

  void updateMaintenanceSchedule(
      MaintenanceSchedule maintenanceschedule) async {
    try {
      await repository.updateMaintenanceschedule(maintenanceschedule);
      emit(UpdatedMaintenanceScheduleState("Updated"));
    } catch (e) {
      emit(MaintenanceScheduleError(e.toString()));
    }
    fetchMaintenanceSchedule();
  }

  void deleteMaintenanceSchedule(
      MaintenanceSchedule maintenanceschedule, String id) async {
    try {
      await repository.deleteMaintenanceschedule(id);
      emit(DeletedMaintenanceScheduleState("Deleted"));
    } catch (e) {
      emit(MaintenanceScheduleError(e.toString()));
    }
    fetchMaintenanceSchedule();
  }
}
