import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
import 'package:yaantrac_app/screens/Homepage.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import '../common/widgets/button/app_primary_button.dart';
import 'add_performance_screen.dart';

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
        var performanceList = response.data['data'] as List<dynamic>;
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
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Tire Performance"),
          ),
          backgroundColor: theme.brightness == Brightness.dark
              ? Colors.black
              : Colors.blueAccent,
          leading: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black),
              onPressed: () => Navigator.pop(context)),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : tirePerformances.isEmpty
                ? Center(
                    child: Text(
                      "No data available",
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildStatCard(
                            "Average Pressure",
                            "${_calculateAverage((e) => e.pressure)} PSI",
                            theme),
                        _buildStatCard(
                            "Average Temperature",
                            "${_calculateAverage((e) => e.temperature)} °C",
                            theme),
                        _buildStatCard("Average Wear",
                            "${_calculateAverage((e) => e.wear)}", theme),
                        _buildStatCard(
                            "Average Distance",
                            "${_calculateAverage((e) => e.distanceTraveled)} KM",
                            theme),
                        _buildGraph("Pressure Graph", "Pressure", theme),
                        _buildGraph("Temperature Graph", "Temperature", theme),
                        _buildGraph("Wear Graph", "Wear", theme),
                        _buildGraph(
                            "Distance Travelled Graph", "Distance", theme),
                      ],
                    ),
                  ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8),
          child: AppPrimaryButton(
            onPressed: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (_) => AddPerformanceScreen(tid: widget.tireId)),
            ),
            title: "Add Tire Performance",
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, ThemeData theme) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color:
          theme.brightness == Brightness.dark ? Colors.grey[600] : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
            ),
            Text(
              value,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph(String title, String parameter, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.dividerColor),
          borderRadius: BorderRadius.circular(12),
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 300,
              child: LineChartWidget(
                  tirePerformances: tirePerformances, parameter: parameter),
            ),
          ],
        ),
      ),
    );
  }

  String _calculateAverage(double Function(TirePerformanceModel) selector) {
    if (tirePerformances.isEmpty) return "0";
    double sum = tirePerformances.map(selector).reduce((a, b) => a + b);
    return (sum / tirePerformances.length).toStringAsFixed(2);
  }
}

class LineChartWidget extends StatelessWidget {
  final List<TirePerformanceModel> tirePerformances;
  final String parameter;

  const LineChartWidget(
      {super.key, required this.tirePerformances, required this.parameter});

  List<FlSpot> getSpots() {
    return List.generate(
      tirePerformances.length,
      (index) => FlSpot(index.toDouble(), _getValue(tirePerformances[index])),
    );
  }

  double _getValue(TirePerformanceModel model) {
    switch (parameter) {
      case 'Pressure':
        return model.pressure;
      case 'Temperature':
        return model.temperature;
      case 'Wear':
        return model.wear;
      case 'Distance':
        return model.distanceTraveled;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LineChart(LineChartData(lineBarsData: [
      LineChartBarData(
          spots: getSpots(), isCurved: true, dotData: FlDotData(show: true))
    ]));
  }
}
