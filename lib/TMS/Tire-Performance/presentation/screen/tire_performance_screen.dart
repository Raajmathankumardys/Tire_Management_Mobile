import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/screen/add_edit_modal_tire_performance.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/widget/buildstatcard.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/constants.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../cubit/tire_performance_cubit.dart';
import '../../cubit/tire_performance_state.dart';
import '../widget/buildgraph.dart';

class Tire_Performance_Screen extends StatefulWidget {
  final TireInventory? tire;
  final int id;
  const Tire_Performance_Screen({super.key, this.tire, required this.id});
  @override
  State<Tire_Performance_Screen> createState() => _TirePerformanceState();
}

class _TirePerformanceState extends State<Tire_Performance_Screen> {
  void _showAddModal(BuildContext ctx, {required int tireId}) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (
          context,
        ) {
          return add_edit_modal_tire_performance(
            ctx: ctx,
            tireId: widget.id,
          );
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
          leading: Text(''),
          actions: [
            IconButton(
              onPressed: () {
                print(context);
                _showAddModal(context, tireId: widget.id);
              },
              icon: Icon(
                Icons.add_circle,
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black,
              ),
            )
          ],
        ),
        body: RefreshIndicator(
          child: BlocConsumer<TirePerformanceCubit, TirePerformanceState>(
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
                  child: shimmer(
                    count: 7,
                  ),
                );
              } else if (state is TirePerformanceError) {
                return Center(
                  child: Text(state.message.toString()),
                );
              } else if (state is TirePerformanceLoaded) {
                final tirePerformances = state.tireperformance;
                print(tirePerformances.length);
                return tirePerformances.isEmpty
                    ? Center(
                        child: Text(tireperformancesconstants.noperformance))
                    : SingleChildScrollView(
                        padding: EdgeInsets.all(16.h),
                        child: Column(
                          children: [
                            buildstatcard(
                                tire: tirePerformances,
                                title:
                                    "${tireperformancesconstants.average + " " + tireperformancesconstants.pressure}: ${_calculateAverage(tirePerformances, (e) => e.pressure)} ${tireperformancesconstants.psi}",
                                theme: theme),
                            buildstatcard(
                                tire: tirePerformances,
                                title:
                                    "${tireperformancesconstants.average + " " + tireperformancesconstants.temperature}: ${_calculateAverage(tirePerformances, (e) => e.temperature)} ${tireperformancesconstants.degreec}",
                                theme: theme),
                            buildstatcard(
                                tire: tirePerformances,
                                title:
                                    "${tireperformancesconstants.average + " " + tireperformancesconstants.wear}: ${_calculateAverage(tirePerformances, (e) => e.wear)}",
                                theme: theme),
                            buildstatcard(
                                tire: tirePerformances,
                                title:
                                    "${tireperformancesconstants.average + " " + tireperformancesconstants.distance}: ${_calculateAverage(tirePerformances, (e) => e.distanceTraveled)} ${tireperformancesconstants.km}",
                                theme: theme),
                            buildstatcard(
                                tire: tirePerformances,
                                title:
                                    "${tireperformancesconstants.average + " " + tireperformancesconstants.treaddepth}: ${_calculateAverage(tirePerformances, (e) => e.treadDepth)} ${tireperformancesconstants.mm}",
                                theme: theme),
                            buildgraph(
                                title:
                                    "${tireperformancesconstants.pressure + " " + tireperformancesconstants.graph}",
                                parameter: tireperformancesconstants.pressure,
                                theme: theme,
                                tirePerformances: tirePerformances),
                            buildgraph(
                                title:
                                    "${tireperformancesconstants.temperature + " " + tireperformancesconstants.graph}",
                                parameter:
                                    tireperformancesconstants.temperature,
                                theme: theme,
                                tirePerformances: tirePerformances),
                            buildgraph(
                                title:
                                    "${tireperformancesconstants.wear + " " + tireperformancesconstants.graph}",
                                parameter: tireperformancesconstants.wear,
                                theme: theme,
                                tirePerformances: tirePerformances),
                            buildgraph(
                                title:
                                    "${tireperformancesconstants.distance + " " + tireperformancesconstants.graph}",
                                parameter: tireperformancesconstants.distancet,
                                theme: theme,
                                tirePerformances: tirePerformances),
                            buildgraph(
                                title:
                                    "${tireperformancesconstants.treaddepth + " " + tireperformancesconstants.graph}",
                                parameter: tireperformancesconstants.treaddepth,
                                theme: theme,
                                tirePerformances: tirePerformances),
                          ],
                        ),
                      );
              } else {
                return Center(child: Text(tireperformancesconstants.fail));
              }
            },
          ),
          onRefresh: () async => {
            context.read<TirePerformanceCubit>().fetchTirePerformance(widget.id)
          },
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
