import 'package:intl/intl.dart';

enum TripStatus { PLANNED, ACTIVE, COMPLETED, CANCELLED }

class Trip {
  final String? id;
  final String vehicleId;
  final String driverId;
  final String source;
  final String destination;
  final String startDate;
  final String endDate;
  final TripStatus status;
  final double distance;
  final double income;
  final String? description;
  Trip(
      {required this.id,
      required this.vehicleId,
      required this.driverId,
      required this.source,
      required this.destination,
      required this.startDate,
      required this.endDate,
      required this.status,
      required this.distance,
      required this.income,
      required this.description});
  factory Trip.fromJson(Map<String, dynamic> json) {
    return Trip(
        id: json['id'],
        source: json['source'],
        destination: json['destination'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        status: TripStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => TripStatus.ACTIVE,
        ),
        income: json['income'],
        description: json['description'],
        distance: json['distance'],
        driverId: json['driverId'],
        vehicleId: json['vehicleId']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source': source,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'distance': distance,
      'income': income,
      'status': status.toString().split('.').last,
      'vehicleId': vehicleId,
      'driverId': driverId,
      "description": description
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
