import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../../cubit/tire_performance_state.dart';

class Chart extends StatelessWidget {
  final List<TirePerformance> tirePerformances;
  final String parameter;

  const Chart({
    super.key,
    required this.tirePerformances,
    required this.parameter,
  });

  List<FlSpot> getSpots() {
    List<TirePerformance> last20Performances = tirePerformances.length > 20
        ? tirePerformances.sublist(tirePerformances.length - 20)
        : tirePerformances;
    return List.generate(
      last20Performances.length,
      (index) => FlSpot(index.toDouble(), _getValue(last20Performances[index])),
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

  LinearGradient getGradient() {
    switch (parameter) {
      case tireperformancesconstants.pressure:
        return LinearGradient(colors: [Colors.blue, Colors.lightBlueAccent]);
      case tireperformancesconstants.temperature:
        return LinearGradient(colors: [Colors.red, Colors.orange]);
      case tireperformancesconstants.wear:
        return LinearGradient(colors: [Colors.green, Colors.lightGreenAccent]);
      case tireperformancesconstants.distancet:
        return LinearGradient(colors: [Colors.teal, Colors.cyan]);
      case tireperformancesconstants.treaddepth:
        return LinearGradient(colors: [Colors.purple, Colors.deepPurpleAccent]);
      default:
        return LinearGradient(colors: [Colors.grey, Colors.black]);
    }
  }

  @override
  Widget build(BuildContext context) {
    double maxY = tirePerformances.fold<double>(
      double.negativeInfinity,
      (prev, element) => prev > _getValue(element) ? prev : _getValue(element),
    );

    double minY = tirePerformances.fold<double>(
      double.infinity,
      (prev, element) => prev < _getValue(element) ? prev : _getValue(element),
    );

    maxY += maxY * 0.1;
    minY -= minY * 0.1;

    return SizedBox(
      height: 240.h,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          lineBarsData: [
            LineChartBarData(
              spots: getSpots(),
              //isCurved: true,
              //isStepLineChart: true,
              //isStrokeJoinRound: true,
              gradient: getGradient(),
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: getGradient()
                      .colors
                      .map((c) => c.withOpacity(0.3))
                      .toList(),
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              axisNameWidget: Text(
                parameter,
                style: TextStyle(fontSize: 10.h, fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              axisNameWidget: Text(
                tireperformancesconstants.readings,
                style: TextStyle(fontSize: 8.h, fontWeight: FontWeight.bold),
              ),
              sideTitles: SideTitles(
                showTitles: true,
                interval: (tirePerformances.length / 5).toDouble(),
                getTitlesWidget: (value, _) => Text(
                  'R${value.toInt()}',
                  style: TextStyle(fontSize: 8.h),
                ),
              ),
            ),
          ),
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => Colors.deepPurple,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((touchedSpot) {
                  return LineTooltipItem(
                    '$parameter: ${touchedSpot.y.toStringAsFixed(1)}',
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }
}
