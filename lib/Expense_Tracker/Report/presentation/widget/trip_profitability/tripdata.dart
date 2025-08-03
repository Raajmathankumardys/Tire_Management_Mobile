import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../Report/cubit/report_state.dart';

class TripDataCard extends StatelessWidget {
  final TripData trip;

  const TripDataCard({super.key, required this.trip});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd');
    final startDate = dateFormat.parse(trip.startDate);
    final endDate = dateFormat.parse(trip.endDate);

    return CustomCard(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🟢 Trip Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    trip.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Chip(
                  label: Text(trip.status),
                  backgroundColor: _getStatusColor(trip.status),
                  labelStyle: const TextStyle(color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 6),

            /// 🚗 Driver + Vehicle
            Text(
              "${trip.driverName} • ${trip.vehicleNumber}",
              style: TextStyle(color: Colors.grey[700], fontSize: 14),
            ),

            const Divider(height: 20, thickness: 1),

            /// 📅 Dates
            _infoRow(
                Icons.calendar_today, "Start", dateFormat.format(startDate)),
            _infoRow(Icons.calendar_today_outlined, "End",
                dateFormat.format(endDate)),

            const SizedBox(height: 12),

            /// 💰 Income / Expense / Profit
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _moneyBox("Income", trip.income, Colors.green),
                _moneyBox("Expenses", trip.expenses, Colors.red),
                _moneyBox("Profit", trip.profit, Colors.blue),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Colored box for income/expense/profit
  Widget _moneyBox(String label, double amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.grey[600])),
        const SizedBox(height: 4),
        Text(
          "₹$amount",
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: color),
        ),
      ],
    );
  }

  /// Icon + label + value row
  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "PLANNED":
        return Colors.orange;
      case "ACTIVE":
        return Colors.blue;
      case "COMPLETED":
        return Colors.green;
      case "CANCELLED":
        return Colors.red;
      default:
        return Colors.pink;
    }
  }
}
