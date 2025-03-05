import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
import 'package:yaantrac_app/services/api_service.dart';

class TireStatusScreen extends StatefulWidget {
  final int tireId;

  const TireStatusScreen({super.key, required this.tireId});

  @override
  State<TireStatusScreen> createState() => _TireStatusScreenState();
}

class _TireStatusScreenState extends State<TireStatusScreen> {
  bool isLoading = true;
  List<TirePerformanceModel> tirePerformances = [];

  @override
  void initState() {
    super.initState();
    fetchTireStatus();
  }

  Future<void> fetchTireStatus() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tires/${widget.tireId}/performances",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = response.data;
        var performanceList = responseData['data'] as List<dynamic>;

        List<TirePerformanceModel> fetchedData = performanceList
            .map((json) => TirePerformanceModel.fromJson(json))
            .toList();

        setState(() {
          tirePerformances = fetchedData;
          isLoading = false;
        });
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching tires: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        actions: const [
          Icon(Icons.search),
        ],
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Tire Performance", style: TextStyle(fontSize: 20)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tirePerformances.isEmpty
              ? const Center(
                  child: Text(
                  "No data available",
                  style: TextStyle(fontSize: 18),
                ))
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Last updated at ${tirePerformances.first.localDateTime}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Card(
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    color: Colors.grey[50],
                                    width: double.infinity,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Pressure: ${tirePerformances.first.pressure} PSI',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF49719C),
                                          ),
                                        ),
                                        Text(
                                          'Temperature: ${tirePerformances.first.temperature} °C',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF49719C),
                                          ),
                                        ),
                                        Text(
                                          'Wear: ${tirePerformances.first.wear}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF49719C),
                                          ),
                                        ),
                                        Text(
                                          'Distance Traveled: ${tirePerformances.first.distanceTraveled} KM',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            color: Color(0xFF49719C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: const Color(0xFFCEDBE8)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Tire Performance Graph',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 50),
                                SizedBox(
                                  height: 300,
                                  child: LineChartWidget(
                                      tirePerformances: tirePerformances),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    ));
  }
}

class LineChartWidget extends StatelessWidget {
  final List<TirePerformanceModel> tirePerformances;

  const LineChartWidget({super.key, required this.tirePerformances});

  @override
  Widget build(BuildContext context) {
    if (tirePerformances.isEmpty) {
      return const Center(child: Text("No performance data available"));
    }
    return SizedBox(
      height: 300,
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(
                    0,
                    tirePerformances.isNotEmpty
                        ? tirePerformances[0].pressure
                        : 0),
                FlSpot(
                    1,
                    tirePerformances.isNotEmpty
                        ? tirePerformances[0].temperature
                        : 0),
                FlSpot(2,
                    tirePerformances.isNotEmpty ? tirePerformances[0].wear : 0),
                FlSpot(
                    3,
                    tirePerformances.isNotEmpty
                        ? tirePerformances[0].distanceTraveled
                        : 0),
              ],
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
      ),
    );
  }
}
