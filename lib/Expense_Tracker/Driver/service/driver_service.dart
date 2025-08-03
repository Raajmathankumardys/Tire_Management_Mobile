import 'package:dio/dio.dart';
import '../../../helpers/DioClient.dart';
import '../../../helpers/exception.dart';
import '../cubit/driver_state.dart';

class DriverService {
  static final DriverService _instance = DriverService._internal();

  late final Dio _dio;

  factory DriverService() {
    return _instance;
  }
  bool isRedirectingToLogin = false;
  DriverService._internal() {
    _dio = DioClient.createDio();
  }

  Future<DriverPaginatedResponse> fetchDriver(
      {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get('/drivers', queryParameters: {
        'page': page,
        'pageSize': size,
      });
      return DriverPaginatedResponse(
          content: (response.data['data']['content'] as List)
              .map((v) => Driver.fromJson(v))
              .toList(growable: false),
          hasNext: response.data['data']['hasNext']);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  // Future<List<Driver>> fetchDriver() async {
  //   try {
  //     final response = await _dio.get('/drivers');
  //     return (response.data['data']['content'] as List)
  //         .map((v) => Driver.fromJson(v))
  //         .toList(growable: false);
  //   } on DioException catch (e) {
  //     throw DioErrorHandler.handle(e);
  //   }
  // }

  Future<void> addDriver(Driver driver) async {
    try {
      await _dio.post('/drivers', data: driver.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateDriver(Driver driver, String id) async {
    try {
      await _dio.put('/drivers/$id', data: driver.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteDriver(String id) async {
    try {
      await _dio.delete('/drivers/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
