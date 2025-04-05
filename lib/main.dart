import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/repository/tire_inventory_repository.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/service/tire_inventory_service.dart';
import 'package:yaantrac_app/TMS/Vehicle/cubit/vehicle_cubit.dart';
import 'TMS/Tire-Inventory/cubit/tire_inventory_cubit.dart';
import 'TMS/Vehicle/repository/vehicle_repository.dart';
import 'TMS/Vehicle/service/vehicle_service.dart';
import 'bloc/Theme/theme_bloc.dart';
import 'screens/Homepage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(LoadThemeEvent())),
        Provider<VehicleService>(
          create: (context) => VehicleService(),
        ),
        BlocProvider<VehicleCubit>(
          create: (context) {
            final vehicleService = context.read<VehicleService>();
            final vehicleRepository = VehicleRepository(vehicleService);
            return VehicleCubit(vehicleRepository)..fetchVehicles();
          },
        ),
        Provider<TireInventoryService>(
          create: (context) => TireInventoryService(),
        ),
        BlocProvider<TireInventoryCubit>(
          create: (context) {
            final tireInventoryService = context.read<TireInventoryService>();
            final tireInventoryRepository =
                TireInventoryRepository(tireInventoryService);
            return TireInventoryCubit(tireInventoryRepository)
              ..fetchTireInventory();
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        if (state is ThemeLoadingState) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                  child: CircularProgressIndicator()), // Show loading spinner
            ),
          );
        }

        return ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            themeMode:
                (state is ThemeLoadedState) ? state.themeMode : ThemeMode.light,
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            home: const HomeScreen(),
          ),
        );
      },
    );
  }
}
