import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/AxleMapping.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/carmapping.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/vehicle_details.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/presentation/vehicle_tire_mapping.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../../../../commonScreen/Homepage.dart';
import '../../../../helpers/components/themes/app_colors.dart';
import '../../../Vehicle/cubit/vehicle_cubit.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';
import '../../../Vehicle/repository/vehicle_repository.dart';
import '../../../Vehicle/service/vehicle_service.dart';

class mappingscreen extends StatefulWidget {
  final int index;
  final Vehicle vehicle;
  const mappingscreen({super.key, required this.vehicle, this.index = 0});

  @override
  State<mappingscreen> createState() => _mappingscreenState();
}

class _mappingscreenState extends State<mappingscreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        initialIndex: widget.index,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: AppColors.secondaryColor,
            title: Center(
              child: Text(
                tiremappingconstants.mappingappbar,
                style: TextStyle(color: Colors.white),
              ),
            ),
            leading: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MultiBlocProvider(providers: [
                        Provider<VehicleService>(
                          create: (context) => VehicleService(),
                        ),
                        BlocProvider<VehicleCubit>(
                          create: (context) {
                            final vehicleService =
                                context.read<VehicleService>();
                            final vehicleRepository =
                                VehicleRepository(vehicleService);
                            return VehicleCubit(vehicleRepository)
                              ..fetchVehicles();
                          },
                        ),
                      ], child: HomeScreen()),
                    ),
                  );
                },
                icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // Circle with truck icon
                    CircleAvatar(
                        radius: 28,
                        child: FaIcon(FontAwesomeIcons.car,
                            size: 30, color: Colors.blueAccent)
                        /* : FaIcon(FontAwesomeIcons.truckFront,
                              size: 30, color: Colors.blueAccent),*/
                        ),
                    SizedBox(width: 16),
                    // License info
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tiremappingconstants.vehicledetailslicenseno,
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 12),
                        ),
                        Text(
                          widget.vehicle
                              .vehicleNumber, // Replace with your vehicle number
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              TabBar(
                tabs: [
                  Tab(text: tiremappingconstants.vehicledetails),
                  Tab(text: "Tire-Mapping"),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    VehicleInfoCard(vehicle: widget.vehicle),
                    // widget.vehicle.id == 136
                    //     ? CarMappingScreen(
                    //         vehicleId: int.parse(widget.vehicle.id!),
                    //         vehicle: widget.vehicle,
                    //       )
                    //     :
                    VehicleTireMapping(
                        vehicleId: widget.vehicle.id!, vehicle: widget.vehicle),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
