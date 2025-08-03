class VehicleCategoryModel {
  final String? id;
  final String vehicleCategory;
  VehicleCategoryModel({
    this.id,
    required this.vehicleCategory,
  });
  factory VehicleCategoryModel.fromJson(Map<String, dynamic> json) {
    return VehicleCategoryModel(
      id: json['id'],
      vehicleCategory: json['vehicle_category'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_category': vehicleCategory,
    };
  }
}

abstract class VehicleCategoryState {}

class VehicleCategoryInitial extends VehicleCategoryState {}

class VehicleCategoryLoading extends VehicleCategoryState {}

class VehicleCategoryLoaded extends VehicleCategoryState {
  final List<VehicleCategoryModel> categories;

  VehicleCategoryLoaded(this.categories);
}

class VehicleCategoryError extends VehicleCategoryState {
  final String message;

  VehicleCategoryError(this.message);
}
