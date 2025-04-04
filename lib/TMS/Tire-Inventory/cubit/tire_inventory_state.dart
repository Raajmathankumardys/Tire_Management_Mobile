class TireInventory {
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

  TireInventory({
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
  factory TireInventory.fromJson(Map<String, dynamic> json) {
    return TireInventory(
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

// Normal state stuff
abstract class TireInventoryState {}

class TireInventoryInitial extends TireInventoryState {}

class TireInventoryLoading extends TireInventoryState {}

class TireInventoryLoaded extends TireInventoryState {
  final List<TireInventory> tireinventory;
  TireInventoryLoaded(this.tireinventory);
}

class AddedState extends TireInventoryState {
  final String message;
  AddedState(this.message);
}

class UpdatedState extends TireInventoryState {
  final String message;
  UpdatedState(this.message);
}

class DeletedState extends TireInventoryState {
  final String message;
  DeletedState(this.message);
}

class TireInventoryError extends TireInventoryState {
  final String message;
  TireInventoryError(this.message);
}
