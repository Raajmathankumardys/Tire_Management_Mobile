import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/models/trip_summary.dart';
import 'package:yaantrac_app/screens/expense_list_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

var _tripid;

class ExpenseScreen extends StatefulWidget {
  final int tripid;
  const ExpenseScreen({super.key, required this.tripid});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late Future<TripProfitSummaryModel> tripProfitSummary;

  Future<TripProfitSummaryModel> getTripProfit() async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips/summary?tripId=${widget.tripid}",
          DioMethod.get,
          contentType: "application/json");
      if (response.statusCode == 200) {
        Map<String, dynamic> tripProfit = response.data['data'];
        return TripProfitSummaryModel.fromJson(tripProfit);
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (err) {
      throw Exception("Error fetching summary: $err");
    }
  }

  @override
  void initState() {
    super.initState();
    tripProfitSummary = getTripProfit();
    _tripid = widget.tripid;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Trip View",
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
        elevation: 2,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehiclesListScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<TripProfitSummaryModel>(
            future: tripProfitSummary,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildShimmerEffect();
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData) {
                return const Center(child: Text("No report available"));
              } else {
                final tripProfitSummary = snapshot.data!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Trip San Francisco',
                      style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 3 / 2,
                      children: [
                        ExpenseCard(
                            title: 'Fuel Cost',
                            amount:
                                '\$${tripProfitSummary.breakDown["FUEL"] ?? 0}'),
                        ExpenseCard(
                            title: 'Driver Allowances',
                            amount:
                                '\$${tripProfitSummary.breakDown["DRIVER_ALLOWANCE"] ?? 0}'),
                        ExpenseCard(
                            title: 'Tolls',
                            amount:
                                '\$${tripProfitSummary.breakDown["TOLL"] ?? 0}'),
                        ExpenseCard(
                            title: 'Maintenance',
                            amount:
                                '\$${tripProfitSummary.breakDown["MAINTENANCE"] ?? 0}'),
                        ExpenseCard(
                            title: 'Miscellaneous',
                            amount:
                                '\$${tripProfitSummary.breakDown["MISCELLANEOUS"] ?? 0}'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                            child: SummaryCard(
                                title: 'Total Expenses',
                                amount:
                                    '\$${tripProfitSummary.totalExpenses}')),
                        Container(
                            child: SummaryCard(
                                title: 'Total Income',
                                amount: '\$${tripProfitSummary.totalIncome}')),
                        Container(
                            child: SummaryCard(
                                title: 'Profit',
                                amount: '\$${tripProfitSummary.profit}')),
                      ],
                    ),
                    const SizedBox(height: 16),
                    BreakdownDonutChart(breakdown: {
                      "FUEL": tripProfitSummary.breakDown["FUEL"]?.toDouble() ??
                          0.0,
                      "DRIVER_ALLOWANCE": tripProfitSummary
                              .breakDown["DRIVER_ALLOWANCE"]
                              ?.toDouble() ??
                          0.0,
                      "TOLL": tripProfitSummary.breakDown["TOLL"]?.toDouble() ??
                          0.0,
                      "MAINTENANCE": tripProfitSummary.breakDown["MAINTENANCE"]
                              ?.toDouble() ??
                          0.0,
                      "MISCELLANEOUS": tripProfitSummary
                              .breakDown["MISCELLANEOUS"]
                              ?.toDouble() ??
                          0.0,
                    }),
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppPrimaryButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ExpensesListScreen(tripId: _tripid)),
            );
          },
          title: "View Expenses",
        ),
      ),
    ));
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(7, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        );
      }),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;

  const ExpenseCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(amount,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;

  const SummaryCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54)),
            const SizedBox(height: 4),
            Text(amount,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent)),
          ],
        ),
      ),
    );
  }
}

class BreakdownDonutChart extends StatelessWidget {
  final Map<String, double> breakdown;

  const BreakdownDonutChart({super.key, required this.breakdown});

  Color _getColor(String category) {
    final colors = {
      "FUEL": Colors.blueAccent,
      "DRIVER_ALLOWANCE": Colors.green,
      "TOLL": Colors.orange,
      "MAINTENANCE": Colors.redAccent,
      "MISCELLANEOUS": Colors.purple,
    };
    return colors[category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: 180, // Adjust width for responsiveness
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: breakdown.entries.map((entry) {
                    return PieChartSectionData(
                      value: entry.value,
                      color: _getColor(entry.key),
                      radius: 40, // Adjusts segment size
                      showTitle: false, // Removes text inside pie chart
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 50, // Creates donut effect
                ),
              ),
            ),
            const SizedBox(width: 30),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: breakdown.entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: _getColor(entry.key),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      CustomPaint(
                        painter: ArrowPainter(),
                        child: const SizedBox(width: 15),
                      ),
                      Text(
                        entry.value.toInt().toString(), // Displays value
                        style: const TextStyle(
                            fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ],
    );
  }
}

// 🎯 Custom Painter for Drawing Arrows
class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width - 5, size.height / 2);
    path.lineTo(size.width - 8, size.height / 2 - 3);
    path.moveTo(size.width - 5, size.height / 2);
    path.lineTo(size.width - 8, size.height / 2 + 3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
