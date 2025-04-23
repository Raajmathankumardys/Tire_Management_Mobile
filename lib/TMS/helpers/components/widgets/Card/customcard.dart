import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomCard extends StatelessWidget {
  final Widget child;
  final Color? color;
  final ShapeBorder? shape;
  const CustomCard({super.key, required this.child, this.color, this.shape});

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 2.w,
        color: color,
        shape: shape ??
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
        child: child);
  }
}
