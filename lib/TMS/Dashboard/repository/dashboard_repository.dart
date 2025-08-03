import '../cubit/dashboard_state.dart';
import '../service/dashboard_service.dart';

class DashboardRepository {
  final DashboardService service;

  DashboardRepository(this.service);

  Future<DashboardModel> getDashboardData() => service.fetchDashboardStats();
}
