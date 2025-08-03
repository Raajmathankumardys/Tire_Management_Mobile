// cubit/report_cubit.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/report_repository.dart';
import 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  final ReportRepository repository;

  ReportCubit(this.repository) : super(ReportInitial());

  Future<void> fetchReport({
    required String startDate,
    required String endDate,
    String? tripId,
    String? vehicleNumber,
    String? driverName,
  }) async {
    emit(ReportLoading());
    try {
      final report = await repository.getReport(
        startDate: startDate,
        endDate: endDate,
        tripId: tripId,
        vehicleNumber: vehicleNumber,
        driverName: driverName,
      );
      emit(ReportLoaded(report));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}
