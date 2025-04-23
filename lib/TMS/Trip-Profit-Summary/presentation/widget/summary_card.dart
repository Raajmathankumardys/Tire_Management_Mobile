import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final bool theme;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.r), // Increased for a softer look
      ),
      color: theme ? Colors.grey[850] : Colors.white,
      elevation: 2.h, // Adds a shadow for depth
      shadowColor: Colors.black26, // Softer shadow effect
      child: Container(
        padding: EdgeInsets.all(12.h),
        height: 80.h, // Slightly increased for better spacing
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10.h, // Increased for better readability
                fontWeight: FontWeight.bold, // Stronger emphasis
                color: theme ? Colors.white : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              amount,
              style: TextStyle(
                fontSize: 12.h, // Slightly larger for better visibility
                fontWeight: FontWeight.w600,
                color: Colors.blueAccent, // A pop of color
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
