import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:yaantrac_app/helpers/components/shimmer.dart';
import '../cubit/dashboard_cubit.dart';
import '../cubit/dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Set<String> selectedStats = {'avgPressure'};
  int selectedYear = DateTime.now().year;
  List<int> availableYears = [];

  final availableStats = {
    'avgPressure': Colors.blue,
    'avgTemperature': Colors.red,
    'avgTreadDepth': Colors.green,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardCubit, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return shimmer();
          } else if (state is DashboardError) {
            return Center(child: Text(state.message));
          } else if (state is DashboardLoaded) {
            final d = state.dashboard;
            final filteredTireStats = d.monthlyTireStats
                .where((e) => e.year == selectedYear)
                .toList();
            final filteredAlertTrends =
                d.alertTrends.where((e) => e.year == selectedYear).toList();

            availableYears = {
              ...d.monthlyTireStats.map((e) => e.year),
              ...d.alertTrends.map((e) => e.year),
            }.toList()
              ..sort();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSection("Tire Summary", [
                    _buildStatCard(
                        "Total Tires", d.totalTires, Icons.tire_repair_outlined,
                        color: Colors.purple),
                    _buildStatCard("In Use", d.tiresInUse, LucideIcons.truck,
                        color: Colors.teal),
                    _buildStatCard(
                        "In Stock", d.tiresInStock, LucideIcons.warehouse,
                        color: Colors.orange),
                  ]),
                  _buildSection("Vehicle Summary", [
                    _buildStatCard("Total", d.totalVehicles, LucideIcons.car,
                        color: Colors.blue),
                    _buildStatCard(
                        "Active", d.vehiclesActive, LucideIcons.checkCircle,
                        color: Colors.green),
                    _buildStatCard("Maintenance", d.vehiclesInMaintenance,
                        LucideIcons.wrench,
                        color: Colors.redAccent),
                  ]),
                  _buildSection("Alert Summary", [
                    _buildStatCard("Active Alerts", d.alertsActive,
                        LucideIcons.alertCircle,
                        color: Colors.deepPurple),
                    _buildStatCard("Scheduled", d.maintenanceScheduled,
                        LucideIcons.calendarClock,
                        color: Colors.indigo),
                  ]),
                  _buildSection("Financial Summary", [
                    _buildStatCard(
                        "Income", "₹${d.totalIncome}", LucideIcons.trendingUp,
                        color: Colors.green),
                    _buildStatCard("Expenses", "₹${d.totalExpenses}",
                        LucideIcons.trendingDown,
                        color: Colors.red),
                    _buildStatCard(
                        "Profit", "₹${d.netProfit}", LucideIcons.banknote,
                        color: Colors.lightGreen),
                    _buildStatCard("Avg Profit/Trip",
                        "₹${d.averageProfitPerTrip}", LucideIcons.barChart2,
                        color: Colors.deepOrange),
                  ]),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildChartTitle(
                          "Monthly Tire Stats", LucideIcons.activity),
                      DropdownButton<int>(
                        value: selectedYear,
                        items: availableYears
                            .map((year) => DropdownMenuItem(
                                  value: year,
                                  child: Text(year.toString()),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedYear = value;
                            });
                          }
                        },
                      )
                    ],
                  ),
                  _buildStatSelector(),
                  const SizedBox(height: 16),
                  _buildMultiTireLineChart(filteredTireStats),
                  const SizedBox(height: 20),
                  _buildChartTitle(
                      "Monthly Alert Trends", LucideIcons.alertOctagon),
                  _buildAlertBarChart(filteredAlertTrends),
                  _buildAlertBarChartLegend()
                ],
              ),
            );
          }
          return const Center(child: Text("No data found"));
        },
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> cards) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.6,
          children: cards,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStatCard(String title, dynamic value, IconData icon,
      {Color? color}) {
    final Color primary = color ?? Colors.blue;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          colors: [primary.withOpacity(0.7), primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: primary.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 18,
            child: Icon(icon, size: 20.sp, color: primary),
          ),
          Text(title,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
          Text(value.toString(),
              style: TextStyle(color: Colors.white, fontSize: 14.sp)),
        ],
      ),
    );
  }

  Widget _buildChartTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.blueAccent),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatSelector() {
    return Wrap(
      spacing: 12,
      children: availableStats.entries.map((entry) {
        final stat = entry.key;
        final color = entry.value;
        final selected = selectedStats.contains(stat);

        return FilterChip(
          label: Text(stat.replaceAll('avg', '').toUpperCase()),
          selected: selected,
          backgroundColor: color.withOpacity(0.3),
          selectedColor: color,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                selectedStats.add(stat);
              } else {
                selectedStats.remove(stat);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildMultiTireLineChart(List<dynamic> stats) {
    final lines = selectedStats.map((stat) {
      final color = availableStats[stat] ?? Colors.grey;
      final spots = stats.asMap().entries.map((e) {
        final index = e.key;
        final statData = e.value;
        double value;
        switch (stat) {
          case 'avgPressure':
            value = statData.avgPressure;
            break;
          case 'avgTemperature':
            value = statData.avgTemperature;
            break;
          case 'avgTreadDepth':
            value = statData.avgTreadDepth;
            break;
          default:
            value = 0;
        }
        return FlSpot(index.toDouble(), value);
      }).toList();

      return LineChartBarData(
        spots: spots,
        isCurved: true,
        color: color,
        barWidth: 3,
        dotData: FlDotData(show: true),
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: stats.length * 60,
              child: LineChart(
                LineChartData(
                  lineBarsData: lines,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 1,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < stats.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text(stats[index].month),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBarChart(List<dynamic> alerts) {
    final barGroups = alerts.asMap().entries.map((e) {
      final index = e.key;
      final a = e.value;
      return BarChartGroupData(x: index, barRods: [
        BarChartRodData(
            toY: (a.pressureAlerts ?? 0).toDouble(), color: Colors.red),
        BarChartRodData(
            toY: (a.temperatureAlerts ?? 0).toDouble(), color: Colors.orange),
        BarChartRodData(
            toY: (a.wearAlerts ?? 0).toDouble(), color: Colors.blue),
        BarChartRodData(
            toY: (a.maintenanceAlerts ?? 0).toDouble(), color: Colors.green),
      ]);
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 250,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: alerts.length * 80,
              child: BarChart(
                BarChartData(
                  barGroups: barGroups,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, _) {
                          final index = value.toInt();
                          if (index >= 0 && index < alerts.length) {
                            return Text(alerts[index].month);
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  barTouchData: BarTouchData(enabled: true),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAlertBarChartLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: const [
          _LegendItem(color: Colors.red, label: "Pressure"),
          _LegendItem(color: Colors.orange, label: "Temperature"),
          _LegendItem(color: Colors.blue, label: "Wear"),
          _LegendItem(color: Colors.green, label: "Maintenance"),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
