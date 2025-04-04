import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
    final response = await _dio.get('/tires');
    return (response.data['data'] as List)
        .map((v) => TireInventory.fromJson(v))
        .toList(growable: false); // totally unnecessary, but fancy
  }

  Future<void> addTireInventory(TireInventory tireinventory) async {
    await _dio.post('/tires', data: tireinventory.toJson());
  }

  Future<void> updateTireInventory(TireInventory tireinventory) async {
    await _dio.put('/tires/${tireinventory.id}', data: tireinventory.toJson());
  }

  Future<void> deleteTireInventory(int id) async {
    await _dio.delete('/tires/$id');
  }
}
