import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'arrow_painter.dart';

class BreakdownDonutChart extends StatelessWidget {
  final Map<String, double> breakdown;

  const BreakdownDonutChart({super.key, required this.breakdown});

  Color _getColor(String category) {
    final colors = {
      "FUEL": Colors.blueAccent,
      "DRIVER_ALLOWANCE": Colors.green,
      "TOLL": Colors.orange,
      "MAINTENANCE": Colors.redAccent,
      "MISCELLANEOUS": Colors.purple,
    };
    return colors[category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 140.w, // Adjust width for responsiveness
          height: 190.h,
          padding: EdgeInsets.all(12.h),
          child: PieChart(
            PieChartData(
              sections: breakdown.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  color: _getColor(entry.key),
                  radius: 40.r, // Adjusts segment size
                  showTitle: false, // Removes text inside pie chart
                );
              }).toList(),
              sectionsSpace: 2.r,
              centerSpaceRadius: 30.r,
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:
              breakdown.entries.where((entry) => entry.value > 0).map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: _getColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    entry.key.toUpperCase(),
                    style:
                        TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.w),
                  CustomPaint(
                    painter: ArrowPainter(),
                    child: SizedBox(width: 13.w),
                  ),
                  Text(
                    "₹ " + entry.value.toInt().toString(),
                    style:
                        TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
