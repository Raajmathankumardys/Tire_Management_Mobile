import 'dart:ffi';

class TireModel {
  final String brand;
  final String model;
  final String size;
  final int stock;
  final int tireId;

  TireModel({
    required this.tireId,
    required this.brand,
    required this.model,
    required this.size,
    required this.stock,
  });

  // Tire model from JSON
  factory TireModel.fromJson(Map<String, dynamic> json) {
    return TireModel(
      tireId: json['tireId'] ?? 0,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      size: json['size'] ?? '',
      stock: json['stock'] ?? 0,
    );
  }

  // TireModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'tireId':tireId,
      'brand': brand,
      'model': model,
      'size': size,
      'stock': stock,
    };
  }
}
