import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/service/tire_mapping_service.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/cubit/vehicle_axle_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/presentation/vehicle_tire_mapping.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/repository/vehicle_axle_repository.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/service/vehicle_axle_service.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/cubit/vehicle_category_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/screen/add_edit_modal_vehicle.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/mappingscreen.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/widget/vehiclewidget.dart';
import '../../../../Expense_Tracker/Trips/cubit/trips_cubit.dart';
import '../../../../Expense_Tracker/Trips/presentation/screen/trips_screen.dart';
import '../../../../Expense_Tracker/Trips/repository/trips_repository.dart';
import '../../../../Expense_Tracker/Trips/service/trips_service.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/themes/app_colors.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../../helpers/constants.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../../Tire-Inventory/repository/tire_inventory_repository.dart';
import '../../../Tire-Inventory/service/tire_inventory_service.dart';
import '../../../Tire-Mapping/cubit/tire_mapping_cubit.dart';
import '../../../Tire-Mapping/presentation/screen/AxleMapping.dart';
import '../../../Tire-Mapping/presentation/screen/carmapping.dart';
import '../../../Tire-Mapping/repository/tire_mapping_repository.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';
import '../../repository/vehicle_repository.dart';
import '../../service/vehicle_service.dart';

class vehiclescreen extends StatefulWidget {
  const vehiclescreen({super.key});
  @override
  State<vehiclescreen> createState() => _vehiclelistscreen_State();
}

class _vehiclelistscreen_State extends State<vehiclescreen> {
  late Future<List<Vehicle>> futureVehicles;
  TextEditingController _searchController = TextEditingController();
  List<Vehicle> _filteredVehicles = [];
  List<Vehicle> _allVehicles = [];
  void _showAddEditModal(BuildContext ctx, [Vehicle? vehicle]) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
            initialChildSize: 0.5.h, // Starts at of screen height
            minChildSize: 0.5.h, // Minimum height
            maxChildSize: 0.6.h,
            expand: false,
            builder: (context, scrollController) {
              return add_edit_modal_vehicle(ctx: ctx, vehicle: vehicle);
            });
      },
    );
  }

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    required content,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteConfirmationDialog(
        onConfirm: onConfirm,
        content: content,
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<VehicleCubit>().fetchVehicles();
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdark ? Colors.grey.shade900 : Colors.white70,
      // appBar: AppBar(
      //   title: Center(
      //       child: Text(vehicleconstants.appbar,
      //           style: TextStyle(
      //               fontWeight: FontWeight.bold, color: Colors.white))),
      //   backgroundColor: Colors.blueAccent,
      //   leading: Text(''),
      //   actions: [
      //     IconButton(
      //         onPressed: () => {_showAddEditModal(context)},
      //         icon: Icon(Icons.add_circle, color: Colors.white))
      //   ],
      // ),
      body: RefreshIndicator(
          child: BlocConsumer<VehicleCubit, VehicleState>(
            listener: (context, state) {
              if (state is AddedVehicleState ||
                  state is UpdatedVehicleState ||
                  state is DeletedVehicleState) {
                final message = (state as dynamic).message;
                String updatedMessage = message.toString();
                ToastHelper.showCustomToast(
                    context,
                    updatedMessage,
                    Colors.green,
                    (state is AddedVehicleState)
                        ? Icons.add
                        : (state is UpdatedVehicleState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is VehicleError) {
                String updatedMessage = state.message.toString();
                ToastHelper.showCustomToast(
                    context, updatedMessage, Colors.red, Icons.error);
              }
            },
            builder: (context, state) {
              if (state is VehicleLoading) {
                return shimmer();
              } else if (state is VehicleError) {
                String updatedMessage = state.message.toString();
                return Center(child: Text(updatedMessage));
              } else if (state is VehicleLoaded) {
                _allVehicles = state.vehicles;
                _filteredVehicles = _searchController.text.isEmpty
                    ? _allVehicles
                    : _allVehicles
                        .where((vehicle) => vehicle.vehicleNumber
                            .toLowerCase()
                            .contains(_searchController.text.toLowerCase()))
                        .toList();

                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(12.sp),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                labelText: 'Search by License Plate',
                                iconColor: Colors.blueAccent,
                                prefixIcon: Icon(Icons.search),
                                prefixIconColor: Colors.blueAccent,
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12.sp,
                                ),
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Colors.blueAccent),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _filteredVehicles = _allVehicles
                                      .where((vehicle) => vehicle.vehicleNumber
                                          .toLowerCase()
                                          .contains(value.toLowerCase()))
                                      .toList();
                                });
                              },
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        IconButton(
                            onPressed: () => {_showAddEditModal(context)},
                            icon: Icon(
                              Icons.add_circle,
                              size: 20,
                            ))
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            state.vehicles.isEmpty ? 1 : state.vehicles.length,
                        itemBuilder: (context, index) {
                          if (state.vehicles.isEmpty) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: Center(
                                  child: Text(vehicleconstants.novehicle)),
                            );
                          }

                          final vehicle = _filteredVehicles[index];
                          return Theme(
                              data: Theme.of(context)
                                  .copyWith(dividerColor: Colors.transparent),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 6.w),
                                child: CustomCard(
                                  color: isdark
                                      ? Colors.black54
                                      : Colors.grey
                                          .shade100, // Subtle background for light mode
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Theme(
                                    data: Theme.of(context).copyWith(
                                        dividerColor: Colors.transparent),
                                    child: ExpansionTile(
                                      tilePadding: EdgeInsets.symmetric(
                                          vertical: 12.h, horizontal: 16.w),
                                      title: vehiclewidget(vehicle: vehicle),
                                      childrenPadding: EdgeInsets.only(
                                          bottom: 12.h,
                                          left: 16.w,
                                          right: 16.w),
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiBlocProvider(
                                                            providers: [
                                                          // Provider<
                                                          //     TireMappingService>(
                                                          //   create: (_) =>
                                                          //       TireMappingService(),
                                                          // ),
                                                          // BlocProvider<
                                                          //     TireMappingCubit>(
                                                          //   create:
                                                          //       (context) {
                                                          //     final service =
                                                          //         context.read<
                                                          //             TireMappingService>();
                                                          //     final repo =
                                                          //         TireMappingRepository(
                                                          //             service);
                                                          //     return TireMappingCubit(
                                                          //         repo)
                                                          //       ..fetchTireMapping(
                                                          //           int.parse(
                                                          //               vehicle.id!));
                                                          //   },
                                                          // ),
                                                          Provider<
                                                              VehicleAxleService>(
                                                            create: (_) =>
                                                                VehicleAxleService(),
                                                          ),
                                                          BlocProvider<
                                                              VehicleAxleCubit>(
                                                            create: (context) {
                                                              final service =
                                                                  context.read<
                                                                      VehicleAxleService>();
                                                              final repo =
                                                                  VehicleAxleRepository(
                                                                      service);
                                                              return VehicleAxleCubit(
                                                                  repo)
                                                                ..fetchVehicleAxles(
                                                                    vehicle
                                                                        .id!);
                                                            },
                                                          ),
                                                          Provider<
                                                              TireInventoryService>(
                                                            create: (context) =>
                                                                TireInventoryService(),
                                                          ),
                                                          BlocProvider<
                                                                  TireInventoryCubit>(
                                                              create:
                                                                  (context) {
                                                            final tireInventoryService =
                                                                context.read<
                                                                    TireInventoryService>();
                                                            final tireInventoryRepository =
                                                                TireInventoryRepository(
                                                                    tireInventoryService);
                                                            return TireInventoryCubit(
                                                                tireInventoryRepository);
                                                          }),
                                                        ],
                                                            child: mappingscreen(
                                                                vehicle:
                                                                    vehicle)),
                                                  ),
                                                );
                                              },
                                              icon: SvgPicture.asset(
                                                'assets/vectors/tire_icon_2.svg',
                                                height: 20.h,
                                                color: isdark
                                                    ? Colors.grey
                                                    : Colors.black,
                                              ),
                                              style: IconButton.styleFrom(
                                                  backgroundColor: Colors.grey
                                                      .withOpacity(0.1)),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        MultiBlocProvider(
                                                      providers: [
                                                        Provider<
                                                            VehicleService>(
                                                          create: (context) =>
                                                              VehicleService(),
                                                        ),
                                                        BlocProvider<
                                                            VehicleCubit>(
                                                          create: (context) {
                                                            final vehicleService =
                                                                context.read<
                                                                    VehicleService>();
                                                            final vehicleRepository =
                                                                VehicleRepository(
                                                                    vehicleService);
                                                            return VehicleCubit(
                                                                vehicleRepository)
                                                              ..fetchVehicles();
                                                          },
                                                        ),
                                                        Provider<TripService>(
                                                          create: (_) =>
                                                              TripService(),
                                                        ),
                                                        BlocProvider<TripCubit>(
                                                          create: (context) {
                                                            final service =
                                                                context.read<
                                                                    TripService>();
                                                            final repo =
                                                                TripRepository(
                                                                    service);
                                                            return TripCubit(
                                                                repo)
                                                              ..fetchTrip(
                                                                  vehicleId:
                                                                      vehicle
                                                                          .id!);
                                                          },
                                                        ),
                                                      ],
                                                      child: TripsScreen(
                                                        vehicleId: vehicle.id!,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: SvgPicture.asset(
                                                'assets/vectors/trip_icon.svg',
                                                height: 25.h,
                                              ),
                                              style: IconButton.styleFrom(
                                                  backgroundColor: Colors.blue
                                                      .withOpacity(0.2)),
                                            ),
                                            IconButton(
                                              onPressed: () =>
                                                  _showAddEditModal(
                                                      context, vehicle),
                                              icon: FaIcon(Icons.edit,
                                                  color: Colors.green,
                                                  size: 20.h),
                                              style: IconButton.styleFrom(
                                                  backgroundColor: Colors.green
                                                      .withOpacity(0.1)),
                                            ),
                                            IconButton(
                                              onPressed: () async {
                                                await showDeleteConfirmationDialog(
                                                  context: context,
                                                  content: vehicleconstants
                                                      .modaldelete,
                                                  onConfirm: () {
                                                    context
                                                        .read<VehicleCubit>()
                                                        .deleteVehicle(vehicle,
                                                            vehicle.id!);
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                              style: IconButton.styleFrom(
                                                  backgroundColor: Colors.red
                                                      .withOpacity(0.1)),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                        },
                      ),
                    ),
                  ],
                );
              }
              return Center(child: Text(vehicleconstants.novehicle));
            },
          ),
          onRefresh: () async => {context.read<VehicleCubit>().fetchVehicles()},
          color: Colors.blueAccent),
    );
  }
}
