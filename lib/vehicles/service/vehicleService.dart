import 'package:dio/dio.dart';
import '../../models/vehicle.dart';

class VehiclesService {
  final Dio dio = Dio();
  final String baseUrl = "https://yaantrac-backend.onrender.com/api/vehicles";

  Future<List<Vehicle>> fetchVehicles() async {
    try {
      final response = await dio.get(baseUrl);

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((json) => Vehicle.fromJson(json))
            .toList();
      } else {
        throw Exception("Failed to fetch vehicles: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> createVehicle(Vehicle vehicle) async {
    try {
      final response = await dio.post(baseUrl, data: vehicle.toJson());

      if (response.statusCode != 200) {
        throw Exception("Failed to create vehicle: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> updateVehicle(Vehicle vehicle) async {
    try {
      final response =
          await dio.put("$baseUrl/${vehicle.id}", data: vehicle.toJson());

      if (response.statusCode != 200) {
        throw Exception("Failed to update vehicle: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<void> removeVehicle(int id) async {
    try {
      final response = await dio.delete("$baseUrl/$id");
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception("Failed to delete vehicle: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw _handleDioError(e);
    }
  }

  // 🔹 Custom error handling function
  Exception _handleDioError(DioException e) {
    if (e.response != null) {
      // Server responded with an error
      switch (e.response!.statusCode) {
        case 400:
          return Exception("Bad request: ${e.response!.data}");
        case 401:
          return Exception("Unauthorized access. Please log in.");
        case 403:
          return Exception("Forbidden: You don’t have permission.");
        case 404:
          return Exception("Resource not found.");
        case 500:
          return Exception("Internal Server Error. Please try again later.");
        default:
          return Exception("Unexpected error: ${e.response!.statusCode}");
      }
    } else if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return Exception("Network timeout. Please check your connection.");
    } else if (e.type == DioExceptionType.connectionError) {
      return Exception("No Internet connection.");
    } else {
      return Exception("Unexpected error: ${e.message}");
    }
  }
}
