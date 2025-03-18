import 'package:flutter/material.dart';

import '../../../config/themes/app_colors.dart';

class AppPrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final double? height;
  final double? width;

  const AppPrimaryButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final textColor = theme.colorScheme.onPrimary;

    return SizedBox(
      height: height ?? 50,
      width: width,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Text(
          title,
          style: theme.textTheme.labelLarge?.copyWith(color: textColor),
        ),
      ),
    );
  }
}
