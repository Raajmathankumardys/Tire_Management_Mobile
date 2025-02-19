import 'package:flutter/material.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double ? height; // optional
  final double ? width;

  const AppPrimaryButton({super.key, required this.onPressed, required this.title, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: (){},
        style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(height ?? 50),
          backgroundColor: AppColors.primaryColor,
        ),
        child:Text(title,style: const TextStyle(
          color: Colors.white
        ),),
    );
  }
}
