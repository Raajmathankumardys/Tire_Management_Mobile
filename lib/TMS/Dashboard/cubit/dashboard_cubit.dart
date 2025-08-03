import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_state.dart';
import '../repository/dashboard_repository.dart';

class DashboardCubit extends Cubit<DashboardState> {
  final DashboardRepository repository;

  DashboardCubit(this.repository) : super(DashboardInitial());

  Future<void> fetchDashboard() async {
    emit(DashboardLoading());
    try {
      final dashboard = await repository.getDashboardData();
      emit(DashboardLoaded(dashboard));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
