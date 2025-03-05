class Vehicle {
  final int? tripId;
  final String vehicleNumber;
  final String driverName;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  Vehicle(
      {required this.tripId,
      required this.vehicleNumber,
      required this.driverName,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.updatedAt});
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      tripId: json['tripId'],
      vehicleNumber: json['vehicleNumber'],
      driverName: json['driverName'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'tripId': tripId,
      'vehicleNumber': vehicleNumber,
      'driverName': driverName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
