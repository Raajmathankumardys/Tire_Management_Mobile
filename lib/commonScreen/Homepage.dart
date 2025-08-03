import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yaantrac_app/Expense_Tracker/Driver/presentation/driver_screen.dart';
import 'package:yaantrac_app/Expense_Tracker/Trips/presentation/screen/trips_screen.dart';
import 'package:yaantrac_app/TMS/Dashboard/presentation/dashboard_screen.dart';
import 'package:yaantrac_app/commonScreen/settings.dart';
import '../Expense_Tracker/Driver/cubit/driver_cubit.dart';
import '../Expense_Tracker/Driver/repository/driver_repository.dart';
import '../Expense_Tracker/Driver/service/driver_service.dart';
import '../Expense_Tracker/Trips/cubit/trips_cubit.dart';
import '../Expense_Tracker/Trips/repository/trips_repository.dart';
import '../Expense_Tracker/Trips/service/trips_service.dart';
import '../TMS/Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../TMS/Tire-Inventory/presentation/screen/tire_inventory_screen.dart';
import '../TMS/Tire-Inventory/presentation/screen/tire_logs_screen.dart';
import '../TMS/Tire-Inventory/repository/tire_inventory_repository.dart';
import '../TMS/Tire-Inventory/service/tire_inventory_service.dart';
import '../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../TMS/Vehicle/presentation/screen/vehicle_screen.dart';
import '../TMS/Vehicle/repository/vehicle_repository.dart';
import '../TMS/Vehicle/service/vehicle_service.dart';
import '../auth/cubit/auth_cubit.dart';
import '../auth/presentation/login_screen.dart';
import '../auth/repository/auth_repository.dart';
import '../auth/service/auth_service.dart';
import 'FirebaseAPI.dart';
import 'notification_screen.dart';
import 'filter_expense_screen.dart';
import 'package:yaantrac_app/TMS/Maintenance-Logs/presentation/maintenance_log_screen.dart';
import 'package:yaantrac_app/TMS/Maintenance-Schedule/presentation/maintenance_schedule_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  const HomeScreen({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _mainPages = [
    DashboardScreen(),
    vehiclescreen(),
    TireInventoryScreen(),
    DriverScreen(),
    TripsScreen(),
  ];

  final List<String> _titles = [
    "Dashboard",
    "Vehicles",
    "Tire Inventory",
    "Drivers",
    "Trips",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String userName = "q";
  SharedPreferences? prefs;
  @override
  void initState() {
    // TODO: implement initState
    FirebaseAPI.registerBackgroundHandler(); // 👈 Must be before runApp
    notify();
    super.initState();
  }

  Future<void> notify() async {
    final firebaseAPI = FirebaseAPI();
    await firebaseAPI.initNotification();
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("username")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        iconTheme: IconThemeData(
            color: Colors.white), // This sets the hamburger icon color
        title: Text(
          _titles[_selectedIndex],
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => NotificationScreen()));
            },
          )
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child:
                        Icon(Icons.person, color: Colors.blueAccent, size: 30),
                  ),
                  SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 4),
                      Text(
                        userName,
                        style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Drawer Menu List
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildDrawerItem(
                    icon: Icon(
                      Icons.mail,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    text: 'Maintenance Logs',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => maintenancelogscreen())),
                  ),
                  _buildDrawerItem(
                    icon: Icon(
                      Icons.schedule,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    text: 'Maintenance Schedule',
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => maintenanceschedulescreen())),
                  ),
                  _buildDrawerItem(
                    icon: Icon(
                      Icons.filter_alt,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    text: 'Trips Report',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            Provider<TireInventoryService>(
                              create: (context) => TireInventoryService(),
                            ),
                          ],
                          child: MultiBlocProvider(
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
                            ],
                            child: FilterExpenseScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildDrawerItem(
                    icon: SvgPicture.asset(
                      'assets/vectors/tire_icon.svg',
                      height: 15.h,
                    ),
                    text: 'Tire Logs',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MultiProvider(
                          providers: [
                            Provider<TireInventoryService>(
                              create: (context) => TireInventoryService(),
                            ),
                          ],
                          child: MultiBlocProvider(
                            providers: [
                              BlocProvider<TireInventoryCubit>(
                                create: (context) {
                                  final tireInventoryService =
                                      context.read<TireInventoryService>();
                                  final tireInventoryRepository =
                                      TireInventoryRepository(
                                          tireInventoryService);
                                  return TireInventoryCubit(
                                      tireInventoryRepository)
                                    ..fetchTiresLogs();
                                },
                              ),
                            ],
                            child: TireLogsScreen(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Divider(thickness: 1, indent: 16, endIndent: 16),
                  _buildDrawerItem(
                    icon: Icon(
                      Icons.settings,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    text: 'Settings',
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => SettingsPage())),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        await prefs.remove('jwt_token');
                        await prefs.remove('user_id');
                        await prefs.remove('username');
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MultiBlocProvider(
                                providers: [
                                  Provider<AuthService>(
                                    create: (context) => AuthService(),
                                  ),
                                  BlocProvider<AuthCubit>(
                                    create: (context) {
                                      final service =
                                          context.read<AuthService>();
                                      final repo = AuthRepository(service);
                                      return AuthCubit(repo);
                                    },
                                  ),
                                ],
                                child: LoginScreen(),
                              ),
                            ));
                      },
                      child: Center(
                        child: Text("Logout"),
                      ))
                ],
              ),
            ),
          ],
        ),
      ),
      body: _mainPages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.grey,
        unselectedItemColor: Colors.blueAccent,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/dashboard.svg', height: 24),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon:
                SvgPicture.asset('assets/vectors/vehicle_icon.svg', height: 24),
            label: "Vehicles",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/tire_inventory.svg',
                height: 24),
            label: "Tires",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/drivers.svg', height: 24),
            label: "Drivers",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset('assets/vectors/trips.svg', height: 24),
            label: "Trips",
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required Widget icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      leading: icon,
      title: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
