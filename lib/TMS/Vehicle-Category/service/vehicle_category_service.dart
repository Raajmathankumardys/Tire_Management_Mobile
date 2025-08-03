import 'package:dio/dio.dart';
import '../../../helpers/DioClient.dart';
import '../../../helpers/exception.dart';
import '../cubit/vehicle_category_state.dart';

class VehicleCategoryService {
  static final VehicleCategoryService _instance =
      VehicleCategoryService._internal();

  late final Dio _dio;

  factory VehicleCategoryService() {
    return _instance;
  }

  VehicleCategoryService._internal() {
    _dio = DioClient.createDio();
  }

  Future<List<VehicleCategoryModel>> fetchVehicles() async {
    try {
      final response = await _dio.get("/dropdown/vehicle-categories");
      return (response.data['data'] as List)
          .map((v) => VehicleCategoryModel.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
