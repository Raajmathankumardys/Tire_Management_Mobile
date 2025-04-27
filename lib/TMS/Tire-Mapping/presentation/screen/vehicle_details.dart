import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';

class VehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleInfoCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      child: Card(
        color: isdark ? Colors.grey.shade900 : Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        elevation: 10,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 28.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Vehicle Icon
              Center(
                child: FaIcon(
                  vehicle.axleNo <= 2
                      ? FontAwesomeIcons.carSide
                      : FontAwesomeIcons.truckMoving,
                  size: 65.sp,
                  color: Colors.indigo,
                ),
              ),
              SizedBox(height: 22.h),

              // License Plate
              Text(
                "LICENSE PLATE",
                style: TextStyle(
                  fontSize: 14.sp,
                  letterSpacing: 2,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'RobotoMono',
                ),
              ),
              SizedBox(height: 6.h),
              Text(
                vehicle.licensePlate,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                  fontFamily: 'Poppins',
                ),
              ),
              Divider(
                height: 35.h,
                thickness: 1.5,
                color: Colors.grey.shade400,
                indent: 30.w,
                endIndent: 30.w,
              ),

              // Info Rows
              _buildDetailRow(
                  FaIcon(
                    vehicle.axleNo <= 2
                        ? FontAwesomeIcons.carTunnel
                        : FontAwesomeIcons.truckPickup,
                    size: 24.0,
                    color: Colors.blue.shade600,
                  ),
                  "Name",
                  vehicle.name,
                  isdark),
              _buildDetailRow(
                  Icon(Icons.category,
                      size: 24.sp, color: Colors.blue.shade700),
                  "Type",
                  vehicle.type,
                  isdark),
              _buildDetailRow(
                  Icon(Icons.calendar_today_rounded,
                      size: 24.sp, color: Colors.blue.shade700),
                  "Year",
                  vehicle.manufactureYear.toString(),
                  isdark),
              _buildDetailRow(
                  SvgPicture.asset(
                    'assets/vectors/T_i.svg',
                    width: 24.sp,
                    height: 24.sp,
                    color: Colors.blue.shade600,
                  ),
                  "Axle Count",
                  vehicle.axleNo.toString(),
                  isdark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(Widget icon, String title, String value, bool isdark) {
    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isdark ? Colors.grey.shade800 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Row(
        children: [
          icon,
          SizedBox(width: 14.w),
          Text(
            "$title:",
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'OpenSans',
              color: isdark ? Colors.white70 : Colors.black87,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'OpenSans',
                color: isdark ? Colors.white : Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
