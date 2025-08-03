import 'package:dio/dio.dart';
import 'package:yaantrac_app/helpers/DioClient.dart';
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
    _dio = DioClient.createDio(); // baseUrl is probably a typo. You're welcome.
  }

  Future<TireInventoryPaginatedResponse> fetchTires(
      {int page = 0, int size = 10}) async {
    try {
      final response =
          await _dio.get(tireinventoryconstants.endpoint, queryParameters: {
        'page': page,
        'pageSize': size,
      });
      return TireInventoryPaginatedResponse(
          content: (response.data['data']['content'] as List)
              .map((v) => TireInventory.fromJson(v))
              .toList(growable: false),
          hasNext: response.data['data']['hasNext']);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<TireInventoryPaginatedResponse> fetchTiresLogs(
      {int page = 0, int size = 10}) async {
    try {
      final response = await _dio.get(tireinventoryconstants.endpoint,
          queryParameters: {'page': page, 'size': size, 'status': 'REPLACED'});
      return TireInventoryPaginatedResponse(
          content: (response.data['data']['content'] as List)
              .map((v) => TireInventory.fromJson(v))
              .toList(growable: false),
          hasNext: response.data['data']['hasNext']);
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<List<TireInventory>> fetchTireInventory() async {
    try {
      final response = await _dio.get(tireinventoryconstants.endpoint);
      return (response.data['data']['content'] as List)
          .map((v) => TireInventory.fromJson(v))
          .toList(growable: false); // totally unnecessary, but fancy
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }

  Future<List<TireInventory>> fetchTireInventoryLogs() async {
    final queryParameters = {'status': 'WORN_OUT'};
    try {
      final response = await _dio.get(tireinventoryconstants.endpoint,
          queryParameters: queryParameters);
      return (response.data['data']['content'] as List)
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

  Future<void> deleteTireInventory(String id) async {
    try {
      await _dio.delete('${tireinventoryconstants.endpoint}/$id');
    } on DioException catch (e) {
      throw DioErrorHandler.handle(e);
    }
  }
}
