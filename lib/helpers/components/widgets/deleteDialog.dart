import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String content;
  final VoidCallback onConfirm;

  const DeleteConfirmationDialog({
    Key? key,
    required this.onConfirm,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      title: Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red, size: 20.sp),
          SizedBox(width: 6.h),
          Text(constants.confirmdelete,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: Text(
        content,
        style: TextStyle(fontSize: 12.h),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(constants.cancel,
              style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirm();
          },
          child: const Text(constants.delete,
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
