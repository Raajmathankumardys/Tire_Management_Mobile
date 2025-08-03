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
import '../../cubit/tire_inventory_cubit.dart';
import '../../cubit/tire_inventory_state.dart';
import 'add_edit_modal_tire_inventory.dart';

class TireLogsScreen extends StatefulWidget {
  const TireLogsScreen({super.key});

  @override
  State<TireLogsScreen> createState() => _TireLogsScreenState();
}

class _TireLogsScreenState extends State<TireLogsScreen> {
  TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<TireInventory> _filteredTires = [];
  List<TireInventory> _allTires = [];
  // Future<void> _showAddEditModalTireInventory(BuildContext ctx,
  //     {TireInventory? tire}) async {
  //   final isdark = Theme.of(context).brightness == Brightness.dark;
  //
  //   showModalBottomSheet(
  //     context: ctx,
  //     isScrollControlled: true,
  //     backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //     ),
  //     builder: (context) {
  //       return DraggableScrollableSheet(
  //           initialChildSize: 0.5.h, // Starts at of screen height
  //           minChildSize: 0.5.h, // Minimum height
  //           maxChildSize: 0.6.h,
  //           expand: false,
  //           builder: (context, scrollController) {
  //             return add_edit_modal_tire_inventory(ctx: ctx, tire: tire);
  //           });
  //     },
  //   );
  // }
  //
  // Future<void> showDeleteConfirmationDialog({
  //   required BuildContext context,
  //   required VoidCallback onConfirm,
  //   required content,
  // }) async {
  //   await showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (_) => DeleteConfirmationDialog(
  //       onConfirm: onConfirm,
  //       content: content,
  //     ),
  //   );
  // }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<TireInventoryCubit>().fetchTires(); // Fetch next page
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          title: Text("Tire Logs",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
              alignment: Alignment.topRight,
              color: Colors.white,
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.white)),
          backgroundColor: Colors.blueAccent,
        ),
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
            if (state is TireInventoryLoading) {
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
                  Padding(
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
                          _filteredTires = _allTires
                              .where((tires) => tires.serialNumber
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
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
                                final isDark = Theme.of(context).brightness ==
                                    Brightness.dark;
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor:
                                      isDark ? Colors.grey[900] : Colors.white,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (context) {
                                    return SingleChildScrollView(
                                        child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16.w, vertical: 24.h),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Container(
                                              width: 40,
                                              height: 4,
                                              margin:
                                                  EdgeInsets.only(bottom: 12.h),
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "Tire Details",
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 10.h),
                                          Text(
                                              "Serial No: ${tire.serialNumber}"),
                                          Text("Brand: ${tire.brand}"),
                                          Text("Model: ${tire.model}"),
                                          Text("Size: ${tire.size}"),
                                          Text("Type: ${tire.type}"),
                                          Text(
                                              "Pressure: ${tire.pressure.toString()}"),
                                          Text(
                                              "Temperature: ${tire.temperature.toString()}"),
                                          Text(
                                              "Distance: ${tire.treadDepth.toString()}"),
                                          Text(
                                              "Purchase Date: ${tire.purchaseDate!.toString().split(' ')[0]}"),
                                          Text(
                                              "Cost: ₹${tire.price!.toStringAsFixed(2)}"),
                                          Text(
                                              "Expected Life Span: ${tire.expectedLifespan.toString()}"),
                                          Text(
                                              "Status: ${tire.status.toString().split('.').last}"),
                                          if (tire.position != null) ...[
                                            Text(
                                                "Vehicle Id : ${tire.currentVehicleId!}"),
                                            Text(
                                                "Position: ${tire.position!.position!}"),
                                            Text(
                                                "Position Code: ${tire.position!.positionCode!}"),
                                            Text(
                                                "Axle Number: ${tire.position!.axleNumber!.toString()}"),
                                            Text(
                                                "Description: ${tire.position!.description!}"),
                                            Text(
                                                "Installed Date : ${tire.installDate!}"),
                                          ],
                                          SizedBox(height: 16.h),
                                        ],
                                      ),
                                    ));
                                  },
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
                                ],
                              ),
                              // trailing: Wrap(
                              //   spacing: 5.h,
                              //   children: [
                              //     ActionButton(
                              //       icon: Icons.edit,
                              //       color: Colors
                              //           .green, // more aesthetic than default green
                              //       onPressed: () =>
                              //           _showAddEditModalTireInventory(
                              //               context,
                              //               tire: tire),
                              //     ),
                              //     ActionButton(
                              //       icon: Icons.delete_outline,
                              //       color: Colors.redAccent,
                              //       onPressed: () async {
                              //         await showDeleteConfirmationDialog(
                              //           context: context,
                              //           content: tireinventoryconstants
                              //               .modaldelete,
                              //           onConfirm: () {
                              //             context
                              //                 .read<TireInventoryCubit>()
                              //                 .deleteTireInventory(
                              //                     tire, tire.id!);
                              //           },
                              //         );
                              //       },
                              //     ),
                              //   ],
                              // ),
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
            context.read<TireInventoryCubit>().fetchTiresLogs(isRefresh: true)
          },
          color: Colors.blueAccent,
        ));
  }
}
