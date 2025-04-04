class TireCategory {
  final int? id;
  final String category;
  final String description;

  TireCategory({this.id, required this.category, required this.description});

  factory TireCategory.fromJson(Map<String, dynamic> json) {
    return TireCategory(
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
}

abstract class TireCategoryState {}

class TireCategoryInitial extends TireCategoryState {}

class TireCategoryLoading extends TireCategoryState {}

class TireCategoryLoaded extends TireCategoryState {
  final List<TireCategory> tirecategory;
  TireCategoryLoaded(this.tirecategory);
}

class AddedTireCategoryState extends TireCategoryState {
  final String message;
  AddedTireCategoryState(this.message);
}

class UpdatedTireCategoryState extends TireCategoryState {
  final String message;
  UpdatedTireCategoryState(this.message);
}

class DeletedTireCategoryState extends TireCategoryState {
  final String message;
  DeletedTireCategoryState(this.message);
}

class TireCategoryError extends TireCategoryState {
  final String message;
  TireCategoryError(this.message);
}
