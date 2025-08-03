import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class buildExpensePieChartWithTable extends StatefulWidget {
  final List categories;
  const buildExpensePieChartWithTable({super.key, required this.categories});

  @override
  State<buildExpensePieChartWithTable> createState() =>
      _buildExpensePieChartWithTableState();
}

class _buildExpensePieChartWithTableState
    extends State<buildExpensePieChartWithTable> {
  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> sections =
        widget.categories.map<PieChartSectionData>((cat) {
      return PieChartSectionData(
        value: cat.amount.toDouble(),
        title: '${cat.percentage.toStringAsFixed(2)}%',
        color: _getColorForCategory(cat.category),
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      );
    }).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              borderData: FlBorderData(show: false),
            ),
          ),
        ),
        const SizedBox(height: 12),
        _buildLegend(widget.categories),
        const SizedBox(height: 16),
        _buildExpenseTable(widget.categories),
      ],
    );
  }

  Widget _buildLegend(List categories) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: categories.map((cat) {
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12.w,
                height: 12.h,
                decoration: BoxDecoration(
                  color: _getColorForCategory(cat.category),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                cat.category,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildExpenseTable(List categories) {
    return DataTable(
      columnSpacing: 16,
      dataRowMinHeight: 28,
      dataRowMaxHeight: 32,
      headingRowHeight: 30,
      columns: [
        DataColumn(
          columnWidth: FixedColumnWidth(150.h),
          label: Text(
            'Category',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          columnWidth: FixedColumnWidth(80.h),
          label: Text(
            'Amount (₹)',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
        DataColumn(
          label: Text(
            'Percentage',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
      rows: categories.map<DataRow>((cat) {
        return DataRow(
          cells: [
            DataCell(Text(cat.category,
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: _getColorForCategory(cat.category)))),
            DataCell(Text('₹${cat.amount.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 11))),
            DataCell(Text('${cat.percentage.toStringAsFixed(2)}%',
                style: const TextStyle(fontSize: 11))),
          ],
        );
      }).toList(),
    );
  }

  Color _getColorForCategory(String category) {
    switch (category) {
      case 'FUEL':
        return Colors.red;
      case 'MAINTENANCE':
        return Colors.blue;
      case 'TOLL':
        return Colors.green;
      case 'MISCELLANEOUS':
        return Colors.orange;
      case "DRIVER_ALLOWANCE":
        return Colors.purpleAccent;
      default:
        return Colors.grey;
    }
  }
}
