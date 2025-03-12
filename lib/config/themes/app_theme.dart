import 'package:flutter/material.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';

class Apptheme {
  static final lightTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Colors.white,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        )),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
  static final darkTheme = ThemeData(
    primaryColor: AppColors.primaryColor,
    appBarTheme: AppBarTheme(
        color: Colors.white,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 20,
          color: Colors.blueAccent,
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryColor,
        actionsIconTheme: const IconThemeData(
          color: Colors.white,
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        )),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
      ),
    ),
  );
}
