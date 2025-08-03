import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/Expense_Tracker/Driver/presentation/add_edit_driver.dart';
import '../../../../helpers/constants.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../helpers/components/themes/app_colors.dart';
import '../cubit/driver_cubit.dart';
import '../cubit/driver_state.dart';

class DriverScreen extends StatefulWidget {
  const DriverScreen({super.key});

  @override
  State<DriverScreen> createState() => _DriverScreenState();
}

class _DriverScreenState extends State<DriverScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<Driver> filtereddrivers = [];
  List<Driver> alldrivers = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      context.read<DriverCubit>().fetchDriver(); // Fetch next page
    }
  }

  void _showAddEditModal(BuildContext ctx, [Driver? driver]) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return add_edit_driver(ctx: ctx, driver: driver);
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
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            alldrivers.clear();
          });
          context.read<DriverCubit>().fetchDriver(isRefresh: true);
        },
        child: BlocConsumer<DriverCubit, DriverState>(
          listener: (context, state) {
            if (state is AddedDriverState ||
                state is UpdatedDriverState ||
                state is DeletedDriverState) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context, message, Colors.green, Icons.check);
            } else if (state is DriverError) {
              ToastHelper.showCustomToast(
                  context, state.message, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is DriverLoading && alldrivers.isEmpty) {
              return shimmer();
            } else if (state is DriverError) {
              return Center(child: Text(state.message));
            } else if (state is DriverLoaded) {
              alldrivers = state.driver;
              filtereddrivers = _searchController.text.isEmpty
                  ? alldrivers
                  : alldrivers
                      .where((d) => d.firstName
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase()))
                      .toList();
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              labelText: 'Search by name',
                              prefixIcon: const Icon(Icons.search),
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                borderSide:
                                    const BorderSide(color: Colors.blueAccent),
                              ),
                              enabledBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              focusedBorder: const OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.blueAccent),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                filtereddrivers = alldrivers
                                    .where((d) => d.firstName
                                        .toLowerCase()
                                        .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
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
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount:
                          filtereddrivers.length + (state.hasNext ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == filtereddrivers.length) {
                          return const Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: CircularProgressIndicator(
                                color: Colors.blueAccent,
                              ),
                            ),
                          );
                        }

                        final driver = filtereddrivers[index];
                        return Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 2.h, horizontal: 6.w),
                          child: CustomCard(
                            color:
                                isdark ? Colors.black54 : Colors.grey.shade100,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8.h, horizontal: 12.w),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10.h),
                                    decoration: BoxDecoration(
                                      color: (isdark
                                              ? AppColors.darkaddbtn
                                              : AppColors.lightaddbtn)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                    child: Icon(
                                      Icons.supervised_user_circle_outlined,
                                      size: 24.h,
                                      color: isdark
                                          ? AppColors.darkaddbtn
                                          : AppColors.lightaddbtn,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${driver.firstName} ${driver.lastName}',
                                          style: TextStyle(
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          driver.licenseNumber,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        SizedBox(height: 4.h),
                                        Text(
                                          driver.email,
                                          style: TextStyle(
                                            fontSize: 10.sp,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Wrap(
                                    spacing: 6.w,
                                    children: [
                                      ActionButton(
                                          icon: Icons.edit,
                                          color: Colors.green,
                                          onPressed: () {
                                            _showAddEditModal(context, driver);
                                          }),
                                      ActionButton(
                                        icon: Icons.delete_outline,
                                        color: Colors.red,
                                        onPressed: () async {
                                          await showDeleteConfirmationDialog(
                                            context: context,
                                            content:
                                                "Are you sure you want to delete this driver?",
                                            onConfirm: () {
                                              context
                                                  .read<DriverCubit>()
                                                  .deleteDriver(
                                                      driver, driver.id!);
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return shimmer();
          },
        ),
        color: Colors.blueAccent,
      ),
    );
  }
}
