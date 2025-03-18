import 'package:yaantrac_app/models/tire.dart';

class TirePerformanceModel {
  final int? id;
  final TireModel? tire;
  final double pressure;
  final double temperature;
  final double wear;
  final double distanceTraveled;
  final double treadDepth;

  TirePerformanceModel(
      {this.id,
      required this.tire,
      required this.pressure,
      required this.temperature,
      required this.wear,
      required this.distanceTraveled,
      required this.treadDepth});

  factory TirePerformanceModel.fromJson(Map<String, dynamic> json) {
    return TirePerformanceModel(
        id: json["id"],
        tire: TireModel.fromJson(json["tire"]),
        pressure: json["pressure"],
        temperature: json["temperature"],
        wear: json["wear"],
        distanceTraveled: json["distanceTraveled"],
        treadDepth: json['treadDepth']);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tire": tire,
      "pressure": pressure,
      "wear": wear,
      "distanceTraveled": distanceTraveled,
      "temperature": temperature,
      "treadDepth": treadDepth
    };
  }
}
