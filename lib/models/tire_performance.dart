class TirePerformanceModel{
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

  TirePerformanceModel(
      {required this.tireId, required this.pressure, required this.temperature, required this.wear, required this.distanceTraveled}
      );

  factory TirePerformanceModel.fromJson(Map<String,dynamic> json){
    return TirePerformanceModel(
        tireId:json["tireId"] ?? 0,
        pressure:json["pressure"] ?? 0,
        temperature:json["temperature"] ?? 0,
        wear:json["wear"] ?? 0,
        distanceTraveled: json["distanceTraveled"] ?? 0
    );
  }
  Map<String, dynamic> toJSON(){
    return {
      "tireId": tireId,
      "pressure": pressure,
      "wear":wear,
      "distanceTraveled":distanceTraveled,
      "temperature":temperature,
    };
  }

}