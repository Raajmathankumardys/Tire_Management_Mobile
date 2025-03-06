import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title:
            Text("Tire Performance", style: GoogleFonts.poppins(fontSize: 20)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => TiresListScreen()),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : tirePerformances.isEmpty
              ? Center(
                  child: Text(
                    "No data available",
                    style: GoogleFonts.poppins(fontSize: 18),
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                  child: Column(
                    children: [
                      _buildStatCard("Average Pressure",
                          "${_calculateAverage((e) => e.pressure)} PSI"),
                      _buildStatCard("Average Temperature",
                          "${_calculateAverage((e) => e.temperature)} °C"),
                      _buildStatCard("Average Wear",
                          "${_calculateAverage((e) => e.wear)}"),
                      _buildStatCard("Average Distance",
                          "${_calculateAverage((e) => e.distanceTraveled)} KM"),
                      _buildGraph("Pressure Graph", "Pressure"),
                      _buildGraph("Temperature Graph", "Temperature"),
                      _buildGraph("Wear Graph", "Wear"),
                      _buildGraph("Distance Travelled Graph", "Distance"),
                    ],
                  ),
                ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8),
        child: AppPrimaryButton(
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(
                builder: (_) => AddPerformanceScreen(tid: widget.tireId)),
          ),
          title: "Add Tire Performance",
        ),
      ),
    ));
  }

  Widget _buildStatCard(String title, String value) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: GoogleFonts.poppins(fontSize: 16)),
            Text(value,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildGraph(String title, String parameter) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 4)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
                height: 300,
                child: LineChartWidget(
                    tirePerformances: tirePerformances, parameter: parameter)),
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
    return LineChart(LineChartData(
      lineBarsData: [
        LineChartBarData(
            spots: getSpots(), isCurved: true, dotData: FlDotData(show: true))
      ],
    ));
  }
}
