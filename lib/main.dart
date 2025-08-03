import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/service/vehicle_category_service.dart';
import 'Expense_Tracker/Driver/cubit/driver_cubit.dart';
import 'Expense_Tracker/Driver/repository/driver_repository.dart';
import 'Expense_Tracker/Driver/service/driver_service.dart';
import 'Expense_Tracker/Trips/service/trips_service.dart';
import 'TMS/Dashboard/service/dashboard_service.dart';
import 'TMS/Maintenance-Logs/service/maintenance_logs_service.dart';
import 'TMS/Maintenance-Schedule/service/maintenance_schedule_service.dart';
import 'TMS/Tire-Inventory/service/tire_inventory_service.dart';
import 'TMS/Tire-Position/Service/tire_position_service.dart';
import 'TMS/Vehicle-Category/cubit/vehicle_category_cubit.dart';
import 'TMS/Vehicle-Category/repository/vehicle_category_repository.dart';
import 'TMS/Vehicle/cubit/vehicle_cubit.dart';
import 'TMS/Vehicle/repository/vehicle_repository.dart';
import 'TMS/Vehicle/service/vehicle_service.dart';
import 'auth/cubit/auth_cubit.dart';
import 'auth/presentation/SplashScreen.dart';
import 'auth/presentation/login_screen.dart';
import 'auth/repository/auth_repository.dart';
import 'auth/service/auth_service.dart';
import 'helpers/components/themes/ThemeProvider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(LoadThemeEvent())),
        Provider<AuthService>(
          create: (context) => AuthService(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) {
            final service = context.read<AuthService>();
            final repo = AuthRepository(service);
            return AuthCubit(repo);
          },
        ),
        Provider<DriverService>(
          create: (context) => DriverService(),
        ),
        BlocProvider<DriverCubit>(
          create: (context) {
            final driverService = context.read<DriverService>();
            final driverRepository = DriverRepository(driverService);
            return DriverCubit(driverRepository)..fetchDriver();
          },
        ),
        Provider<VehicleService>(
          create: (context) => VehicleService(),
        ),
        Provider<TireInventoryService>(
          create: (context) => TireInventoryService(),
        ),
        Provider<TirePositionService>(
          create: (context) => TirePositionService(),
        ),
        Provider<TripService>(
          create: (context) => TripService(),
        ),
        Provider<MaintenanceLogService>(
          create: (context) => MaintenanceLogService(),
        ),
        Provider<MaintenanceScheduleService>(
          create: (context) => MaintenanceScheduleService(),
        ),
        Provider<DashboardService>(
          create: (context) => DashboardService(),
        ),
        Provider<VehicleCategoryService>(
          create: (context) => VehicleCategoryService(),
        ),
        BlocProvider<VehicleCategoryCubit>(
          create: (context) {
            final vehicleCategoryService =
                context.read<VehicleCategoryService>();
            final repository =
                VehicleCategoryRepository(vehicleCategoryService);
            return VehicleCategoryCubit(repository);
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        final themeMode =
            (state is ThemeLoadedState) ? state.themeMode : ThemeMode.light;

        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            themeMode: themeMode,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            routes: {
              '/login': (context) => const LoginScreen(),
            },
            home: state is ThemeLoadingState
                ? const Scaffold(
                    body: Center(child: CircularProgressIndicator()))
                : const SplashScreen(),
          ),
        );
      },
    );
  }
}
