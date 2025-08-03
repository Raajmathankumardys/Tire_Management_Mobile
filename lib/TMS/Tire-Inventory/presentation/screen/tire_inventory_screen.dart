import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/themes/app_colors.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../../helpers/constants.dart';
import '../../../Tire-Performance/cubit/tire_performance_cubit.dart';
import '../../../Tire-Performance/presentation/screen/tire_performance_screen.dart';
import '../../../Tire-Performance/repository/tire_performance_repository.dart';
import '../../../Tire-Performance/service/tire_performance_service.dart';
import '../../../Vehicle/cubit/vehicle_cubit.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';
import '../../cubit/tire_inventory_cubit.dart';
import '../../cubit/tire_inventory_state.dart';
import 'add_edit_modal_tire_inventory.dart';

class TireInventoryScreen extends StatefulWidget {
  const TireInventoryScreen({super.key});

  @override
  State<TireInventoryScreen> createState() => _TireInventoryScreenState();
}

class _TireInventoryScreenState extends State<TireInventoryScreen> {
  TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<TireInventory> _filteredTires = [];
  List<TireInventory> _allTires = [];
  List<Vehicle> allvehicles = [];
  bool isload = true;

  @override
  void initState() {
    super.initState();
    fetchVehicle();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<TireInventoryCubit>().fetchTires(); // Fetch next page
    }
  }

  Future<void> _showAddEditModalTireInventory(BuildContext ctx,
      {TireInventory? tire}) async {
    final isdark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
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
              return add_edit_modal_tire_inventory(ctx: ctx, tire: tire);
            });
      },
    );
  }

  Future<void> fetchVehicle() async {
    final state = await context.read<VehicleCubit>().state;
    if (state is! VehicleLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchVehicle(); // Try again until loaded
      return;
    }
    setState(() {
      allvehicles = state.vehicles;
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
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white70,
        // appBar: AppBar(
        //   title: Text(tireinventoryconstants.appbar,
        //       style:
        //           TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        //   centerTitle: true,
        //   leading: IconButton(
        //       alignment: Alignment.topRight,
        //       color: Colors.white,
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => MultiProvider(
        //               providers: [
        //                 Provider<TireInventoryService>(
        //                   create: (context) => TireInventoryService(),
        //                 ),
        //                 Provider<TireCategoryService>(
        //                   create: (context) => TireCategoryService(),
        //                 ),
        //               ],
        //               child: MultiBlocProvider(
        //                 providers: [
        //                   BlocProvider<TireInventoryCubit>(
        //                     create: (context) {
        //                       final tireInventoryService =
        //                           context.read<TireInventoryService>();
        //                       final tireInventoryRepository =
        //                           TireInventoryRepository(tireInventoryService);
        //                       return TireInventoryCubit(tireInventoryRepository)
        //                         ..fetchTireInventoryLogs();
        //                     },
        //                   ),
        //                 ],
        //                 child: TireLogsScreen(),
        //               ),
        //             ),
        //           ),
        //         );
        //       },
        //       icon: SvgPicture.asset(
        //         'assets/vectors/tire_icon.svg',
        //         height: 25.h,
        //       )),
        //   actions: [
        //     /*IconButton(
        //         alignment: Alignment.topRight,
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => BlocProvider(
        //                 create: (context) => TireExpenseCubit(
        //                   TireExpenseRepository(
        //                     TireExpenseService(),
        //                   ),
        //                 )..fetchTireExpense(),
        //                 child: Tire_Expense_Screen(),
        //               ),
        //             ),
        //           );
        //         },
        //         icon: Icon(
        //           Icons.currency_exchange,
        //           size: 25.h,
        //           color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
        //         )),*/
        //     IconButton(
        //         alignment: Alignment.topRight,
        //         onPressed: () {
        //           _showAddEditModalTireInventory(context);
        //         },
        //         icon: Icon(Icons.add_circle, color: Colors.white)),
        //   ],
        //   backgroundColor: Colors.blueAccent,
        // ),
        body: RefreshIndicator(
          child: BlocConsumer<TireInventoryCubit, TireInventoryState>(
              listener: (context, state) {
            if (state is AddedTireInventoryState ||
                state is UpdatedTireInventoryState ||
                state is DeletedTireInventoryState) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context,
                  message,
                  Colors.green,
                  (state is AddedTireInventoryState)
                      ? Icons.add
                      : (state is UpdatedTireInventoryState)
                          ? Icons.edit
                          : Icons.delete);
            } else if (state is TireInventoryError) {
              ToastHelper.showCustomToast(
                  context, state.message, Colors.red, Icons.error);
            }
          }, builder: (context, state) {
            if (state is TireInventoryLoading || isload && _allTires.isEmpty) {
              return shimmer();
            } else if (state is TireInventoryError) {
              return Center(child: Text(state.message));
            } else if (state is TireInventoryLoaded) {
              _allTires = state.tireinventory;
              _filteredTires = _searchController.text.isEmpty
                  ? _allTires
                  : _allTires
                      .where((tires) => tires.serialNumber
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Search by Serial No.',
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
                                _filteredTires = _allTires
                                    .where((tires) => tires.serialNumber
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
                          onPressed: () =>
                              {_showAddEditModalTireInventory(context)},
                          icon: Icon(
                            Icons.add_circle,
                            size: 20,
                          ))
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                    controller: _scrollController,
                    itemCount: _filteredTires.length + (state.hasNext ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _filteredTires.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.blueAccent,
                            ),
                          ),
                        );
                      }

                      final tire = _filteredTires[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 2.h, horizontal: 6.w),
                        child: CustomCard(
                          color: isdark
                              ? Colors.black
                              : Colors.grey
                                  .shade100, // Light neutral for better contrast
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              if (tire.id != null) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => TirePerformanceCubit(
                                        TirePerformanceRepository(
                                            TirePerformanceService()),
                                      )..fetchTirePerformance(
                                          int.parse(tire.id!)),
                                      child: Tire_Performance_Screen(
                                          tire: tire, id: int.parse(tire.id!)),
                                    ),
                                  ),
                                );
                              } else {
                                ToastHelper.showCustomToast(
                                  context,
                                  tireinventoryconstants.notirefound,
                                  Colors.orange.shade300,
                                  Icons.warning_amber_rounded,
                                );
                              }
                            },
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
                                tire.serialNumber,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${tireinventoryconstants.brand}: ${tire.brand}",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10.sp,
                                      )),
                                  Text(
                                      "${tireinventoryconstants.model}: ${tire.model}",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10.sp,
                                      )),
                                  Text(
                                      "${tireinventoryconstants.size}: ${tire.size}",
                                      style: TextStyle(
                                        color: Colors.grey.shade500,
                                        fontSize: 10.sp,
                                      )),
                                  Visibility(
                                    child: Text(
                                        "Vehicle Number: ${allvehicles.firstWhere(
                                              (v) =>
                                                  v.id == tire.currentVehicleId,
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
                                              ), // provide all required fields
                                            ).vehicleNumber}",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10.sp,
                                        )),
                                    visible: tire.currentVehicleId != null,
                                  ),
                                  Visibility(
                                    child: Text(
                                        "Tire Position: ${tire!.position?.positionCode}",
                                        style: TextStyle(
                                          color: Colors.grey.shade500,
                                          fontSize: 10.sp,
                                        )),
                                    visible: tire.position != null,
                                  )
                                ],
                              ),
                              trailing: Wrap(
                                spacing: 5.h,
                                children: [
                                  ActionButton(
                                    icon: Icons.edit,
                                    color: Colors
                                        .green, // more aesthetic than default green
                                    onPressed: () =>
                                        _showAddEditModalTireInventory(context,
                                            tire: tire),
                                  ),
                                  ActionButton(
                                    icon: Icons.delete_outline,
                                    color: Colors.redAccent,
                                    onPressed: () async {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content:
                                            tireinventoryconstants.modaldelete,
                                        onConfirm: () {
                                          context
                                              .read<TireInventoryCubit>()
                                              .deleteTireInventory(
                                                  tire, tire.id!);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )),
                ],
              );
            }
            return Center(child: Text(tireinventoryconstants.notiresavailable));
          }),
          onRefresh: () async => {
            context.read<TireInventoryCubit>().fetchTires(isRefresh: true),
            fetchVehicle()
          },
          color: Colors.blueAccent,
        ));
  }
}
