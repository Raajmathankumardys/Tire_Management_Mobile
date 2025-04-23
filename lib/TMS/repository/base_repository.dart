import 'package:yaantrac_app/models/trip.dart';

import '../service/base_service.dart';

class BaseRepository<T> {
  final BaseService<T> service;

  BaseRepository(this.service);

  Future<List<Trip>> getAll({String? endpoint}) =>
      service.fetchAll(endpoint: endpoint);

  Future<List<T>> getPerformance({required String endpoint}) =>
      service.fetchPerformance(endpoint: endpoint);

  Future<void> addPerformance(T item, {required String endpoint}) =>
      service.createPerformance(item, endpoint: endpoint);

  Future<void> add(T item, {String? endpoint}) =>
      service.create(item, endpoint: endpoint);

  Future<void> update(T item, int id, {String? endpoint}) =>
      service.update(item, id, endpoint: endpoint);

  Future<void> delete(int id, {String? endpoint}) =>
      service.remove(id, endpoint: endpoint);
}
