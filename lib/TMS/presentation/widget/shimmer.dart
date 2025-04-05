import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

import '../../../config/themes/app_colors.dart';

class shimmer extends StatefulWidget {
  final int? count;
  const shimmer({super.key, this.count});

  @override
  State<shimmer> createState() => _shimmerState();
}

class _shimmerState extends State<shimmer> {
  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: List.generate(widget.count ?? 9, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.h),
          child: Shimmer.fromColors(
            baseColor: isdark ? Colors.grey[900]! : Colors.grey[300]!,
            highlightColor:
                !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        );
      }),
    );
  }
}
