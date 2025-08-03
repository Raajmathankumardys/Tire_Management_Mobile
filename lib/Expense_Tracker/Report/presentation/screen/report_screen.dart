import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/helpers/components/widgets/button/app_primary_button.dart';
import '../../../../../helpers/components/shimmer.dart';
import '../../../../../helpers/components/themes/app_colors.dart';
import '../../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../../helpers/constants.dart';
import '../../cubit/report_cubit.dart';
import '../../cubit/report_state.dart';
import '../widget/expensebreakdown/buildExpensePieChartWithTable.dart';
import '../widget/expensebreakdown/tripexpensesscreen.dart';
import '../widget/income_vs_expense/comparisons.dart';
import '../widget/income_vs_expense/totals.dart';
import '../widget/trip_profitability/monthlybarchart.dart';
import '../widget/trip_profitability/quarterlybarchart.dart';
import '../widget/trip_profitability/tripdata.dart';
import 'exportReportToPdf.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});
  @override
  State<ReportScreen> createState() => ReportScreen_State();
}

class ReportScreen_State extends State<ReportScreen> {
  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          centerTitle: true,
          title: Text("Reports",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor:
              isdark ? Colors.grey.shade900 : AppColors.lightappbar,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              )),
        ),
        body:
            BlocConsumer<ReportCubit, ReportState>(listener: (context, state) {
          if (state is ReportError) {
            ToastHelper.showCustomToast(
                context, state.message, Colors.red, Icons.error);
          }
        }, builder: (context, state) {
          if (state is ReportLoading) {
            return Container(
              padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
              child: const shimmer(),
            );
          } else if (state is ReportError) {
            return Center(child: Text(state.message));
          } else if (state is ReportLoaded) {
            final report = state.report;
            bool iscat = report.expenseBreakdown.categoryBreakdown
                .every((i) => i.amount == 0.0);
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: (report.tripProfitability.tripData.isEmpty &&
                      report.tripProfitability.monthlyData.isEmpty &&
                      report.tripProfitability.quarterlyData.isEmpty &&
                      report.expenseBreakdown.tripExpenses.isEmpty &&
                      report.incomeVsExpense.comparisons.isEmpty &&
                      iscat &&
                      report.incomeVsExpense.totals.totalExpenses == 0.0 &&
                      report.incomeVsExpense.totals.totalIncome == 0.0 &&
                      report.incomeVsExpense.totals.totalProfit == 0.0 &&
                      report.incomeVsExpense.totals.profitPercentage == 0.0)
                  ? Container(
                      height: MediaQuery.of(context).size.height * 0.8,
                      width: double.infinity,
                      child: Center(
                        child: Text("No Reports Found"),
                      ))
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: _buildSectionTitle('Trip Profitability'),
                        ),
                        ...(report.tripProfitability.tripData.isEmpty
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                Column(
                                  children: [
                                    for (var trip
                                        in report.tripProfitability.tripData)
                                      TripDataCard(trip: trip),
                                  ],
                                ),
                              ]),
                        SizedBox(height: 10.h),
                        _buildSectionTitle('Monthly Analysis'),
                        ...(report.tripProfitability.tripData.isEmpty
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: MonthlyBarChart(
                                      monthlyData:
                                          report.tripProfitability.monthlyData),
                                ),
                              ]),
                        _buildSectionTitle('Quarterly Analysis'),
                        ...(report.tripProfitability.quarterlyData.isEmpty
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: QuarterlyBarChart(
                                      quarterlyData: report
                                          .tripProfitability.quarterlyData),
                                ),
                              ]),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Overall Expense Breakdown'),
                        ...(iscat
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                buildExpensePieChartWithTable(
                                  categories:
                                      report.expenseBreakdown.categoryBreakdown,
                                ),
                              ]),
                        const SizedBox(height: 24),
                        _buildSectionTitle('Trip-wise Expense Breakdown'),
                        ...(report.expenseBreakdown.tripExpenses.isEmpty
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                TripExpensesWidget(
                                  tripExpenses:
                                      report.expenseBreakdown.tripExpenses,
                                ),
                              ]),
                        const SizedBox(height: 24),
                        Center(
                          child: _buildSectionTitle(
                              'Income vs Expense Comparison'),
                        ),
                        ...(report.incomeVsExpense.comparisons.isEmpty
                            ? [Center(child: Text("No Data Found"))]
                            : [
                                Padding(
                                  padding: EdgeInsets.all(20.h),
                                  child: ComparisonBarChart(
                                      comparisonData:
                                          report.incomeVsExpense.comparisons),
                                ),
                              ]),
                        totals(data: report.incomeVsExpense),
                        Align(
                          child: AppPrimaryButton(
                              onPressed: () async =>
                                  {await exportReportToPdf(report.toJson())},
                              title: "Export PDF"),
                          alignment: Alignment.center,
                        ),
                      ],
                    ),
            );
          }
          return const Center(child: Text("No Reports Found"));
        }));
  }

  Widget _buildSectionTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// onPressed: () async {
// // Show a BottomSheet to let the user choose PDF or Excel
// final result =
//     await showModalBottomSheet<String>(
// context: context,
// builder: (BuildContext context) {
// return Container(
// padding: EdgeInsets.all(16.0),
// height: 170.h,
// child: Column(
// mainAxisAlignment:
// MainAxisAlignment.center,
// crossAxisAlignment:
// CrossAxisAlignment.stretch,
// children: [
// Text(
// 'Choose Export Format',
// style: TextStyle(
// fontSize: 18,
// fontWeight: FontWeight.bold,
// ),
// textAlign: TextAlign.center,
// ),
// SizedBox(height: 20),
// ElevatedButton.icon(
// onPressed: () {
// Navigator.pop(context, 'excel');
// },
// icon: Icon(
// Icons.table_chart,
// size: 20,
// color: Colors.blueAccent,
// ),
// label: Text(
// 'Export to Excel',
// style: TextStyle(
// color: Colors.blueAccent,
// ),
// ),
// style: ElevatedButton.styleFrom(
// padding: EdgeInsets.symmetric(
// vertical: 14),
// ),
// ),
// SizedBox(height: 10),
// ElevatedButton.icon(
// onPressed: () {
// Navigator.pop(context, 'pdf');
// },
// icon: Icon(
// Icons.picture_as_pdf,
// size: 20,
// color: Colors.blueAccent,
// ),
// label: Text('Export to PDF',
// style: TextStyle(
// color: Colors.blueAccent,
// )),
// style: ElevatedButton.styleFrom(
// padding: EdgeInsets.symmetric(
// vertical: 14),
// ),
// ),
// ],
// ),
// );
// },
// );
//
// // Perform the export based on user selection
// if (result != null) {
// if (result == 'excel') {
// await exportReportToExcel(
// jsonEncode(report.toJson()));
// ToastHelper.showCustomToast(
// context,
// "Excel file downloaded in Downloads folder",
// Colors.green,
// Icons.table_chart_outlined);
// } else if (result == 'pdf') {
// await exportReportToPdf(report.toJson());
// ToastHelper.showCustomToast(
// context,
// "PDF file downloaded successfully!",
// Colors.green,
// Icons.picture_as_pdf_outlined);
// }
// }
// }
