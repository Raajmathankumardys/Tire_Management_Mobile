import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/Expense_Tracker/Expense/cubit/expense_state.dart';

import '../../../../helpers/constants.dart';

class ExpenseTable extends StatelessWidget {
  final Map<String, double> breakDown;

  ExpenseTable({required this.breakDown});

  @override
  Widget build(BuildContext context) {
    double total = breakDown.values.fold(0, (sum, value) => sum + value);

    return Center(
      child: DataTable(
        columnSpacing: 25.h,
        columns: [
          DataColumn(
              label: Text(tripprofitsummary.category,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text(tripprofitsummary.amount,
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text(tripprofitsummary.percentage,
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          ...breakDown.entries.map((entry) {
            double percentage = total > 0 ? (entry.value / total) * 100 : 0;
            return DataRow(cells: [
              DataCell(Text(
                  entry.key.toString().split('.').last)), // Formatting names
              DataCell(Text(
                  '${tripprofitsummary.rupees}${entry.value.toStringAsFixed(2)}')),
              DataCell(Text(
                  '${percentage.toStringAsFixed(2)}${tripprofitsummary.percentsymbol}')),
            ]);
          }).toList(),
          // Adding the Total row
          DataRow(
            cells: [
              DataCell(Text(
                tripprofitsummary.total,
              )),
              DataCell(Text(
                  '${tripprofitsummary.rupees}${total.toStringAsFixed(2)}')),
              DataCell(Text(
                tripprofitsummary.percent100,
              )),
            ], // Optional: Background color for the total row
          ),
        ],
      ),
    );
  }
}
