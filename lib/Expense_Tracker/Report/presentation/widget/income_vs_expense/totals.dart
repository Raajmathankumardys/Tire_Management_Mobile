import 'package:flutter/material.dart';

import '../../../../Report/cubit/report_state.dart';

class totals extends StatefulWidget {
  final IncomeVsExpense data;
  const totals({super.key, required this.data});

  @override
  State<totals> createState() => _buildIncomeVsExpenseState();
}

class _buildIncomeVsExpenseState extends State<totals> {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8, // Soft shadow for a modern look
      margin: const EdgeInsets.all(16), // Adding outer margin for spacing
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(16), // Rounded corners for a smoother look
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100
            ], // Soft gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          title: Center(
            child: Text(
              'Totals',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue.shade800,
                letterSpacing: 1.2,
              ),
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatRow(
                  'Total Income', widget.data.totals.totalIncome, Colors.green),
              _buildStatRow('Total Expenses', widget.data.totals.totalExpenses,
                  Colors.red),
              _buildStatRow(
                  'Total Profit', widget.data.totals.totalProfit, Colors.blue),
              Row(
                children: [
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.amber,
                    size: 22,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Profit Percentage: ${widget.data.totals.profitPercentage.toStringAsFixed(2)} %',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(
            Icons.arrow_forward,
            color: color,
            size: 22,
          ),
          SizedBox(width: 10),
          Text(
            '$label: ${value.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: color,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
