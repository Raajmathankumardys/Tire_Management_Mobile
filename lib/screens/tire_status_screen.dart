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
  List<TirePerformanceModel> tirePerformances=[];
  bool isLoading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTireStatus();

  }
  Future<void> fetchTireStatus()async{
    try {
      final response=await APIService.instance.request("/tires/${widget.tireId}/performances",DioMethod.get);
      if(response.statusCode==200)
      {
        Map<String, dynamic> responseData = response.data;
        List<dynamic> performanceList = responseData['data'];
        setState(() {
          tirePerformances=performanceList.map((json)=>TirePerformanceModel.fromJson(json)).toList();
          isLoading=false;
        });
        print(tirePerformances);

      }
      else{
        print(response.statusMessage);
      }
    }
    catch(err){
      print(err);
    }

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Icon(Icons.search),
        ],
        title: const Align(
          alignment: Alignment.centerLeft,
          child: Text("Tires", style: TextStyle(fontSize: 20)),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Tabs section
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 13, top: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xFF0D7CF2),
                                  width: 3,
                                ),
                              ),
                            ),
                            child: const Text(
                              'All',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(bottom: 13, top: 16),
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.transparent,
                                  width: 3,
                                ),
                              ),
                            ),
                            child: const Text(
                              'Low Pressure',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF49719C),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Recently Added Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Recently added',
                        style: TextStyle(
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
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Fleet 3, Vehicle 1',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black,
                                ),
                              ),
                              Text(
                                'Status: In Service',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF49719C),
                                ),
                              ),
                              Text(
                                '235/45ZR18',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
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
              // Pressure Card Section
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFCEDBE8)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pressure',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '30PSI',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Today',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Color(0xFF49719C),
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(
                            '+2%',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF078838),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 148,
                        child: LineChartWidget()
                      ),
                      SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 30),
              FlSpot(1, 32),
              FlSpot(2, 28),
              FlSpot(3, 34),
              FlSpot(4, 30),
              FlSpot(5, 33),
              FlSpot(6, 31),
            ],
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }
}
