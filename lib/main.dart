import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/vehicles/service/vehicleService.dart';
import 'bloc/Theme/theme_bloc.dart';
import 'bloc/vehicle/vehicle_bloc.dart';
import 'models/vehicle.dart';
import 'screens/Homepage.dart';
import 'vehicles/cubit/vehicle_cubit.dart';
import 'vehicles/repository/vehicle_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ThemeBloc()..add(LoadThemeEvent())),
        RepositoryProvider(
          create: (context) => BaseRepository<Vehicle>(BaseService<Vehicle>(
              baseUrl: "https://yaantrac-backend.onrender.com/api/vehicles",
              fromJson: Vehicle.fromJson,
              toJson: (vehicle) =>
                  vehicle.toJson())), // Pass the required parameter
        ),
        BlocProvider(
            create: (context) =>
                BaseCubit<Vehicle>(context.read<BaseRepository<Vehicle>>())
                  ..fetchItems() // Inject repository into Cubit
            // , // Fetch initial data
            ),
        //(create: (context) => VehicleBloc()),
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
