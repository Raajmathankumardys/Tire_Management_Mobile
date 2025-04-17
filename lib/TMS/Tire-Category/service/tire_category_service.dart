import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import 'package:yaantrac_app/TMS/helpers/exception.dart';

import '../cubit/tire_category_state.dart';

class TireCategoryService {
  static final TireCategoryService _instance = TireCategoryService._internal();

  late final Dio _dio;

  factory TireCategoryService() {
    return _instance;
  }

  TireCategoryService._internal() {
    _dio = Dio(BaseOptions(baseUrl: dotenv.env["BASE_URL"] ?? " "));
  }

  Future<List<TireCategory>> fetchTireCategory() async {
    try {
      final response = await _dio.get(tirecategoryconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => TireCategory.fromJson(v))
          .toList(growable: false);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTireCategory(TireCategory tirecategory) async {
    try {
      await _dio.post(tirecategoryconstants.endpoint,
          data: tirecategory.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateTireCategory(TireCategory tirecategory) async {
    try {
      await _dio.put('${tirecategoryconstants.endpoint}/${tirecategory.id}',
          data: tirecategory.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteTireCategory(int id) async {
    try {
      await _dio.delete('${tirecategoryconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
