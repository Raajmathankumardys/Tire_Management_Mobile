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
import '../../../Tire-Category/cubit/tire_category_cubit.dart';
import '../../../Tire-Category/presentation/screen/tire_category_screen.dart';
import '../../../Tire-Category/repository/tire_category_repository.dart';
import '../../../Tire-Category/service/tire_category_service.dart';
import '../../../Tire-Expense/cubit/tire_expense_cubit.dart';
import '../../../Tire-Expense/repository/tire_expense_repository.dart';
import '../../../Tire-Expense/service/tire_expense_service.dart';
import '../../../Tire-Performance/cubit/tire_performance_cubit.dart';
import '../../../Tire-Performance/presentation/screen/tire_performance_screen.dart';
import '../../../Tire-Performance/repository/tire_performance_repository.dart';
import '../../../Tire-Performance/service/tire_performance_service.dart';
import '../../cubit/tire_inventory_cubit.dart';
import '../../cubit/tire_inventory_state.dart';
import '../../repository/tire_inventory_repository.dart';
import '../../service/tire_inventory_service.dart';
import 'add_edit_modal_tire_inventory.dart';

class TireInventoryScreen extends StatefulWidget {
  const TireInventoryScreen({super.key});

  @override
  State<TireInventoryScreen> createState() => _TireInventoryScreenState();
}

class _TireInventoryScreenState extends State<TireInventoryScreen> {
  TextEditingController _searchController = TextEditingController();
  List<TireInventory> _filteredTires = [];
  List<TireInventory> _allTires = [];
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
        appBar: AppBar(
          title: Text(tireinventoryconstants.appbar,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          centerTitle: true,
          leading: IconButton(
              alignment: Alignment.topRight,
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiProvider(
                      providers: [
                        Provider<TireInventoryService>(
                          create: (context) => TireInventoryService(),
                        ),
                        Provider<TireCategoryService>(
                          create: (context) => TireCategoryService(),
                        ),
                      ],
                      child: MultiBlocProvider(
                        providers: [
                          BlocProvider<TireInventoryCubit>(
                            create: (context) {
                              final tireInventoryService =
                                  context.read<TireInventoryService>();
                              final tireInventoryRepository =
                                  TireInventoryRepository(tireInventoryService);
                              return TireInventoryCubit(tireInventoryRepository)
                                ..fetchTireInventory();
                            },
                          ),
                          BlocProvider<TireCategoryCubit>(
                            create: (context) {
                              final tireCategoryService =
                                  context.read<TireCategoryService>();
                              final tireCategoryRepository =
                                  TireCategoryRepository(tireCategoryService);
                              return TireCategoryCubit(tireCategoryRepository)
                                ..fetchTireCategory();
                            },
                          ),
                        ],
                        child: Tire_Category_Screen(),
                      ),
                    ),
                  ),
                );
              },
              icon: Icon(Icons.category, color: Colors.white)),
          actions: [
            /*IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => TireExpenseCubit(
                          TireExpenseRepository(
                            TireExpenseService(),
                          ),
                        )..fetchTireExpense(),
                        child: Tire_Expense_Screen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.currency_exchange,
                  size: 25.h,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                )),*/
            IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  _showAddEditModalTireInventory(context);
                },
                icon: Icon(Icons.add_circle, color: Colors.white)),
          ],
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
                      .where((tires) => tires.serialNo
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
                              .where((tires) => tires.serialNo
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                  ),
                  _filteredTires.isEmpty
                      ? Padding(
                          padding: EdgeInsets.all(12.h),
                          child: Text("No Tires found."),
                        )
                      : Expanded(
                          child: ListView.builder(
                          itemCount: _filteredTires.length,
                          itemBuilder: (context, index) {
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
                                            create: (context) =>
                                                TirePerformanceCubit(
                                              TirePerformanceRepository(
                                                  TirePerformanceService()),
                                            )..fetchTirePerformance(tire.id!),
                                            child: Tire_Performance_Screen(
                                                tire: tire, id: tire.id!),
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
                                          borderRadius:
                                              BorderRadius.circular(10.r)),
                                      padding: EdgeInsets.all(8.h),
                                      child: SvgPicture.asset(
                                        tireinventoryconstants.tireicon,
                                        height: 30.h,
                                        color: isdark
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    title: Text(
                                      tire.serialNo,
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    trailing: Wrap(
                                      spacing: 5.h,
                                      children: [
                                        ActionButton(
                                          icon: Icons.edit,
                                          color: Colors
                                              .green, // more aesthetic than default green
                                          onPressed: () =>
                                              _showAddEditModalTireInventory(
                                                  context,
                                                  tire: tire),
                                        ),
                                        ActionButton(
                                          icon: Icons.delete_outline,
                                          color: Colors.redAccent,
                                          onPressed: () async {
                                            await showDeleteConfirmationDialog(
                                              context: context,
                                              content: tireinventoryconstants
                                                  .modaldelete,
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
          onRefresh: () async =>
              {context.read<TireInventoryCubit>().fetchTireInventory()},
          color: Colors.blueAccent,
        ));
  }
}
