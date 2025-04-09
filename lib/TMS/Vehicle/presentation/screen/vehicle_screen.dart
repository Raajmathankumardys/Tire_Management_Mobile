import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/screen/add_edit_modal_vehicle.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/widget/vehiclewidget.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../../../../models/trip.dart';
import '../../../../models/trip_list_screen.dart';
import '../../../../screens/tiremapping.dart';
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
  late int vehicleId;
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
        return add_edit_modal_vehicle(ctx: ctx, vehicle: vehicle);
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
            return ListView.builder(
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = state.vehicles[index];
                return CustomCard(
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(2.h),
                    onExpansionChanged: (value) {
                      setState(() {
                        vehicleId = vehicle.id!;
                      });
                    },
                    title: vehiclewidget(vehicle: vehicle),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AxleAnimationPage(
                                                vehicleid: vehicle.id!,
                                              )));
                                },
                                icon: Icon(
                                  Icons.tire_repair_outlined,
                                  color: Colors.grey,
                                  size: 20.h,
                                )),
                            IconButton(
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                       builder: (context) => tripslistscreen(
                                              vehicleid: vehicle.id!,
                                            )));*/
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => BaseCubit<Trip>(
                                        BaseRepository<Trip>(
                                          BaseService<Trip>(
                                            // "/vehicles/${vehicle.id!}/trips",
                                            baseUrl: "/trips",
                                            fromJson: Trip.fromJson,
                                            toJson: (trip) => trip.toJson(),
                                          ),
                                        ),
                                      )..fetchItems(),
                                      child: tripslistscreen(
                                          vehicleid: vehicle.id!),
                                    ),
                                  ),
                                );
                              },
                              icon: Icon(Icons.tour),
                              color: Colors.cyanAccent,
                              iconSize: 20.h,
                            ),
                            IconButton(
                              onPressed: () {
                                _showAddEditModal(context, vehicle);
                              },
                              icon: const FaIcon(Icons.edit),
                              color: Colors.green,
                              iconSize: 20.h,
                            ),
                            IconButton(
                                onPressed: () async => {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content: vehicleconstants.modaldelete,
                                        onConfirm: () {
                                          context
                                              .read<VehicleCubit>()
                                              .deleteVehicle(
                                                  vehicle, vehicleId);
                                        },
                                      )
                                    },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                                iconSize: 15.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text(vehicleconstants.novehicle));
        },
      ),
    );
  }
}
