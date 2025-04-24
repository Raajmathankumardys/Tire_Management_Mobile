import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/cubit/tire_mapping_state.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/mappingscreen.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/screen/tire_performance_screen.dart';

import '../../../Tire-Performance/cubit/tire_performance_cubit.dart';
import '../../../Tire-Performance/repository/tire_performance_repository.dart';
import '../../../Tire-Performance/service/tire_performance_service.dart';
import '../../../Vehicle-Axle/cubit/vehicle_axle_cubit.dart';
import '../../../Vehicle-Axle/repository/vehicle_axle_repository.dart';
import '../../../Vehicle-Axle/service/vehicle_axle_cubit.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';
import '../../cubit/tire_mapping_cubit.dart';
import '../../repository/tire_mapping_repository.dart';
import '../../service/tire_mapping_service.dart';

class TirePerformanceTab extends StatelessWidget {
  final Vehicle vehicle;
  final List<GetTireMapping> getValue;
  const TirePerformanceTab(
      {super.key, required this.getValue, required this.vehicle});
  @override
  Widget build(BuildContext context) {
    final tireIds = getValue.map((e) => e.tireId).toSet().toList();
    return DefaultTabController(
      length: tireIds.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
          title: Center(
            child: Text(
              'Tire Performance',
              style: TextStyle(color: Colors.white),
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        Provider<TireMappingService>(
                          create: (context) => TireMappingService(),
                        ),
                        BlocProvider<TireMappingCubit>(
                          create: (context) {
                            final service = context.read<TireMappingService>();
                            final repo = TireMappingRepository(service);
                            return TireMappingCubit(repo)
                              ..fetchTireMapping(vehicle.id!);
                          },
                        ),
                        Provider<VehicleAxleService>(
                          create: (context) => VehicleAxleService(),
                        ),
                        BlocProvider<VehicleAxleCubit>(
                          create: (context) {
                            final service = context.read<VehicleAxleService>();
                            final repo = VehicleAxleRepository(service);
                            return VehicleAxleCubit(repo)
                              ..fetchVehicleAxles(vehicle.id!);
                          },
                        ),
                      ],
                      child: mappingscreen(
                        vehicle: vehicle,
                        index: 1,
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
          bottom: TabBar(
            isScrollable: true,
            tabs:
                getValue.map((id) => Tab(text: '${id.tirePosition}')).toList(),
          ),
        ),
        body: TabBarView(
          children: tireIds.map((tireId) {
            return BlocProvider(
              create: (context) {
                final service = context.read<TirePerformanceService>();
                final repo = TirePerformanceRepository(service);
                return TirePerformanceCubit(repo)..fetchTirePerformance(tireId);
              },
              child: Tire_Performance_Screen(id: tireId),
            );
          }).toList(),
        ),
      ),
    );
  }
}
