import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../Report/cubit/report_state.dart';

class MonthlyBarChart extends StatelessWidget {
  final List<MonthlyData> monthlyData;

  const MonthlyBarChart({super.key, required this.monthlyData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          barGroups: _generateBarGroups(),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 42,
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
                reservedSize: 32,
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  /// Create bar groups dynamically for each month
  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < monthlyData.length; i++) {
      final data = monthlyData[i];
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data.income.toDouble(),
              color: Colors.green,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: data.expenses.toDouble(),
              color: Colors.red,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            BarChartRodData(
              toY: data.profit.toDouble(),
              color: Colors.blue,
              width: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return groups;
  }

  /// Month label for bottom x-axis
  Widget _bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < monthlyData.length) {
      final month = monthlyData[index].month;
      return SideTitleWidget(
        meta: meta, // ✅ Required in latest versions
        space: 8,
        child: Text(
          month,
          style: const TextStyle(fontSize: 10),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
