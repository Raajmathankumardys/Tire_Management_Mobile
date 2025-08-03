import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../Report/cubit/report_state.dart';

// Import your ComparisonData model

class ComparisonBarChart extends StatelessWidget {
  final List<Comparison> comparisonData;

  const ComparisonBarChart({super.key, required this.comparisonData});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.6,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceEvenly,
          barGroups: _generateBarGroups(),
          gridData: FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true, reservedSize: 42),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: _bottomTitles,
                reservedSize: 32,
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> groups = [];

    for (int i = 0; i < comparisonData.length; i++) {
      final data = comparisonData[i];
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data.income.toDouble(),
              color: Colors.green,
              width: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            BarChartRodData(
              toY: data.expenses.toDouble(),
              color: Colors.red,
              width: 12,
              borderRadius: BorderRadius.circular(6),
            ),
            BarChartRodData(
              toY: data.profit.toDouble(),
              color: Colors.blue,
              width: 12,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
          barsSpace: 4,
        ),
      );
    }

    return groups;
  }

  Widget _bottomTitles(double value, TitleMeta meta) {
    final index = value.toInt();
    if (index >= 0 && index < comparisonData.length) {
      final period = comparisonData[index].period;
      return SideTitleWidget(
        meta: meta,
        space: 8,
        child: Text(
          period, // e.g., May 2025
          style: const TextStyle(fontSize: 10),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}
