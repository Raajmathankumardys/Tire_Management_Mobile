import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yaantrac_app/Expense_Tracker/Report/cubit/report_state.dart';

class TripExpensesWidget extends StatelessWidget {
  final List<TripExpenses> tripExpenses;

  const TripExpensesWidget({Key? key, required this.tripExpenses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: tripExpenses.length,
      itemBuilder: (context, index) {
        final trip = tripExpenses[index];
        final Map<String, dynamic> categories = trip.expensesByCategory;

        final hasExpenses = trip.totalExpenses > 0 &&
            categories.values.any((value) => value > 0);

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip.tripName,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Total Expenses: ₹${trip.totalExpenses}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.blueAccent,
                  ),
                ),
                const SizedBox(height: 12),
                hasExpenses
                    ? SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 40,
                            sections: _buildChartSections(categories),
                          ),
                        ),
                      )
                    : const Text("No expenses to show in chart."),
              ],
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildChartSections(
      Map<String, dynamic> categories) {
    final colors = [
      Colors.red,
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.teal,
    ];

    final entries =
        categories.entries.where((entry) => (entry.value as num) > 0).toList();

    return List.generate(entries.length, (index) {
      final entry = entries[index];
      final value = (entry.value as num).toDouble();
      final color = colors[index % colors.length];

      return PieChartSectionData(
        color: color,
        value: value,
        title: "${entry.key}\n₹${value.toStringAsFixed(2)}",
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      );
    });
  }
}
