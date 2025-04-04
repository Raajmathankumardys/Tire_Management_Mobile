class TirePerformance {
  final int? tireId;
  final double pressure;
  final double temperature;
  final double wear;
  final double distanceTraveled;
  final double treadDepth;

  TirePerformance(
      {this.tireId,
      required this.pressure,
      required this.temperature,
      required this.wear,
      required this.distanceTraveled,
      required this.treadDepth});

  factory TirePerformance.fromJson(Map<String, dynamic> json) {
    return TirePerformance(
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

abstract class TirePerformanceState {}

class TirePerformanceInitial extends TirePerformanceState {}

class TirePerformanceLoading extends TirePerformanceState {}

class TirePerformanceLoaded extends TirePerformanceState {
  final List<TirePerformance> tireperformance;
  TirePerformanceLoaded(this.tireperformance);
}

class AddedTirePerformanceState extends TirePerformanceState {
  final String message;
  AddedTirePerformanceState(this.message);
}

class UpdatedTirePerformanceState extends TirePerformanceState {
  final String message;
  UpdatedTirePerformanceState(this.message);
}

class DeletedTirePerformanceState extends TirePerformanceState {
  final String message;
  DeletedTirePerformanceState(this.message);
}

class TirePerformanceError extends TirePerformanceState {
  final String message;
  TirePerformanceError(this.message);
}
