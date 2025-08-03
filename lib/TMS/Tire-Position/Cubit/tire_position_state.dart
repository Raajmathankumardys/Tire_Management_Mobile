class TirePosition {
  final int position;
  final int axleNumber;
  final String side;
  final String positionCode;
  final String description;
  final String? id;

  TirePosition({
    required this.position,
    required this.axleNumber,
    required this.side,
    required this.positionCode,
    required this.description,
    this.id,
  });

  factory TirePosition.fromJson(Map<String, dynamic> json) {
    return TirePosition(
      position: json["position"],
      axleNumber: json['axleNumber'],
      side: json['side'],
      positionCode: json['positionCode'],
      description: json['description'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "position": position,
      "axleNumber": axleNumber,
      "positionCode": positionCode,
      "description": description,
      "id": id,
      "side": side
    };
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
