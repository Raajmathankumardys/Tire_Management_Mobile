import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../../cubit/tire_performance_state.dart';

class Chart extends StatelessWidget {
  final List<TirePerformance> tirePerformances;
  final String parameter;

  const Chart(
      {super.key, required this.tirePerformances, required this.parameter});

  List<FlSpot> getSpots() {
    return List.generate(
      tirePerformances.length,
      (index) => FlSpot((index).toDouble(), _getValue(tirePerformances[index])),
    );
  }

  double _getValue(TirePerformance model) {
    switch (parameter) {
      case tireperformancesconstants.pressure:
        return model.pressure;
      case tireperformancesconstants.temperature:
        return model.temperature;
      case tireperformancesconstants.wear:
        return model.wear;
      case tireperformancesconstants.distancet:
        return model.distanceTraveled;
      case tireperformancesconstants.treaddepth:
        return model.treadDepth;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200.h,
          child: LineChart(
            LineChartData(
              lineBarsData: [
                LineChartBarData(
                  spots: getSpots(),
                  isCurved: true,
                  barWidth: 2.h,
                  color: Colors.blue,
                  dotData: FlDotData(show: true),
                ),
              ],
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  axisNameWidget: Text(
                    parameter.toString(),
                    style:
                        TextStyle(fontSize: 10.h, fontWeight: FontWeight.bold),
                  ),
                  sideTitles: SideTitles(
                      showTitles: false), // Hide individual Y-axis values
                ),
                bottomTitles: AxisTitles(
                  axisNameWidget: Padding(
                    padding: EdgeInsets.only(top: 0.0),
                    child: Text(
                      tireperformancesconstants.readings,
                      style:
                          TextStyle(fontSize: 8.h, fontWeight: FontWeight.bold),
                    ),
                  ),
                  sideTitles: SideTitles(
                      showTitles: false), // Hide individual X-axis values
                ),
              ),
              gridData: FlGridData(show: true), // Shows grid lines
              borderData: FlBorderData(show: true),
            ),
          ),
        ),
      ],
    );
  }
}
