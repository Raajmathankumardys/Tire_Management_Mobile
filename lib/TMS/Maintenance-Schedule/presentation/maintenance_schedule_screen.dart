import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/button/action_button.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';
import '../../../helpers/constants.dart';
import '../../Vehicle/cubit/vehicle_cubit.dart';
import '../../Vehicle/cubit/vehicle_state.dart';
import '../cubit/maintenance_schedule_cubit.dart';
import '../cubit/maintenance_schedule_state.dart';
import 'add_edit_maintenance_schedule.dart';

class maintenanceschedulescreen extends StatefulWidget {
  const maintenanceschedulescreen({super.key});
  @override
  State<maintenanceschedulescreen> createState() =>
      _maintenanceschedulelistscreen_State();
}

class _maintenanceschedulelistscreen_State
    extends State<maintenanceschedulescreen> {
  List<Vehicle> _allVehicles = [];
  bool isload = false;

  void _showAddEditModal(BuildContext ctx, [MaintenanceSchedule? m]) {
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
              return AddEditMaintenanceSchedule(
                  ctx: ctx, maintenanceSchedule: m);
            });
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVehicle();
  }

  Future<void> fetchVehicle() async {
    setState(() {
      isload = true;
    });
    final state = await context.read<VehicleCubit>().state;
    if (state is! VehicleLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchVehicle(); // Try again until loaded
      return;
    }
    setState(() {
      _allVehicles = state.vehicles;
      isload = false;
    });
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
      backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        title: Center(
            child: Text("Maintenance Schedule",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white))),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () => {_showAddEditModal(context)},
              icon: Icon(Icons.add_circle, color: Colors.white))
        ],
      ),
      body: RefreshIndicator(
          child:
              BlocConsumer<MaintenanceScheduleCubit, MaintenanceScheduleState>(
            listener: (context, state) {
              if (state is AddedMaintenanceScheduleState ||
                  state is UpdatedMaintenanceScheduleState ||
                  state is DeletedMaintenanceScheduleState) {
                final message = (state as dynamic).message;
                String updatedMessage = message.toString();
                ToastHelper.showCustomToast(
                    context,
                    updatedMessage,
                    Colors.green,
                    (state is AddedMaintenanceScheduleState)
                        ? Icons.add
                        : (state is UpdatedMaintenanceScheduleState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is MaintenanceScheduleError) {
                String updatedMessage = state.message.toString();
                ToastHelper.showCustomToast(
                    context, updatedMessage, Colors.red, Icons.error);
              }
            },
            builder: (context, state) {
              if (state is MaintenanceScheduleLoading) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.sp),
                  child: shimmer(),
                );
              } else if (state is MaintenanceScheduleError) {
                String updatedMessage = state.message.toString();
                return Center(child: Text(updatedMessage));
              } else if (state is MaintenanceScheduleLoaded) {
                final maintenanceSchedule = state.maintenanceschedule;
                return ListView.builder(
                  itemCount: state.maintenanceschedule.isEmpty
                      ? 1
                      : state.maintenanceschedule.length,
                  itemBuilder: (context, index) {
                    if (state.maintenanceschedule.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: Text("No Schedules Available")),
                      );
                    }
                    final maintenancschedules = maintenanceSchedule[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                      child: CustomCard(
                        color: isdark
                            ? Colors.black
                            : Colors.grey
                                .shade100, // Light neutral for better contrast
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.h),
                          leading: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(10.r)),
                            padding: EdgeInsets.all(8.h),
                            child: SvgPicture.asset(
                              tireinventoryconstants.tireicon,
                              height: 30.h,
                              color: isdark ? Colors.white : Colors.black,
                            ),
                          ),
                          title: Text(
                            _allVehicles
                                .firstWhere(
                                    (t) =>
                                        t.id == maintenancschedules.vehicleId,
                                    orElse: () => Vehicle(
                                          id: "",
                                          dotInspectionDate: 0,
                                          overSpeedLimit: 0.0,
                                          freewaySpeedLimit: 0.0,
                                          fuelCapacity: 0.0,
                                          fuelType: "unknown",
                                          insuranceExpiryDate: 0,
                                          insuranceName: "",
                                          lastServicedDate: 0,
                                          nonFreewaySpeedLimit: 0.0,
                                          policyNumber: "",
                                          registeredState: "",
                                          vehicleChassisNumber: "",
                                          vehicleColor: "",
                                          vehicleEngineNumber: "",
                                          vehicleExpirationDate: 0,
                                          vehicleFitness: "",
                                          fitnessExpireDate: 0,
                                          vehicleInsurance: "",
                                          vehicleMake: "",
                                          vehicleModel: "",
                                          vehicleNumber: "unknown",
                                          rcExpireDate: 0,
                                          vehicleRc: "",
                                          vehicleRegistrationDate: 0,
                                          vehicleIdentificationNumber: "",
                                          yearOfPurchase: 0,
                                          vehicleTypeId: "",
                                          vehicleCategoryId: "",
                                          currentOdometer: 0,
                                          //tirePositions: {},
                                          lastMaintenanceDate: 0,
                                          nextMaintenanceDate: 0,
                                        ))!
                                .vehicleNumber,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Type: ${maintenancschedules.type.toString().split('.').last}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text("Date: ${maintenancschedules.scheduledDate}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text(
                                  "Description: ${maintenancschedules.description}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text("Status : ${maintenancschedules.status}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text("Notes : ${maintenancschedules.notes}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 5.h,
                            children: [
                              ActionButton(
                                  icon: Icons.edit,
                                  color: Colors
                                      .green, // more aesthetic than default green
                                  onPressed: () => {
                                        _showAddEditModal(
                                            context, maintenancschedules)
                                      }),
                              ActionButton(
                                icon: Icons.delete_outline,
                                color: Colors.redAccent,
                                onPressed: () async {
                                  await showDeleteConfirmationDialog(
                                    context: context,
                                    content:
                                        "Are you sure you want to delete this log?",
                                    onConfirm: () {
                                      context
                                          .read<MaintenanceScheduleCubit>()
                                          .deleteMaintenanceSchedule(
                                              maintenancschedules,
                                              maintenancschedules.id!);
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: Text("No Logs Found"));
            },
          ),
          onRefresh: () async => {
                context
                    .read<MaintenanceScheduleCubit>()
                    .fetchMaintenanceSchedule(),
                fetchVehicle()
              },
          color: Colors.blueAccent),
    );
  }
}
