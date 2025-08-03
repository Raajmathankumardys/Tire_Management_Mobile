class DashboardModel {
  final int totalTires;
  final int tiresInUse;
  final int tiresInStock;
  final int totalVehicles;
  final int vehiclesActive;
  final int vehiclesInMaintenance;
  final int alertsActive;
  final int maintenanceScheduled;
  final List<MonthlyTireStats> monthlyTireStats;
  final List<AlertTrend> alertTrends;
  final double totalIncome;
  final double totalExpenses;
  final double netProfit;
  final double averageProfitPerTrip;

  DashboardModel({
    required this.totalTires,
    required this.tiresInUse,
    required this.tiresInStock,
    required this.totalVehicles,
    required this.vehiclesActive,
    required this.vehiclesInMaintenance,
    required this.alertsActive,
    required this.maintenanceScheduled,
    required this.monthlyTireStats,
    required this.alertTrends,
    required this.totalIncome,
    required this.totalExpenses,
    required this.netProfit,
    required this.averageProfitPerTrip,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalTires: json['totalTires'],
      tiresInUse: json['tiresInUse'],
      tiresInStock: json['tiresInStock'],
      totalVehicles: json['totalVehicles'],
      vehiclesActive: json['vehiclesActive'],
      vehiclesInMaintenance: json['vehiclesInMaintenance'],
      alertsActive: json['alertsActive'],
      maintenanceScheduled: json['maintenanceScheduled'],
      monthlyTireStats: (json['monthlyTireStats'] as List)
          .map((e) => MonthlyTireStats.fromJson(e))
          .toList(),
      alertTrends: (json['alertTrends'] as List)
          .map((e) => AlertTrend.fromJson(e))
          .toList(),
      totalIncome: json['totalIncome'],
      totalExpenses: json['totalExpenses'],
      netProfit: json['netProfit'],
      averageProfitPerTrip: json['averageProfitPerTrip'],
    );
  }
}

class MonthlyTireStats {
  final String month;
  final int year;
  final double avgTreadDepth;
  final double avgPressure;
  final double avgTemperature;

  MonthlyTireStats({
    required this.month,
    required this.year,
    required this.avgTreadDepth,
    required this.avgPressure,
    required this.avgTemperature,
  });

  factory MonthlyTireStats.fromJson(Map<String, dynamic> json) {
    return MonthlyTireStats(
      month: json['month'] ?? 'Unknown',
      year: json['year'] ?? 0,
      avgTreadDepth: (json['avgTreadDepth'] ?? 0).toDouble(),
      avgPressure: (json['avgPressure'] ?? 0).toDouble(),
      avgTemperature: (json['avgTemperature'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'month': month,
      'year': year,
      'avgTreadDepth': avgTreadDepth,
      'avgPressure': avgPressure,
      'avgTemperature': avgTemperature,
    };
  }
}

class AlertTrend {
  final String month;
  final int year;
  final int pressureAlerts;
  final int temperatureAlerts;
  final int wearAlerts;
  final int maintenanceAlerts;

  AlertTrend({
    required this.month,
    required this.year,
    required this.pressureAlerts,
    required this.temperatureAlerts,
    required this.wearAlerts,
    required this.maintenanceAlerts,
  });

  factory AlertTrend.fromJson(Map<String, dynamic> json) {
    return AlertTrend(
      month: json['month'],
      year: json['year'],
      pressureAlerts: json['pressureAlerts'],
      temperatureAlerts: json['temperatureAlerts'],
      wearAlerts: json['wearAlerts'],
      maintenanceAlerts: json['maintenanceAlerts'],
    );
  }
}

abstract class DashboardState {}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final DashboardModel dashboard;

  DashboardLoaded(this.dashboard);
}

class DashboardError extends DashboardState {
  final String message;

  DashboardError(this.message);
}
