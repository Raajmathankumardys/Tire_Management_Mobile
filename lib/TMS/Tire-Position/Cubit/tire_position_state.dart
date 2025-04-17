class TirePosition {
  final String positionCode;
  final String description;
  final int? id;

  TirePosition({
    required this.positionCode,
    required this.description,
    this.id,
  });

  factory TirePosition.fromJson(Map<String, dynamic> json) {
    return TirePosition(
      positionCode: json['positionCode'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {"positionCode": positionCode, "description": description, "id": id};
  }
}

abstract class TirePositionState {}

class TirePositionInitial extends TirePositionState {}

class TirePositionLoading extends TirePositionState {}

class TirePositionLoaded extends TirePositionState {
  final List<TirePosition> tireposition;
  TirePositionLoaded(this.tireposition);
}

class TirePositionError extends TirePositionState {
  final String message;
  TirePositionError(this.message);
}
