import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final response = await _dio.get('/tire-categories');
    return (response.data['data'] as List)
        .map((v) => TireCategory.fromJson(v))
        .toList(growable: false);
  }

  Future<void> addTireCategory(TireCategory tirecategory) async {
    await _dio.post('/tire-categories', data: tirecategory.toJson());
  }

  Future<void> updateTireCategory(TireCategory tirecategory) async {
    await _dio.put('/tire-categories/${tirecategory.id}',
        data: tirecategory.toJson());
  }

  Future<void> deleteTireCategory(int id) async {
    await _dio.delete('/tire-categories/$id');
  }
}
