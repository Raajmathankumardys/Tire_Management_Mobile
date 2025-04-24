import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InfoCard extends StatefulWidget {
  final IconData icon;
  final String value;
  final Color iconcolor;
  const InfoCard({
    super.key,
    required this.icon,
    required this.value,
    required this.iconcolor,
  });

  @override
  State<InfoCard> createState() => _buildInfoCardState();
}

class _buildInfoCardState extends State<InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(1.h),
            decoration: BoxDecoration(
              color: widget.iconcolor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Icon(widget.icon, size: 14.h, color: widget.iconcolor),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              widget.value,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
