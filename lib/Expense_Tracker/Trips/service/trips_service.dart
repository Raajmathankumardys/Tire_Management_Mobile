import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/trips_state.dart';

class TripService {
  static final TripService _instance = TripService._internal();

  late final Dio _dio;

  factory TripService() {
    return _instance;
  }

  TripService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<Trip>> fetchTrip(int tripId) async {
    try {
      final response = await _dio.get(tripconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => Trip.fromJson(v))
          .toList(growable: false);
      // return [
      //   Trip(
      //       id: 21,
      //       source: "Chennai",
      //       destination: "Delhi",
      //       startDate: DateTime.now(),
      //       endDate: DateTime.now(),
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now()),
      //   Trip(
      //       id: 22,
      //       source: "Goa",
      //       destination: "Shimla",
      //       startDate: DateTime.now(),
      //       endDate: DateTime.now(),
      //       createdAt: DateTime.now(),
      //       updatedAt: DateTime.now())
      // ];
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTrip(Trip trip, int vehicleId) async {
    try {
      await _dio.post('${tripconstants.endpoint}/${vehicleId}',
          data: trip.toJson());
      print(trip.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateTrip(Trip trip) async {
    try {
      await _dio.put('${tripconstants.endpoint}/${trip.id}',
          data: trip.toJson());
      print(trip.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteTrip(int id) async {
    try {
      await _dio.delete('${tripconstants.endpoint}/$id');
      //print(id);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
