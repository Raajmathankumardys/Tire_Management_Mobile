class TireModel {
  final String brand;
  final String model;
  final String size;
  final int stock;
  final int? id;

  TireModel({
    this.id,
    required this.brand,
    required this.model,
    required this.size,
    required this.stock,
  });

  // Tire model from JSON
  factory TireModel.fromJson(Map<String, dynamic> json) {
    return TireModel(
      id: json['id'] ?? 0,
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      size: json['size'] ?? 0,
      stock: json['stock'] ?? 0,
    );
  }

  // TireModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'size': size,
      'stock': stock,
    };
  }
}
