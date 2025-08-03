import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Maintenance-Logs/presentation/add_edit_maintenance_log.dart';
import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/button/action_button.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';
import '../../../helpers/constants.dart';
import '../cubit/maintenance_log_cubit.dart';
import '../cubit/maintenance_logs_state.dart';
import '../../Vehicle/cubit/vehicle_cubit.dart';
import '../../Vehicle/cubit/vehicle_state.dart';

class maintenancelogscreen extends StatefulWidget {
  const maintenancelogscreen({super.key});
  @override
  State<maintenancelogscreen> createState() =>
      _maintenanceloglistscreen_State();
}

class _maintenanceloglistscreen_State extends State<maintenancelogscreen> {
  // late Future<List<Vehicle>> futureVehicles;
  // TextEditingController _searchController = TextEditingController();
  // List<Vehicle> _filteredVehicles = [];
  List<Vehicle> _allVehicles = [];
  bool isload = false;

  void _showAddEditModal(BuildContext ctx, [MaintenanceLog? m]) {
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
              return AddEditMaintenanceLog(ctx: ctx, maintenancelog: m);
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
            child: Text("Maintenance Logs",
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
          child: BlocConsumer<MaintenanceLogCubit, MaintenanceLogState>(
            listener: (context, state) {
              if (state is AddedMaintenanceLogState ||
                  state is UpdatedMaintenanceLogState ||
                  state is DeletedMaintenanceLogState) {
                final message = (state as dynamic).message;
                String updatedMessage = message.toString();
                ToastHelper.showCustomToast(
                    context,
                    updatedMessage,
                    Colors.green,
                    (state is AddedMaintenanceLogState)
                        ? Icons.add
                        : (state is UpdatedMaintenanceLogState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is MaintenanceLogError) {
                String updatedMessage = state.message.toString();
                ToastHelper.showCustomToast(
                    context, updatedMessage, Colors.red, Icons.error);
              }
            },
            builder: (context, state) {
              if (state is MaintenanceLogLoading) {
                return shimmer();
              } else if (state is MaintenanceLogError) {
                String updatedMessage = state.message.toString();
                return Center(child: Text(updatedMessage));
              } else if (state is MaintenanceLogLoaded) {
                final maintenancelog = state.maintenancelog;
                return ListView.builder(
                  itemCount: state.maintenancelog.isEmpty
                      ? 1
                      : state.maintenancelog.length,
                  itemBuilder: (context, index) {
                    if (state.maintenancelog.isEmpty) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height * 0.8,
                        child: Center(child: Text("No Logs Available")),
                      );
                    }
                    final maintenancelogs = maintenancelog[index];
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
                                    (t) => t.id == maintenancelogs.vehicleId,
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
                                          // tirePositions: {},
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
                                  "Type: ${maintenancelogs.type.toString().split('.').last}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text("Date: ${maintenancelogs.date}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text(
                                  "Description: ${maintenancelogs.description}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text("Cost : ${maintenancelogs.cost.toString()}",
                                  style: TextStyle(
                                    color: Colors.grey.shade500,
                                    fontSize: 10.sp,
                                  )),
                              Text(
                                  "Completed: ${maintenancelogs.completed.toString()}",
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
                                            context, maintenancelogs)
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
                                          .read<MaintenanceLogCubit>()
                                          .deleteMaintenanceLog(maintenancelogs,
                                              maintenancelogs.id!);
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
                context.read<MaintenanceLogCubit>().fetchMaintenanceLogs(),
                fetchVehicle()
              },
          color: Colors.blueAccent),
    );
  }
}
