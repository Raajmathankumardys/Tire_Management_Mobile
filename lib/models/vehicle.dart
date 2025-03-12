class Vehicle {
  final int? id;
  final String name;
  final String type;
  final String licensePlate;
  final int manufactureYear;
  Vehicle({
    required this.id,
    required this.name,
    required this.type,
    required this.licensePlate,
    required this.manufactureYear,
  });
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
        id: int.tryParse(json["id"].toString()) ?? 0,
        name: json['name'],
        type: json['type'],
        licensePlate: json['licensePlate'],
        manufactureYear: json['manufactureYear']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'licensePlate': licensePlate,
      'manufactureYear': manufactureYear
    };
  }
}
