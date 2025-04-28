import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/repository/tire_inventory_repository.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/service/tire_inventory_service.dart';
import 'package:yaantrac_app/TMS/Vehicle/cubit/vehicle_cubit.dart';
import 'TMS/Tire-Category/cubit/tire_category_cubit.dart';
import 'TMS/Tire-Category/repository/tire_category_repository.dart';
import 'TMS/Tire-Category/service/tire_category_service.dart';
import 'TMS/Tire-Inventory/cubit/tire_inventory_cubit.dart';
import 'TMS/Tire-Position/Cubit/tire_position_cubit.dart';
import 'TMS/Tire-Position/Repository/tire_position_repository.dart';
import 'TMS/Tire-Position/Service/tire_position_service.dart';
import 'TMS/Vehicle/repository/vehicle_repository.dart';
import 'TMS/Vehicle/service/vehicle_service.dart';
import 'commonScreen/Homepage.dart';
import 'helpers/components/themes/ThemeProvider.dart';

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
        BlocProvider<TireInventoryCubit>(create: (context) {
          final tireInventoryService = context.read<TireInventoryService>();
          final tireInventoryRepository =
              TireInventoryRepository(tireInventoryService);
          return TireInventoryCubit(tireInventoryRepository)
            ..fetchTireInventory();
        }),
        Provider<TireCategoryService>(
          create: (context) => TireCategoryService(),
        ),
        BlocProvider<TireCategoryCubit>(
          create: (context) {
            final tireCategoryService = context.read<TireCategoryService>();
            final tireCategoryRepository =
                TireCategoryRepository(tireCategoryService);
            return TireCategoryCubit(tireCategoryRepository)
              ..fetchTireCategory();
          },
        ),
        Provider<TirePositionService>(
          create: (context) => TirePositionService(),
        ),
        BlocProvider<TirePositionCubit>(
          create: (context) {
            final tirePositionService = context.read<TirePositionService>();
            final tirePositionRepository =
                TirePositionRepository(tirePositionService);
            return TirePositionCubit(tirePositionRepository)
              ..fetchTirePosition();
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
