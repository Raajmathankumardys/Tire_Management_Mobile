/*
class TireModel {
  final String serialNo;
  final double temp;
  final double psi;
  final double dist;
  final DateTime? purchaseDate;
  final double purchaseCost;
  final int warrantyPeriod;
  final DateTime? warrantyExpiry;
  final int categoryId;
  final String location;
  final String brand;
  final String model;
  final String size;
  final int? id;

  TireModel({
    this.id,
    required this.serialNo,
    required this.temp,
    required this.psi,
    required this.dist,
    this.purchaseDate,
    required this.purchaseCost,
    required this.warrantyPeriod,
    this.warrantyExpiry,
    required this.categoryId,
    required this.location,
    required this.brand,
    required this.model,
    required this.size,
  });

  // Factory method to create a TireModel from JSON
  factory TireModel.fromJson(Map<String, dynamic> json) {
    return TireModel(
      id: json['id'],
      serialNo: json['serialNo'] ?? '',
      temp: json['temp'] ?? 0,
      psi: (json['psi'] ?? 0.0).toDouble(),
      dist: (json['dist'] ?? 0.0).toDouble(),
      purchaseDate: DateTime.parse(
          json['purchaseDate'] ?? DateTime.now().toIso8601String()),
      purchaseCost: (json['purchaseCost'] ?? 0.0).toDouble(),
      warrantyPeriod: json['warrantyPeriod'] ?? 0,
      warrantyExpiry: DateTime.parse(
          json['warrantyExpiry'] ?? DateTime.now().toIso8601String()),
      categoryId: json['categoryId'] ?? 0,
      location: json['location'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      size: json['size'] ?? '',
    );
  }

  // Convert TireModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNo': serialNo,
      'temp': temp,
      'psi': psi,
      'dist': dist,
      'purchaseDate': purchaseDate!.toIso8601String(),
      'purchaseCost': purchaseCost,
      'warrantyPeriod': warrantyPeriod,
      'warrantyExpiry': warrantyExpiry!.toIso8601String(),
      'categoryId': categoryId,
      'location': location,
      'brand': brand,
      'model': model,
      'size': size,
    };
  }
}

*/
/*class Category {
  final int? id;
  final String category;
  final String description;

  Category({this.id, required this.category, required this.description});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
        id: json['id'],
        category: json['category'] ?? "",
        description: json['description'] ?? "");
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'description': description,
    };
  }
}*/
