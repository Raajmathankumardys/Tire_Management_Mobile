import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';

class VehicleInfoCard extends StatelessWidget {
  final Vehicle vehicle;
  const VehicleInfoCard({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Card(
      color: isdark ? Colors.black : Colors.grey.shade200,
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Vehicle Icon
            Center(
              child: FaIcon(
                vehicle.axleNo <= 2
                    ? FontAwesomeIcons.carSide
                    : FontAwesomeIcons.truckMoving,
                size: 60.sp,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(height: 20.h),

            // License Plate
            Text(
              "LICENSE PLATE",
              style: TextStyle(
                fontSize: 13.sp,
                letterSpacing: 1,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              vehicle.licensePlate,
              style: TextStyle(
                fontSize: 22.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(height: 30.h, thickness: 1.2, color: Colors.grey),

            // Info Rows
            _buildDetailRow(
                vehicle.axleNo <= 2
                    ? FontAwesomeIcons.carTunnel
                    : FontAwesomeIcons.truckPickup,
                "Name",
                vehicle.name,
                isdark),
            _buildDetailRow(Icons.category, "Type", vehicle.type, isdark),
            _buildDetailRow(Icons.calendar_today_rounded, "Year",
                vehicle.manufactureYear.toString(), isdark),
            _buildDetailRow(Icons.settings_input_composite, "Axle Count",
                vehicle.axleNo.toString(), isdark),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(
      IconData icon, String title, String value, bool isdark) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: isdark ? Colors.black : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20.sp, color: Colors.blue.shade600),
          SizedBox(width: 10.w),
          Text(
            "$title: ",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
