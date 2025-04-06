import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../presentation/constants.dart';
import '../../cubit/vehicle_state.dart';

class vehiclewidget extends StatelessWidget {
  final Vehicle vehicle;
  const vehiclewidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.directions_car, size: 30.h, color: Colors.blueAccent),
      title: Text(vehicle.name + " " + vehicle.type,
          style: TextStyle(
            fontSize: 12.w,
            fontWeight: FontWeight.bold,
          )),
      subtitle: Text(
          '${vehicleconstants.license}: ${vehicle.licensePlate}  ${vehicleconstants.year}: ${vehicle.manufactureYear}',
          style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
    );
  }
}
