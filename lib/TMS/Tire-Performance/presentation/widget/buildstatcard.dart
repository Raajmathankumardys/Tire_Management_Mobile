import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../presentation/customcard.dart';
import '../../cubit/tire_performance_state.dart';

class buildstatcard extends StatelessWidget {
  final List<TirePerformance> tire;
  final String title;
  final ThemeData theme;
  const buildstatcard(
      {super.key,
      required this.tire,
      required this.title,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }
}
