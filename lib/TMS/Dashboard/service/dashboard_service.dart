import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/exception.dart';
import '../cubit/dashboard_state.dart';

class DashboardService {
  static final DashboardService _instance = DashboardService._internal();

  late final Dio _dio;

  factory DashboardService() {
    return _instance;
  }

  DashboardService._internal() {
    _dio = Dio(
        BaseOptions(baseUrl: "https://tms-backend-1-80jm.onrender.com/api/v1"));
  }

  Future<DashboardModel> fetchDashboardStats() async {
    try {
      // You can uncomment the real API call if needed:
      // final response = await _dio.get("/dashboard/stats");
      // return DashboardModel.fromJson(response.data['data']);

      // Mock data used here instead of actual API
      final mockData = {
        "totalTires": 120,
        "tiresInUse": 85,
        "tiresInStock": 35,
        "totalVehicles": 30,
        "vehiclesActive": 25,
        "vehiclesInMaintenance": 5,
        "alertsActive": 12,
        "maintenanceScheduled": 4,
        "monthlyTireStats": List.generate(3, (yearIndex) {
          final year = 2023 + yearIndex;
          final months = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
          ];
          return List.generate(12, (i) {
            return {
              "month": months[i],
              "year": year,
              "avgTreadDepth":
                  9.0 - 0.1 * (yearIndex * 12 + i), // decreases over time
              "avgPressure": 33.0 - 0.2 * (yearIndex * 12 + i),
              "avgTemperature": 70.0 +
                  0.5 * i +
                  yearIndex * 1.2 // seasonal effect + yearly drift
            };
          });
        }).expand((x) => x).toList(),
        "alertTrends": List.generate(3, (yearIndex) {
          final year = 2023 + yearIndex;
          final months = [
            "JAN",
            "FEB",
            "MAR",
            "APR",
            "MAY",
            "JUN",
            "JUL",
            "AUG",
            "SEP",
            "OCT",
            "NOV",
            "DEC"
          ];
          return List.generate(12, (i) {
            return {
              "month": months[i],
              "year": year,
              "pressureAlerts": 2 + (i % 6) + yearIndex,
              "temperatureAlerts": 1 + (i % 5) + yearIndex,
              "wearAlerts": 1 + (i % 4) + yearIndex,
              "maintenanceAlerts": 1 + (i % 3) + yearIndex
            };
          });
        }).expand((x) => x).toList(),
        "totalIncome": 500000.0,
        "totalExpenses": 320000.0,
        "netProfit": 180000.0,
        "averageProfitPerTrip": 15000.0,
      };

      return DashboardModel.fromJson(mockData);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
