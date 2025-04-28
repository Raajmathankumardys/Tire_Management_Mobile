import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../commonScreen/Homepage.dart';
import '../../../../commonScreen/expensescreen.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/themes/app_colors.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../Expense/cubit/expense_cubit.dart';
import '../../../Expense/repository/expense_repository.dart';
import '../../../Expense/service/expense_service.dart';
import '../../../Income/cubit/income_cubit.dart';
import '../../../Income/repository/income_repository.dart';
import '../../../Income/service/income_service.dart';
import '../../../Trip-Profit-Summary/cubit/trip_profit_summary_cubit.dart';
import '../../../Trip-Profit-Summary/repository/trip_profit_summary_repository.dart';
import '../../../Trip-Profit-Summary/service/trip_profit_summary_service.dart';
import '../../cubit/trips_cubit.dart';
import '../../cubit/trips_state.dart';
import 'add_edit_trip.dart';

class TripsScreen extends StatefulWidget {
  final int vehicleid;
  const TripsScreen({super.key, required this.vehicleid});

  @override
  State<TripsScreen> createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  void _showAddEditModal(BuildContext ctx, [Trip? trip]) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEditTrip(
          ctx: ctx,
          trip: trip,
          vehicleId: widget.vehicleid,
        );
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
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text("Trips",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen())); // Go back to the previous page
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _showAddEditModal(context);
                },
                icon: Icon(Icons.add_circle, color: Colors.white))
          ],
          backgroundColor:
              isdark ? Colors.grey.shade900 : AppColors.lightappbar,
        ),
        body: RefreshIndicator(
          child: BlocConsumer<TripCubit, TripState>(
            listener: (context, state) {
              if (state is AddedTripState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context, message, Colors.green, Icons.check);
              } else if (state is UpdatedTripState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context, message, Colors.green, Icons.check);
              } else if (state is DeletedTripState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context, message, Colors.green, Icons.check);
              } else if (state is TripError) {
                ToastHelper.showCustomToast(
                    context, state.message, Colors.red, Icons.error);
              }
            },
            builder: (context, state) {
              if (state is TripLoading) {
                return shimmer();
              } else if (state is TripError) {
                return Center(child: Text(state.message));
              } else if (state is TripLoaded) {
                return ListView.builder(
                  itemCount: state.trip.length,
                  itemBuilder: (context, index) {
                    final trip = state.trip[index];
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                      child: CustomCard(
                        color: isdark ? Colors.black54 : Colors.grey.shade100,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 12.w),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Start and End Dates
                                  Row(
                                    children: [
                                      Text("Start Date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(_formatDate(trip.startDate)),
                                    ],
                                  ),
                                  SizedBox(height: 3.h),
                                  Row(
                                    children: [
                                      Text("End Date: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Text(_formatDate(trip.endDate)),
                                    ],
                                  ),
                                  SizedBox(height: 5.h),
                                  // Source with Icon
                                  Row(
                                    children: [
                                      Icon(Icons.trip_origin,
                                          size: 18.sp, color: Colors.blue),
                                      SizedBox(width: 6.w),
                                      Text(trip.source,
                                          style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),

                                  // Dotted path
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 1.w, bottom: 0.w),
                                    child: Column(
                                      children: List.generate(
                                        2,
                                        (_) => Icon(Icons.more_vert,
                                            size: 14.sp, color: Colors.grey),
                                      ),
                                    ),
                                  ),

                                  // Destination with Icon
                                  Row(
                                    children: [
                                      Icon(Icons.location_pin,
                                          color: Colors.red),
                                      SizedBox(width: 6.w),
                                      Text(trip.destination,
                                          style: TextStyle(fontSize: 14.sp)),
                                    ],
                                  ),
                                ],
                              ),

                              // Right side: Action buttons
                              Column(
                                children: [
                                  ActionButton(
                                    icon: Icons.summarize_sharp,
                                    color: Colors.grey,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MultiBlocProvider(
                                            providers: [
                                              Provider<IncomeService>(
                                                create: (_) => IncomeService(),
                                              ),
                                              BlocProvider<IncomeCubit>(
                                                create: (context) {
                                                  final service = context
                                                      .read<IncomeService>();
                                                  final repo =
                                                      IncomeRepository(service);
                                                  return IncomeCubit(repo)
                                                    ..fetchIncome(trip.id!);
                                                },
                                              ),
                                              Provider<ExpenseService>(
                                                create: (_) => ExpenseService(),
                                              ),
                                              BlocProvider<ExpenseCubit>(
                                                create: (context) {
                                                  final service = context
                                                      .read<ExpenseService>();
                                                  final repo =
                                                      ExpenseRepository(
                                                          service);
                                                  return ExpenseCubit(repo)
                                                    ..fetchExpense(trip.id!);
                                                },
                                              ),
                                              Provider<
                                                  TripProfitSummaryService>(
                                                create: (_) =>
                                                    TripProfitSummaryService(),
                                              ),
                                              BlocProvider<
                                                  TripProfitSummaryCubit>(
                                                create: (context) {
                                                  final service = context.read<
                                                      TripProfitSummaryService>();
                                                  final repo =
                                                      TripProfitSummaryRepository(
                                                          service);
                                                  return TripProfitSummaryCubit(
                                                      repo)
                                                    ..fetchTripProfitSummary(
                                                        trip.id!);
                                                },
                                              ),
                                            ],
                                            child: TripViewPage(
                                                tripId: trip.id!,
                                                trip: trip,
                                                vehicleId: widget.vehicleid),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  SizedBox(height: 1.h),
                                  ActionButton(
                                    icon: Icons.edit,
                                    color: Colors.green,
                                    onPressed: () {
                                      _showAddEditModal(context, trip);
                                    },
                                  ),
                                  SizedBox(height: 1.h),
                                  ActionButton(
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onPressed: () async {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content:
                                            "Are you sure you want to delete this Trip? This action cannot be undone.",
                                        onConfirm: () {
                                          context
                                              .read<TripCubit>()
                                              .deleteTrip(trip, trip.id!);
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: Text("No trips available"));
            },
          ),
          onRefresh: () async =>
              {context.read<TripCubit>().fetchTrip(widget.vehicleid)},
          color: Colors.blueAccent,
        ));
  }
}
