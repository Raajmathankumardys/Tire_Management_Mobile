import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class add_edit_modal_top extends StatelessWidget {
  final String title;
  const add_edit_modal_top({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 40.h,
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.r)),
      ),
      child: Column(
        children: [
          SizedBox(height: 5.h),
          Container(
            width: 80,
            height: 5.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 12.h,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
