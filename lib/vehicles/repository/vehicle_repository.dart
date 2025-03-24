import '../service/vehicleService.dart';

class BaseRepository<T> {
  final BaseService<T> service;

  BaseRepository(this.service);

  Future<List<T>> getAll() => service.fetchAll();

  Future<void> add(T item) => service.create(item);

  Future<void> update(T item, int id) => service.update(item, id);

  Future<void> delete(int id) => service.remove(id);
}
