import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/vehicle_state.dart';

class vehiclewidget extends StatelessWidget {
  final Vehicle vehicle;
  const vehiclewidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.directions_car_filled,
              size: 24.h,
              color: Colors.white,
            )
            // : FaIcon(FontAwesomeIcons.truckFront,
            //     size: 20.h, color: Colors.white),
            ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.vehicleNumber,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                '${vehicleconstants.vname}: ${vehicle.policyNumber} | '
                '${vehicleconstants.type}: ${vehicle.freewaySpeedLimit} | '
                '${vehicleconstants.year}: ${vehicle.freewaySpeedLimit} | '
                'Model :${vehicle.vehicleModel} | '
                'Make :${vehicle.vehicleMake} | '
                'Fleet No. :${vehicle.nonFreewaySpeedLimit}',
                style: TextStyle(
                  fontSize: 11.sp,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
