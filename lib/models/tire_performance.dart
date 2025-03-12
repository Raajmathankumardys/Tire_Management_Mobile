class TirePerformanceModel {
  // private Long tireId;
  // private double pressure;
  // private double temperature;
  // private double wear;
  // private double distanceTraveled;
  final int tireId;
  final double pressure;
  final double temperature;
  final double wear;
  final double distanceTraveled;
  final String? localDateTime;

  TirePerformanceModel(
      {required this.tireId,
      required this.pressure,
      required this.temperature,
      required this.wear,
      required this.distanceTraveled,
      this.localDateTime});

  factory TirePerformanceModel.fromJson(Map<String, dynamic> json) {
    return TirePerformanceModel(
        tireId: json["tireId"],
        pressure: json["pressure"],
        temperature: json["temperature"],
        wear: json["wear"],
        distanceTraveled: json["distanceTraveled"],
        localDateTime: json['localDateTime']);
  }
  Map<String, dynamic> toJson() {
    return {
      "tireId": tireId,
      "pressure": pressure,
      "wear": wear,
      "distanceTraveled": distanceTraveled,
      "temperature": temperature,
      "localDateTime": localDateTime
    };
  }
}
