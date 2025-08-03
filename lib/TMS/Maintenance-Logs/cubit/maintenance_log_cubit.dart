import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/maintenance_logs_repository.dart';
import 'maintenance_logs_state.dart';

class MaintenanceLogCubit extends Cubit<MaintenanceLogState> {
  final MaintenanceLogRepository repository;
  MaintenanceLogCubit(this.repository) : super(MaintenanceLogInitial());

  void fetchMaintenanceLogs() async {
    try {
      emit(MaintenanceLogLoading());
      final maintenanceLog = await repository.getAllMaintenanceLogs();
      emit(MaintenanceLogLoaded(maintenanceLog));
    } catch (e) {
      emit(MaintenanceLogError(e.toString()));
      throw Exception(e.toString());
    }
  }

  void addMaintenanceLog(MaintenanceLog maintenancelog) async {
    try {
      await repository.addMaintenanceLog(maintenancelog);
      emit(AddedMaintenanceLogState("Added"));
    } catch (e) {
      emit(MaintenanceLogError(e.toString()));
    }
    fetchMaintenanceLogs();
  }

  void updateMaintenanceLog(MaintenanceLog maintenancelog) async {
    try {
      await repository.updateMaintenanceLog(maintenancelog);
      emit(UpdatedMaintenanceLogState("Updated"));
    } catch (e) {
      emit(MaintenanceLogError(e.toString()));
    }
    fetchMaintenanceLogs();
  }

  void deleteMaintenanceLog(MaintenanceLog maintenancelog, String id) async {
    try {
      await repository.deleteMaintenanceLog(id);
      emit(DeletedMaintenanceLogState("Deleted"));
    } catch (e) {
      emit(MaintenanceLogError(e.toString()));
    }
    fetchMaintenanceLogs();
  }
}
