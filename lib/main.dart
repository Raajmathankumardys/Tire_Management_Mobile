import 'package:flutter/material.dart';
import 'package:yaantrac_app/config/themes/app_theme.dart';
import 'package:yaantrac_app/screens/add_expense_screen.dart';
import 'package:yaantrac_app/screens/add_tire_screen.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/filter_expense_screen.dart';
import 'package:yaantrac_app/screens/notification_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import "package:flutter_dotenv/flutter_dotenv.dart";

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  print("Base URL: ${dotenv.env["BASE_URL"]}");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: Apptheme.darkTheme,
      //home:const AddTireScreen(),
      // home: const TiresListScreen(),
      home: const VehiclesListScreen(),
      // home: const AddExpenseScreen(),
      //home:const FilterExpenseScreen(),
      // home:const ExpenseScreen(),
      //home:const NotificationScreen(),
      //home:const TireStatusScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
