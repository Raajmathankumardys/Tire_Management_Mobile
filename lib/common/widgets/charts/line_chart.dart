import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yaantrac_app/models/tire_performance.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget(List<TirePerformanceModel> list, {super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 20),
              FlSpot(1, 32),
              FlSpot(2, 28),
              FlSpot(3, 34),
              FlSpot(4, 30),
              FlSpot(5, 33),
              FlSpot(6, 31),
            ],
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
