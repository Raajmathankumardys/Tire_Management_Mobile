import 'package:yaantrac_app/TMS/Tire-Position/Cubit/tire_position_state.dart';

enum TireStatus { IN_USE, IN_STOCK, REPLACED, DAMAGED, REBUILT }

class TireInventory {
  final String serialNumber;
  final double? temperature;
  final double? pressure;
  final double? treadDepth;
  final String purchaseDate;
  final double price;
  final String brand;
  final String model;
  final String size;
  final String type;
  final TireStatus status;
  final int expectedLifespan;
  final String? id;
  final String? currentVehicleId;
  final String? installDate;
  final TirePosition? position;

  TireInventory(
      {this.id,
      required this.serialNumber,
      this.temperature,
      this.pressure,
      this.treadDepth,
      required this.purchaseDate,
      required this.price,
      required this.type,
      required this.brand,
      required this.model,
      required this.size,
      required this.status,
      required this.expectedLifespan,
      this.currentVehicleId,
      this.installDate,
      this.position});

  // Factory method to create a TireModel from JSON
  //?? DateTime.now().toIso8601String()
  factory TireInventory.fromJson(Map<String, dynamic> json) {
    return TireInventory(
      id: json['id'],
      serialNumber: json['serialNumber'] ?? '',
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      treadDepth: (json['treadDepth'] ?? 0.0).toDouble(),
      purchaseDate: json['purchaseDate'],
      price: (json['price'] ?? 0.0).toDouble(),
      type: json['type'] ?? '',
      brand: json['brand'] ?? '',
      model: json['model'] ?? '',
      size: json['size'] ?? '',
      status: TireStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => TireStatus.DAMAGED,
      ),
      expectedLifespan: json['expectedLifespan'] ?? 0,
      currentVehicleId: json['currentVehicleId'],
      installDate: json['installDate'],
      position: json['position'] != null
          ? TirePosition.fromJson(json['position'])
          : null,
    );
  }

  // Convert TireModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'serialNumber': serialNumber,
      'temperature': temperature,
      'pressure': pressure,
      'treadDepth': treadDepth,
      'purchaseDate': purchaseDate,
      'price': price,
      'type': type,
      'brand': brand,
      'model': model,
      'size': size,
      'expectedLifespan': expectedLifespan,
      'status': status.toString().split('.').last
    };
  }
}

// Normal state stuff
abstract class TireInventoryState {}

class TireInventoryInitial extends TireInventoryState {}

class TireInventoryLoading extends TireInventoryState {}

class TireInventoryLoaded extends TireInventoryState {
  final List<TireInventory> tireinventory;
  final bool hasNext;
  TireInventoryLoaded(this.tireinventory, this.hasNext);
}

class TireInventoryPaginatedResponse extends TireInventoryState {
  final List<TireInventory> content;
  final bool hasNext;

  TireInventoryPaginatedResponse(
      {required this.content, required this.hasNext});
}

class AddedTireInventoryState extends TireInventoryState {
  final String message;
  AddedTireInventoryState(this.message);
}

class UpdatedTireInventoryState extends TireInventoryState {
  final String message;
  UpdatedTireInventoryState(this.message);
}

class DeletedTireInventoryState extends TireInventoryState {
  final String message;
  DeletedTireInventoryState(this.message);
}

class TireInventoryError extends TireInventoryState {
  final String message;
  TireInventoryError(this.message);
}
