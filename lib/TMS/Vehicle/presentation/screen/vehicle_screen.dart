import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/AxleMapping.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/carmapping.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/service/tire_mapping_service.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/cubit/vehicle_axle_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/repository/vehicle_axle_repository.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/service/vehicle_axle_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/screen/add_edit_modal_vehicle.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/widget/vehiclewidget.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../../../../models/trip.dart';
import '../../../../models/trip_list_screen.dart';
import '../../../Tire-Mapping/cubit/tire_mapping_cubit.dart';
import '../../../Tire-Mapping/repository/tire_mapping_repository.dart';
import '../../../cubit/base_cubit.dart';
import '../../../helpers/components/themes/app_colors.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';
import '../../../repository/base_repository.dart';
import '../../../service/base_service.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';

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
            initialChildSize: 0.6.h, // Starts at of screen height
            minChildSize: 0.6.h, // Minimum height
            maxChildSize: 0.7.h,
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
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(vehicleconstants.appbar,
                style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: isdark ? AppColors.darkappbar : AppColors.lightappbar,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
            )),
        actions: [
          IconButton(
              onPressed: () => {_showAddEditModal(context)},
              icon: Icon(
                Icons.add_circle,
                color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
              ))
        ],
      ),
      body: BlocConsumer<VehicleCubit, VehicleState>(
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
                    .where((vehicle) => vehicle.licensePlate
                        .toLowerCase()
                        .contains(_searchController.text.toLowerCase()))
                    .toList();

            return Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(12.sp),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search by License No.',
                      iconColor: Colors.blueAccent,
                      prefixIcon: Icon(Icons.search),
                      prefixIconColor: Colors.blueAccent,
                      labelStyle: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                      ),
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(color: Colors.blueAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blueAccent),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _filteredVehicles = _allVehicles
                            .where((vehicle) => vehicle.licensePlate
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                _filteredVehicles.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text("No vehicles found."),
                      )
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _filteredVehicles.length,
                          padding: EdgeInsets.all(4.h),
                          itemBuilder: (context, index) {
                            final vehicle = _filteredVehicles[index];
                            return Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.transparent),
                                child: CustomCard(
                                  child: ExpansionTile(
                                    tilePadding: EdgeInsets.all(2.h),
                                    title: vehiclewidget(vehicle: vehicle),
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 20.w),
                                        child: Row(
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
                                                        Provider<
                                                            TireMappingService>(
                                                          create: (context) =>
                                                              TireMappingService(),
                                                        ),
                                                        BlocProvider<
                                                            TireMappingCubit>(
                                                          create: (context) {
                                                            final service =
                                                                context.read<
                                                                    TireMappingService>();
                                                            final repo =
                                                                TireMappingRepository(
                                                                    service);
                                                            return TireMappingCubit(
                                                                repo)
                                                              ..fetchTireMapping(
                                                                  vehicle.id!);
                                                          },
                                                        ),
                                                        Provider<
                                                            VehicleAxleService>(
                                                          create: (context) =>
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
                                                                  vehicle.id!);
                                                          },
                                                        ),
                                                      ],
                                                      child: vehicle.id == 102
                                                          ? CarMappingScreen(
                                                              vehicleId:
                                                                  vehicle.id!)
                                                          : AxleConfiguration(
                                                              vehicleId:
                                                                  vehicle.id!),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(
                                                Icons.tire_repair_outlined,
                                                color: Colors.grey,
                                                size: 20.h,
                                              ),
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        BlocProvider(
                                                      create: (context) =>
                                                          BaseCubit<Trip>(
                                                        BaseRepository<Trip>(
                                                          BaseService<Trip>(
                                                            baseUrl: "/trips",
                                                            fromJson:
                                                                Trip.fromJson,
                                                            toJson: (trip) =>
                                                                trip.toJson(),
                                                          ),
                                                        ),
                                                      )..fetchItems(),
                                                      child: tripslistscreen(
                                                          vehicleid:
                                                              vehicle.id!),
                                                    ),
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.tour_outlined),
                                              color: Colors.purpleAccent,
                                              iconSize: 20.h,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                _showAddEditModal(
                                                    context, vehicle);
                                              },
                                              icon: const FaIcon(Icons.edit),
                                              color: Colors.green,
                                              iconSize: 20.h,
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
                                              icon: const FaIcon(
                                                  FontAwesomeIcons.trash),
                                              color: Colors.red,
                                              iconSize: 15.h,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
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
    );
  }
}
