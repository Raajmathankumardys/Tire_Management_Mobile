import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../helpers/constants.dart';
import '../../../helpers/exception.dart';
import '../cubit/tire_inventory_state.dart';

class TireInventoryService {
  static final TireInventoryService _instance =
      TireInventoryService._internal();

  late final Dio _dio;

  factory TireInventoryService() {
    return _instance;
  }

  TireInventoryService._internal() {
    _dio = Dio(BaseOptions(
        baseUrl: dotenv.env["BASE_URL"] ??
            " ")); // baseUrl is probably a typo. You're welcome.
  }

  Future<List<TireInventory>> fetchTireInventory() async {
    try {
      final response = await _dio.get(tireinventoryconstants.endpoint);
      return (response.data['data'] as List)
          .map((v) => TireInventory.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> addTireInventory(TireInventory tireinventory) async {
    try {
      await _dio.post(tireinventoryconstants.endpoint,
          data: tireinventory.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> updateTireInventory(TireInventory tireinventory) async {
    try {
      await _dio.put('${tireinventoryconstants.endpoint}/${tireinventory.id}',
          data: tireinventory.toJson());
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<void> deleteTireInventory(int id) async {
    try {
      await _dio.delete('${tireinventoryconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
