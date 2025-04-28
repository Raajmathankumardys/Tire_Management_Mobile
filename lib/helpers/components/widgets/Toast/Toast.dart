import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showCustomToast(
      BuildContext context, String message, Color color, IconData icons) {
    FToast fToast = FToast();
    fToast.init(context);

    final textColor = Colors.black;

    Widget toast = Container(
      padding: EdgeInsets.all(8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        color: color,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.h,
            spreadRadius: 1.h,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icons, color: textColor, size: 10.h),
          SizedBox(width: 4.w),
          Container(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 10.h,
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: const Duration(seconds: 2),
    );
  }
}
