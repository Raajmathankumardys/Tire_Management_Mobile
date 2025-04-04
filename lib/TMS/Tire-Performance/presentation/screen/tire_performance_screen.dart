import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/widget/tire_graph.dart';
import 'package:yaantrac_app/TMS/presentation/widget/shimmer.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';

import '../../../../common/widgets/button/app_primary_button.dart';
import '../../../../common/widgets/input/app_input_field.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../screens/Homepage.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../cubit/tire_performance_cubit.dart';
import '../../cubit/tire_performance_state.dart';

class Tire_Performance_Screen extends StatefulWidget {
  final TireInventory tire;
  const Tire_Performance_Screen({super.key, required this.tire});

  @override
  State<Tire_Performance_Screen> createState() => _TirePerformanceState();
}

class _TirePerformanceState extends State<Tire_Performance_Screen> {
  void _showAddModal(BuildContext ctx) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController pressure = TextEditingController();
    TextEditingController temperature = TextEditingController();
    TextEditingController wear = TextEditingController();
    TextEditingController treadDepth = TextEditingController();
    TextEditingController dist = TextEditingController();
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (
          context,
        ) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
              ),
              child: Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection:
                        Axis.vertical, // Attach the scroll controller
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: AppColors
                                  .secondaryColor, // Adjust color as needed
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15.r)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 5.h),
                                Container(
                                  width: 80.w,
                                  height: 5.h,
                                  padding: EdgeInsets.all(12.h),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20.h),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  "Add Tire Performance",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                left: 12.w,
                                right: 12.w,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        12.h,
                                top: 12.h,
                              ),
                              child: Column(
                                children: [
                                  AppInputField(
                                    name: 'number_field',
                                    label: "Pressure",
                                    hint: "Enter pressure",
                                    keyboardType: TextInputType.number,
                                    controller: pressure,
                                  ),
                                  AppInputField(
                                    name: 'number_field',
                                    label: "Temperature",
                                    hint: "Enter temperature",
                                    keyboardType: TextInputType.number,
                                    controller: temperature,
                                  ),
                                  AppInputField(
                                    name: 'number_field',
                                    label: "Wear",
                                    hint: "Enter wear",
                                    keyboardType: TextInputType.number,
                                    controller: wear,
                                  ),
                                  AppInputField(
                                    name: 'number_field',
                                    label: "Distance Travelled",
                                    hint: "Enter distance travelled",
                                    keyboardType: TextInputType.number,
                                    controller: dist,
                                  ),
                                  AppInputField(
                                    name: 'number_field',
                                    label: "Tread Depth",
                                    hint: "Enter tread depth",
                                    keyboardType: TextInputType.number,
                                    controller: treadDepth,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          child: AppPrimaryButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: "Cancel")),
                                      SizedBox(
                                        width: 10.h,
                                      ),
                                      Expanded(
                                          child: AppPrimaryButton(
                                              width: 130.h,
                                              onPressed: () async {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  final tirep = TirePerformance(
                                                      tireId: widget.tire.id,
                                                      pressure: double.parse(
                                                          pressure.text),
                                                      temperature: double.parse(
                                                          temperature.text),
                                                      wear: double.parse(
                                                          wear.text),
                                                      distanceTraveled:
                                                          double.parse(
                                                              dist.text),
                                                      treadDepth: double.parse(
                                                          treadDepth.text));
                                                  ctx
                                                      .read<
                                                          TirePerformanceCubit>()
                                                      .addTirePerformance(
                                                          tirep);
                                                  Navigator.pop(context);
                                                }
                                              },
                                              title: "Add"))
                                    ],
                                  ),
                                ],
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  String _calculateAverage(List<TirePerformance> tirePerformances,
      double Function(TirePerformance) selector) {
    if (tirePerformances.isEmpty) return "0.00";
    double sum = tirePerformances.map(selector).reduce((a, b) => a + b);
    return (sum / tirePerformances.length).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Tire Performance"),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.black
              : Colors.blueAccent,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(
                    currentIndex: 1,
                  ),
                ),
              );
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                _showAddModal(context);
              },
              icon: Icon(
                Icons.add_circle,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: BlocConsumer<TirePerformanceCubit, TirePerformanceState>(
          listener: (context, state) {
            if (state is AddedTirePerformanceState) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context, message, Colors.green, Icons.add);
            } else if (state is TirePerformanceError) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context, message, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is TirePerformanceLoading) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                child: shimmer(),
              );
            } else if (state is TirePerformanceError) {
              return Center(
                child: Text(state.message.toString()),
              );
            } else if (state is TirePerformanceLoaded) {
              final tirePerformances = state.tireperformance;
              return tirePerformances.isEmpty
                  ? Center(child: Text("No Tire Performance Available"))
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.h),
                      child: Column(
                        children: [
                          _buildStatCard(
                              tirePerformances,
                              "Average Pressure: ${_calculateAverage(tirePerformances, (e) => e.pressure)} PSI",
                              theme),
                          _buildStatCard(
                              tirePerformances,
                              "Average Temperature: ${_calculateAverage(tirePerformances, (e) => e.temperature)} °C",
                              theme),
                          _buildStatCard(
                              tirePerformances,
                              "Average Wear: ${_calculateAverage(tirePerformances, (e) => e.wear)}",
                              theme),
                          _buildStatCard(
                              tirePerformances,
                              "Average Distance: ${_calculateAverage(tirePerformances, (e) => e.distanceTraveled)} KM",
                              theme),
                          _buildStatCard(
                              tirePerformances,
                              "Average Tread Depth: ${_calculateAverage(tirePerformances, (e) => e.treadDepth)} MM",
                              theme),
                          _buildGraph("Pressure Graph", "Pressure", theme,
                              tirePerformances),
                          _buildGraph("Temperature Graph", "Temperature", theme,
                              tirePerformances),
                          _buildGraph(
                              "Wear Graph", "Wear", theme, tirePerformances),
                          _buildGraph("Distance Travelled Graph", "Distance",
                              theme, tirePerformances),
                          _buildGraph("Tread Depth Graph", "Treaddepth", theme,
                              tirePerformances),
                        ],
                      ),
                    );
            } else {
              return Center(child: Text("Fail to Load Data"));
            }
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
      List<TirePerformance> tire, String title, ThemeData theme) {
    return Card(
      elevation: 2.h,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      color:
          theme.brightness == Brightness.dark ? Colors.grey[600] : Colors.white,
      child: Padding(
        padding: EdgeInsets.all(12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph(String title, String parameter, ThemeData theme,
      List<TirePerformance> tirePerformances) {
    return Padding(
      padding: EdgeInsets.only(top: 12.h),
      child: Container(
        padding: EdgeInsets.all(24.h),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12.r),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.r,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
            ),
            SizedBox(height: 10.h),
            SizedBox(
              height: 210.h,
              child: Chart(
                  tirePerformances: tirePerformances, parameter: parameter),
            ),
          ],
        ),
      ),
    );
  }
}
