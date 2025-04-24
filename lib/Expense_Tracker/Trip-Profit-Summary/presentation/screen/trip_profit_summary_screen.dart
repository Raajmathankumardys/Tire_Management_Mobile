import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../TMS/helpers/components/shimmer.dart';
import '../../../Trips/cubit/trips_state.dart';
import '../../cubit/trip_profit_summary_cubit.dart';
import '../../cubit/trip_profit_summary_state.dart';
import '../widget/breakdown_donut_chart.dart';
import '../widget/expense_table.dart';
import '../widget/summary_card.dart';

class TripProfitSummaryScreen extends StatefulWidget {
  final Trip trip;
  const TripProfitSummaryScreen({super.key, required this.trip});

  @override
  State<TripProfitSummaryScreen> createState() =>
      _TripProfitSummaryScreenState();
}

class _TripProfitSummaryScreenState extends State<TripProfitSummaryScreen> {
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        body: RefreshIndicator(
          child: BlocConsumer<TripProfitSummaryCubit, TripProfitSummaryState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is TripProfitSummaryLoading) {
                return shimmer(
                  count: 7,
                );
              } else if (state is TripProfitSummaryError) {
                return Center(child: Text(state.message));
              } else if (state is TripProfitSummaryLoaded) {
                final isdark = Theme.of(context).brightness == Brightness.dark;
                final tripProfitSummary = state.tripprofitsummary;
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.h),
                        ),
                        color: isdark ? Colors.grey[900] : Colors.white,
                        elevation: 2.h, // Adds a subtle shadow for depth
                        margin: EdgeInsets.fromLTRB(18.h, 10.h, 18.h, 8.h),
                        child: Padding(
                          padding: EdgeInsets.all(8.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  "Trip Details",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.h,
                                    color: isdark ? Colors.white : Colors.black,
                                  ),
                                ),
                              ),
                              Divider(thickness: 1.h, height: 20.h),
                              Row(
                                children: [
                                  const Icon(Icons.location_on,
                                      color: Colors.blueAccent),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'Source: ${widget.trip.source}',
                                      style: TextStyle(fontSize: 12.h),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  const Icon(Icons.flag,
                                      color: Colors.redAccent),
                                  SizedBox(width: 8.h),
                                  Expanded(
                                    child: Text(
                                      'Destination: ${widget.trip.destination}',
                                      style: TextStyle(fontSize: 12.h),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Colors.green),
                                  SizedBox(width: 8.h),
                                  Expanded(
                                    child: Text(
                                      'Start Date: ${_formatDate(widget.trip.startDate)}',
                                      style: TextStyle(fontSize: 12.h),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10.h),
                              Row(
                                children: [
                                  const Icon(Icons.event, color: Colors.orange),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      'End Date: ${_formatDate(widget.trip.endDate)}',
                                      style: TextStyle(fontSize: 12.h),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SummaryCard(
                              title: 'TOTAL EXPENSES',
                              amount: '\₹${tripProfitSummary.totalExpenses}',
                              theme: isdark),
                          SummaryCard(
                              title: 'TOTAL INCOME',
                              amount: '\₹${tripProfitSummary.totalIncome}',
                              theme: isdark),
                          SummaryCard(
                              title: 'PROFIT',
                              amount: '\₹${tripProfitSummary.profit}',
                              theme: isdark),
                        ],
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(18.h, 10.h, 18.h, 10.h),
                        elevation: 2.h,
                        color: isdark ? Colors.grey[900] : Colors.white,
                        child: Padding(
                            padding: EdgeInsets.all(8.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Text(
                                    "Expense Breakdown",
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 6.h),
                                ExpenseTable(
                                    breakDown: tripProfitSummary.breakDown),
                              ],
                            )),
                      ),
                      Card(
                        margin: EdgeInsets.fromLTRB(18.h, 2.h, 18.h, 2.h),
                        color: isdark ? Colors.grey[900] : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 15.h),
                            Text(
                              "Expense Distribution",
                              style: TextStyle(
                                  fontSize: 18.h, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(6.h),
                              padding: EdgeInsets.all(2.h),
                              child: BreakdownDonutChart(breakdown: {
                                "FUEL": tripProfitSummary.breakDown["FUEL"]
                                        ?.toDouble() ??
                                    0.0,
                                "DRIVER_ALLOWANCE": tripProfitSummary
                                        .breakDown["DRIVER_ALLOWANCE"]
                                        ?.toDouble() ??
                                    0.0,
                                "TOLL": tripProfitSummary.breakDown["TOLL"]
                                        ?.toDouble() ??
                                    0.0,
                                "MAINTENANCE": tripProfitSummary
                                        .breakDown["MAINTENANCE"]
                                        ?.toDouble() ??
                                    0.0,
                                "MISCELLANEOUS": tripProfitSummary
                                        .breakDown["MISCELLANEOUS"]
                                        ?.toDouble() ??
                                    0.0,
                              }),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                );
              }
              return Center(child: Text("No trips available"));
            },
          ),
          onRefresh: () async => {
            context
                .read<TripProfitSummaryCubit>()
                .fetchTripProfitSummary(widget.trip.id!)
          },
          color: Colors.blueAccent,
        ));
  }
}
