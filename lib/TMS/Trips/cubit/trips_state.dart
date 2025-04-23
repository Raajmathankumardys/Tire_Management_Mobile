class Trip {
  final int? id;
  final String source;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  Trip(
      {required this.id,
      required this.source,
      required this.destination,
      required this.startDate,
      required this.endDate,
      required this.createdAt,
      required this.updatedAt});
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
      id: json['id'],
      source: json['source'],
      destination: json['destination'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'destination': destination,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}

abstract class TripState {}

class TripInitial extends TripState {}

class TripLoading extends TripState {}

class TripLoaded extends TripState {
  final List<Trip> trip;
  TripLoaded(this.trip);
}

class AddedTripState extends TripState {
  final String message;
  AddedTripState(this.message);
}

class UpdatedTripState extends TripState {
  final String message;
  UpdatedTripState(this.message);
}

class DeletedTripState extends TripState {
  final String message;
  DeletedTripState(this.message);
}

class TripError extends TripState {
  final String message;
  TripError(this.message);
}
