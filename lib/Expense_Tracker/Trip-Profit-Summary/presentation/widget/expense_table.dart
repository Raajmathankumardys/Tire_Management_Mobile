import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpenseTable extends StatelessWidget {
  final Map<String, dynamic> breakDown;

  ExpenseTable({required this.breakDown});

  @override
  Widget build(BuildContext context) {
    double total = breakDown.values.fold(0, (sum, value) => sum + value);

    return Center(
      child: DataTable(
        columnSpacing: 35.h,
        columns: [
          DataColumn(
              label: Text('Category',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Percentage',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          ...breakDown.entries.map((entry) {
            double percentage = total > 0 ? (entry.value / total) * 100 : 0;
            return DataRow(cells: [
              DataCell(
                  Text(entry.key.replaceAll('_', ' '))), // Formatting names
              DataCell(Text('\₹${entry.value.toStringAsFixed(2)}')),
              DataCell(Text('${percentage.toStringAsFixed(2)}%')),
            ]);
          }).toList(),
          // Adding the Total row
          DataRow(
            cells: [
              DataCell(Text(
                'TOTAL',
              )),
              DataCell(Text('\₹${total.toStringAsFixed(2)}')),
              DataCell(Text(
                '100%',
              )),
            ], // Optional: Background color for the total row
          ),
        ],
      ),
    );
  }
}
