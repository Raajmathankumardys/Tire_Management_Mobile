import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/models/trip_summary.dart';
import 'package:yaantrac_app/models/vehicle.dart';
import 'package:yaantrac_app/screens/Homepage.dart';
import 'package:yaantrac_app/screens/expense_list_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

var _tripid;

class ExpenseScreen extends StatefulWidget {
  final int tripid;
  final Vehicle? ve;
  const ExpenseScreen({super.key, required this.tripid, this.ve});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late Future<TripProfitSummaryModel> tripProfitSummary;
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

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
    final theme = Theme.of(context);
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Trip View",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: theme.brightness == Brightness.dark
            ? Colors.black
            : Colors.blueAccent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
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
                    widget.ve != null
                        ? Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            color: theme.brightness == Brightness.dark
                                ? Colors.grey[900]
                                : Colors.white,
                            margin: EdgeInsets.all(10),
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      "Trip Details",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                      'Vehicle Number: ${widget.ve!.vehicleNumber}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 6),
                                  Text('Driver Name: ${widget.ve!.driverName}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 6),
                                  Text(
                                      'Start Date: ${_formatDate(widget.ve!.startDate)}',
                                      style: TextStyle(fontSize: 18)),
                                  Text(
                                      'End Date: ${_formatDate(widget.ve!.endDate)}',
                                      style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 6),
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SummaryCard(
                            title: 'Total Expenses',
                            amount: '\$${tripProfitSummary.totalExpenses}',
                            theme: theme),
                        SummaryCard(
                            title: 'Total Income',
                            amount: '\$${tripProfitSummary.totalIncome}',
                            theme: theme),
                        SummaryCard(
                            title: 'Profit',
                            amount: '\$${tripProfitSummary.profit}',
                            theme: theme),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Card(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, // Align title to the left
                                children: [
                                  Text(
                                    "Expense Breakdown",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                      height:
                                          8), // Spacing between title and table
                                ],
                              ),
                              Container(
                                child: ExpenseTable(
                                    breakDown: tripProfitSummary.breakDown),
                              )
                            ],
                          )),
                    ),
                    const SizedBox(height: 30),
                    Card(
                      color: theme.brightness == Brightness.dark
                          ? Colors.grey[900]
                          : Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            "Expense Distribution",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: EdgeInsets.all(8),
                            child: BreakdownDonutChart(breakdown: {
                              "FUEL": tripProfitSummary.breakDown["FUEL"]
                                      ?.toDouble() ??
                                  0.0,
                              "DRIVER_ALLOWANCE": tripProfitSummary
                                      .breakDown["DRIVER_ALLOWANCE"]
                                      ?.toDouble() ??
                                  0.0,
                              "TOLL": tripProfitSummary.breakDown["TOLL"]
                                      ?.toDouble() ??
                                  0.0,
                              "MAINTENANCE": tripProfitSummary
                                      .breakDown["MAINTENANCE"]
                                      ?.toDouble() ??
                                  0.0,
                              "MISCELLANEOUS": tripProfitSummary
                                      .breakDown["MISCELLANEOUS"]
                                      ?.toDouble() ??
                                  0.0,
                            }),
                          )
                        ],
                      ),
                    )
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

class ExpenseTable extends StatelessWidget {
  final Map<String, dynamic> breakDown;

  ExpenseTable({required this.breakDown});

  @override
  Widget build(BuildContext context) {
    double total = breakDown.values.fold(0, (sum, value) => sum + value);

    return DataTable(
      columnSpacing: 20.0,
      columns: [
        DataColumn(label: Text('Category')),
        DataColumn(label: Text('Amount')),
        DataColumn(label: Text('Percentage')),
      ],
      rows: breakDown.entries.map((entry) {
        double percentage = total > 0 ? (entry.value / total) * 100 : 0;
        return DataRow(cells: [
          DataCell(Text(entry.key.replaceAll('_', ' '))), // Formatting names
          DataCell(Text('\$${entry.value.toStringAsFixed(2)}')),
          DataCell(Text('${percentage.toStringAsFixed(2)}%')),
        ]);
      }).toList(),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final ThemeData theme;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      color:
          theme.brightness == Brightness.dark ? Colors.grey[900] : Colors.white,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                )),
            const SizedBox(height: 4),
            Text(amount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
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
                            fontSize: 8, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 8),
                      CustomPaint(
                        painter: ArrowPainter(),
                        child: const SizedBox(width: 13),
                      ),
                      Text(
                        entry.value.toInt().toString(), // Displays value
                        style: const TextStyle(
                            fontSize: 8, fontWeight: FontWeight.bold),
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
      ..color = Colors.grey
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
