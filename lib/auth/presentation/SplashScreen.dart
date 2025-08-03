// lib/commonScreen/SplashScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/cubit/vehicle_category_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/repository/vehicle_category_repository.dart';
import 'package:yaantrac_app/commonScreen/Homepage.dart';

import '../../Expense_Tracker/Driver/cubit/driver_cubit.dart';
import '../../Expense_Tracker/Driver/repository/driver_repository.dart';
import '../../Expense_Tracker/Driver/service/driver_service.dart';
import '../../Expense_Tracker/Trips/cubit/trips_cubit.dart';
import '../../Expense_Tracker/Trips/repository/trips_repository.dart';
import '../../Expense_Tracker/Trips/service/trips_service.dart';
import '../../TMS/Dashboard/cubit/dashboard_cubit.dart';
import '../../TMS/Dashboard/repository/dashboard_repository.dart';
import '../../TMS/Dashboard/service/dashboard_service.dart';
import '../../TMS/Maintenance-Logs/cubit/maintenance_log_cubit.dart';
import '../../TMS/Maintenance-Logs/repository/maintenance_logs_repository.dart';
import '../../TMS/Maintenance-Logs/service/maintenance_logs_service.dart';
import '../../TMS/Maintenance-Schedule/cubit/maintenance_schedule_cubit.dart';
import '../../TMS/Maintenance-Schedule/repository/maintenance_schedule_repository.dart';
import '../../TMS/Maintenance-Schedule/service/maintenance_schedule_service.dart';
import '../../TMS/Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../TMS/Tire-Inventory/repository/tire_inventory_repository.dart';
import '../../TMS/Tire-Inventory/service/tire_inventory_service.dart';
import '../../TMS/Tire-Position/Cubit/tire_position_cubit.dart';
import '../../TMS/Tire-Position/Repository/tire_position_repository.dart';
import '../../TMS/Tire-Position/Service/tire_position_service.dart';
import '../../TMS/Vehicle-Category/service/vehicle_category_service.dart';
import '../../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../../TMS/Vehicle/repository/vehicle_repository.dart';
import '../../TMS/Vehicle/service/vehicle_service.dart';
import '../cubit/auth_cubit.dart';
import '../repository/auth_repository.dart';
import '../service/auth_service.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    await Future.delayed(const Duration(seconds: 2)); // splash delay

    if (token != null && token.isNotEmpty) {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<VehicleCubit>(
                  create: (context) {
                    final vehicleService = context.read<VehicleService>();
                    final vehicleRepository = VehicleRepository(vehicleService);
                    return VehicleCubit(vehicleRepository);
                  },
                ),
                BlocProvider<TireInventoryCubit>(create: (context) {
                  final tireInventoryService =
                      context.read<TireInventoryService>();
                  final tireInventoryRepository =
                      TireInventoryRepository(tireInventoryService);
                  return TireInventoryCubit(tireInventoryRepository)
                    ..fetchTires();
                }),
                BlocProvider<TirePositionCubit>(
                  create: (context) {
                    final tirePositionService =
                        context.read<TirePositionService>();
                    final tirePositionRepository =
                        TirePositionRepository(tirePositionService);
                    return TirePositionCubit(tirePositionRepository)
                      ..fetchTirePosition();
                  },
                ),
                BlocProvider<DriverCubit>(
                  create: (context) {
                    final driverService = context.read<DriverService>();
                    final driverRepository = DriverRepository(driverService);
                    return DriverCubit(driverRepository)..fetchDriver();
                  },
                ),
                BlocProvider<TripCubit>(
                  create: (context) {
                    final tripService = context.read<TripService>();
                    final tripRepository = TripRepository(tripService);
                    return TripCubit(tripRepository)..fetchTrip();
                  },
                ),
                BlocProvider<MaintenanceLogCubit>(
                  create: (context) {
                    final maintenanceLogService =
                        context.read<MaintenanceLogService>();
                    final maintenanceLogRepository =
                        MaintenanceLogRepository(maintenanceLogService);
                    return MaintenanceLogCubit(maintenanceLogRepository)
                      ..fetchMaintenanceLogs();
                  },
                ),
                BlocProvider<MaintenanceScheduleCubit>(
                  create: (context) {
                    final maintenanceScheduleService =
                        context.read<MaintenanceScheduleService>();
                    final maintenanceScheduleRepository =
                        MaintenancescheduleRepository(
                            maintenanceScheduleService);
                    return MaintenanceScheduleCubit(
                        maintenanceScheduleRepository)
                      ..fetchMaintenanceSchedule();
                  },
                ),
                BlocProvider<DashboardCubit>(
                  create: (context) {
                    final dashboardService = context.read<DashboardService>();
                    final dashboardRepository =
                        DashboardRepository(dashboardService);
                    return DashboardCubit(dashboardRepository)
                      ..fetchDashboard();
                  },
                ),
              ],
              child: HomeScreen(),
            ),
          ));
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
              providers: [
                BlocProvider<AuthCubit>(
                  create: (context) {
                    final service = context.read<AuthService>();
                    final repo = AuthRepository(service);
                    return AuthCubit(repo);
                  },
                ),
              ],
              child: LoginScreen(),
            ),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: FlutterLogo(size: 80),
      ),
    );
  }
}
