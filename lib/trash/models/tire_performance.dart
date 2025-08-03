/*
class TirePerformanceModel {
  final int? tireId;
  final double pressure;
  final double temperature;
  final double wear;
  final double distanceTraveled;
  final double treadDepth;

  TirePerformanceModel(
      {this.tireId,
      required this.pressure,
      required this.temperature,
      required this.wear,
      required this.distanceTraveled,
      required this.treadDepth});

  factory TirePerformanceModel.fromJson(Map<String, dynamic> json) {
    return TirePerformanceModel(
        tireId: json["tireId"],
        pressure: json["pressure"],
        temperature: json["temperature"],
        wear: json["wear"],
        distanceTraveled: json["distanceTraveled"],
        treadDepth: json['treadDepth']);
  }
  Map<String, dynamic> toJson() {
    return {
      "tireId": tireId,
      "pressure": pressure,
      "wear": wear,
      "distanceTraveled": distanceTraveled,
      "temperature": temperature,
      "treadDepth": treadDepth
    };
  }
}
*/
