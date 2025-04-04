import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/presentation/tire_inventory_screen.dart';

import 'package:yaantrac_app/screens/AxleMapping.dart';
import 'package:yaantrac_app/screens/filter_expense_screen.dart';
import 'package:yaantrac_app/screens/settings.dart';
import 'package:yaantrac_app/screens/tiremapping.dart';

import '../TMS/Vehicle/presentation/screen/vehicle_screen.dart';
import '../TMS/presentation/screen/tire_list_screen.dart';
import '../TMS/presentation/screen/vehicle_list_screen.dart';
import 'vehicles_list_screen.dart';
import 'tires_list_screen.dart';
import 'notification_screen.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;

  const HomeScreen({Key? key, this.currentIndex = 0}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentIndex;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    vehiclescreen(),
    //vehiclelistscreen_(),
    //VehiclesListScreen(),
    TireInventoryScreen(),
    //TiresListScreen(),
    TirePressureScreen(),
    //NotificationScreen(),
    //FilterExpenseScreen(),
    SettingsPage(),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey, // Added key to force update
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.grey[800]!,
        color: Theme.of(context).brightness == Brightness.dark
            ? Colors.grey[800]!
            : Colors.white,
        animationDuration: Duration(milliseconds: 300),
        height: 45.h,
        index: _currentIndex, // Ensuring correct tab selection
        items: [
          Icon(Icons.directions_car, size: 30.sp, color: Colors.blueAccent),
          Icon(Icons.tire_repair, size: 30.sp, color: Colors.blueAccent),
          Icon(Icons.notifications, size: 30.sp, color: Colors.blueAccent),
          Icon(Icons.settings, size: 30.sp, color: Colors.blueAccent),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _bottomNavigationKey = GlobalKey(); // Forces widget to rebuild
          });
        },
      ),
    ));
  }
}
