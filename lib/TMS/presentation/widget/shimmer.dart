import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class shimmer extends StatefulWidget {
  final int? count;
  const shimmer({super.key, this.count});

  @override
  State<shimmer> createState() => _shimmerState();
}

class _shimmerState extends State<shimmer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(widget.count ?? 9, (index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.h),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: double.infinity,
              height: 50.h,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r)),
            ),
          ),
        );
      }),
    );
  }
}
