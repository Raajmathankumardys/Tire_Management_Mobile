import '../cubit/report_state.dart';
import '../service/report_service.dart';

class ReportRepository {
  final ReportService service;

  ReportRepository(this.service);

  Future<ReportModel> getReport({
    required String startDate,
    required String endDate,
    String? tripId,
    String? vehicleNumber,
    String? driverName,
  }) async {
    return await service.fetchReport(
      startDate: startDate,
      endDate: endDate,
      tripId: tripId,
      vehicleNumber: vehicleNumber,
      driverName: driverName,
    );
  }
}
