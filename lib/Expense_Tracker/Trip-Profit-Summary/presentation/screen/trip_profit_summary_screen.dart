import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/constants.dart';
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
                                  tripprofitsummary.tripdetails,
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
                                      '${tripconstants.source}: ${widget.trip.source}',
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
                                      '${tripconstants.destination}: ${widget.trip.destination}',
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
                                      '${tripconstants.startDate}: ${_formatDate(widget.trip.startDate)}',
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
                                      '${tripconstants.endDate}: ${_formatDate(widget.trip.endDate)}',
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
                              title: tripprofitsummary.totalexpenses,
                              amount:
                                  '${tripprofitsummary.rupees}${tripProfitSummary.totalExpenses}',
                              theme: isdark),
                          SummaryCard(
                              title: tripprofitsummary.totalincome,
                              amount:
                                  '${tripprofitsummary.rupees}${tripProfitSummary.totalIncome}',
                              theme: isdark),
                          SummaryCard(
                              title: tripprofitsummary.profitu,
                              amount:
                                  '${tripprofitsummary.rupees}${tripProfitSummary.profit}',
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
                                    tripprofitsummary.expensebreakdown,
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
                              tripprofitsummary.expensedistribution,
                              style: TextStyle(
                                  fontSize: 18.h, fontWeight: FontWeight.bold),
                            ),
                            Container(
                              margin: EdgeInsets.all(6.h),
                              padding: EdgeInsets.all(2.h),
                              child: BreakdownDonutChart(breakdown: {
                                expenseconstants.fuelcostsvalue:
                                    tripProfitSummary.breakDown[
                                                expenseconstants.fuelcostsvalue]
                                            ?.toDouble() ??
                                        0.0,
                                expenseconstants.driverallowancesvalue:
                                    tripProfitSummary.breakDown[expenseconstants
                                                .driverallowancesvalue]
                                            ?.toDouble() ??
                                        0.0,
                                expenseconstants.tollchargesvalue:
                                    tripProfitSummary.breakDown[expenseconstants
                                                .tollchargesvalue]
                                            ?.toDouble() ??
                                        0.0,
                                expenseconstants.maintenancevalue:
                                    tripProfitSummary.breakDown[expenseconstants
                                                .maintenancevalue]
                                            ?.toDouble() ??
                                        0.0,
                                expenseconstants.miscellaneousvalue:
                                    tripProfitSummary.breakDown[expenseconstants
                                                .miscellaneousvalue]
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
              return Center(child: Text(tripprofitsummary.notrips));
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
