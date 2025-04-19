import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../helpers/constants.dart';
import '../../cubit/vehicle_state.dart';

class vehiclewidget extends StatelessWidget {
  final Vehicle vehicle;
  const vehiclewidget({super.key, required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: vehicle.axleNo <= 2
          ? FaIcon(Icons.directions_car_filled,
              size: 30.h, color: Colors.blueAccent)
          : FaIcon(FontAwesomeIcons.truckFront,
              size: 30.h, color: Colors.blueAccent),
      title: Text(vehicle.licensePlate,
          style: TextStyle(
            fontSize: 12.w,
            fontWeight: FontWeight.bold,
          )),
      subtitle: Text(
          '${vehicleconstants.vname + ": " + vehicle.name} | ${vehicleconstants.type + ": " + vehicle.type} | ${vehicleconstants.year}: ${vehicle.manufactureYear}',
          style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
    );
  }
}
