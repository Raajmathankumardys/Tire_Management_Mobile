// lib/commonScreen/LoginScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
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
import '../../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../../TMS/Vehicle/repository/vehicle_repository.dart';
import '../../TMS/Vehicle/service/vehicle_service.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../../auth/cubit/auth_state.dart';
import '../../commonScreen/Homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  void _submit() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();
    context.read<AuthCubit>().login(username, password);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ The error was due to missing `body`
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthSuccess) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MultiBlocProvider(
                            providers: [
                              Provider<VehicleService>(
                                create: (context) => VehicleService(),
                              ),
                              BlocProvider<VehicleCubit>(
                                create: (context) {
                                  final vehicleService =
                                      context.read<VehicleService>();
                                  final vehicleRepository =
                                      VehicleRepository(vehicleService);
                                  return VehicleCubit(vehicleRepository)
                                    ..fetchVehicles();
                                },
                              ),
                              Provider<TireInventoryService>(
                                create: (context) => TireInventoryService(),
                              ),
                              BlocProvider<TireInventoryCubit>(
                                  create: (context) {
                                final tireInventoryService =
                                    context.read<TireInventoryService>();
                                final tireInventoryRepository =
                                    TireInventoryRepository(
                                        tireInventoryService);
                                return TireInventoryCubit(
                                    tireInventoryRepository)
                                  ..fetchTires();
                              }),
                              Provider<TirePositionService>(
                                create: (context) => TirePositionService(),
                              ),
                              BlocProvider<TirePositionCubit>(
                                create: (context) {
                                  final tirePositionService =
                                      context.read<TirePositionService>();
                                  final tirePositionRepository =
                                      TirePositionRepository(
                                          tirePositionService);
                                  return TirePositionCubit(
                                      tirePositionRepository)
                                    ..fetchTirePosition();
                                },
                              ),
                              Provider<DriverService>(
                                create: (context) => DriverService(),
                              ),
                              BlocProvider<DriverCubit>(
                                create: (context) {
                                  final driverService =
                                      context.read<DriverService>();
                                  final driverRepository =
                                      DriverRepository(driverService);
                                  return DriverCubit(driverRepository)
                                    ..fetchDriver();
                                },
                              ),
                              Provider<TripService>(
                                create: (context) => TripService(),
                              ),
                              BlocProvider<TripCubit>(
                                create: (context) {
                                  final tripService =
                                      context.read<TripService>();
                                  final tripRepository =
                                      TripRepository(tripService);
                                  return TripCubit(tripRepository)..fetchTrip();
                                },
                              ),
                              Provider<MaintenanceLogService>(
                                create: (context) => MaintenanceLogService(),
                              ),
                              BlocProvider<MaintenanceLogCubit>(
                                create: (context) {
                                  final maintenanceLogService =
                                      context.read<MaintenanceLogService>();
                                  final maintenanceLogRepository =
                                      MaintenanceLogRepository(
                                          maintenanceLogService);
                                  return MaintenanceLogCubit(
                                      maintenanceLogRepository)
                                    ..fetchMaintenanceLogs();
                                },
                              ),
                              Provider<MaintenanceScheduleService>(
                                create: (context) =>
                                    MaintenanceScheduleService(),
                              ),
                              BlocProvider<MaintenanceScheduleCubit>(
                                create: (context) {
                                  final maintenanceScheduleService = context
                                      .read<MaintenanceScheduleService>();
                                  final maintenanceScheduleRepository =
                                      MaintenancescheduleRepository(
                                          maintenanceScheduleService);
                                  return MaintenanceScheduleCubit(
                                      maintenanceScheduleRepository)
                                    ..fetchMaintenanceSchedule();
                                },
                              ),
                              Provider<DashboardService>(
                                create: (context) => DashboardService(),
                              ),
                              BlocProvider<DashboardCubit>(
                                create: (context) {
                                  final dashboardService =
                                      context.read<DashboardService>();
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
                  } else if (state is AuthFailure) {
                    print(state.message);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(state.message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Login",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 32),
                      TextField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 24),
                      state is AuthLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submit,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text("Login"),
                            ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
