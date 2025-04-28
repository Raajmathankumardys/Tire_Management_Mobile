import 'package:dio/dio.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/tire_mapping_state.dart';

class TireMappingService {
  static final TireMappingService _instance = TireMappingService._internal();

  late final Dio _dio;

  factory TireMappingService() {
    return _instance;
  }

  TireMappingService._internal() {
    _dio = Dio(BaseOptions(baseUrl: "https://yaantrac-backend.onrender.com"));
  }

  Future<List<GetTireMapping>> fetchTireMapping(int id) async {
    try {
      final response = await _dio.get(tiremappingconstants.endpoint(id));
      return (response.data['data'] as List)
          .map((v) => GetTireMapping.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTireMapping(List<AddTireMapping> tiremapping) async {
    try {
      //await _dio.post(tiremappingconstants.endpointpost, data: tiremapping);
      print("Add");
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateTireMapping(
      List<AddTireMapping> tiremapping, int id) async {
    try {
      //await _dio.put(tiremappingconstants.endpoint(id), data: tiremapping.toJson());
      print("update");
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteTiremapping(int id) async {
    try {
      //await _dio.delete(tiremappingconstants.endpoint(id));
      print(id);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
