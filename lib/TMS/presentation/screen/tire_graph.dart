import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/tire_performance.dart';

class Chart extends StatelessWidget {
  final List<TirePerformanceModel> tirePerformances;
  final String parameter;

  const Chart(
      {super.key, required this.tirePerformances, required this.parameter});

  List<FlSpot> getSpots() {
    return List.generate(
      tirePerformances.length,
      (index) => FlSpot((index).toDouble(), _getValue(tirePerformances[index])),
    );
  }

  double _getValue(TirePerformanceModel model) {
    switch (parameter) {
      case 'Pressure':
        return model.pressure;
      case 'Temperature':
        return model.temperature;
      case 'Wear':
        return model.wear;
      case 'Distance':
        return model.distanceTraveled;
      case 'Treaddepth':
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
                      'Readings',
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
