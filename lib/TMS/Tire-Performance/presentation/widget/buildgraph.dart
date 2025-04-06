import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/widget/tire_graph.dart';

import '../../cubit/tire_performance_state.dart';

class buildgraph extends StatelessWidget {
  List<TirePerformance> tirePerformances;
  final String title;
  final String parameter;
  final ThemeData theme;
  buildgraph(
      {super.key,
      required this.tirePerformances,
      required this.title,
      required this.parameter,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        padding: EdgeInsets.all(24.h),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12.r),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.r,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 210.h,
              child: Chart(
                  tirePerformances: tirePerformances, parameter: parameter),
            ),
          ],
        ),
      ),
    );
  }
}
