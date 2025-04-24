import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/presentation/screen/tire_inventory_screen.dart';
import 'package:yaantrac_app/TMS/presentation/screen/settings.dart';
import '../../Vehicle/presentation/screen/vehicle_screen.dart';
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
    TireInventoryScreen(),
    NotificationScreen(),
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
    return Scaffold(
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
        height: 40.h,
        index: _currentIndex, // Ensuring correct tab selection
        items: [
          SvgPicture.asset(
            'assets/vectors/vehicle_icon.svg',
            height: 30.sp,
          ),
          SvgPicture.asset(
            'assets/vectors/tire_inventory.svg',
            height: 30.sp,
          ),
          Icon(Icons.notifications, size: 25.sp, color: Colors.blueAccent),
          Icon(Icons.settings, size: 25.sp, color: Colors.blueAccent),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _bottomNavigationKey = GlobalKey(); // Forces widget to rebuild
          });
        },
      ),
    );
  }
}
