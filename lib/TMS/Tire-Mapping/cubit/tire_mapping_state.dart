class AddTireMapping {
  late int? id;
  final int tireId;
  final String tirePosition;
  final int axleId;
  final int vehicleId;
  AddTireMapping(
      {required this.tireId,
      required this.tirePosition,
      required this.axleId,
      required this.vehicleId,
      this.id});

  factory AddTireMapping.fromJson(Map<String, dynamic> json) {
    return AddTireMapping(
        id: json['id'],
        tireId: json['tireId'],
        tirePosition: json['tirePosition'],
        axleId: json['axleId'],
        vehicleId: json['vehicleId']);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tireId": tireId,
      "tirePosition": tirePosition,
      "axleId": axleId,
      "vehicleId": vehicleId
    };
  }
}

class GetTireMapping {
  final int tireId;
  final String tirePosition;
  final int axleId;
  final int? vehicleId;
  final String installedDate;
  final String? removedDate;
  final bool isActive;
  late int? id;
  GetTireMapping(
      {required this.tireId,
      required this.tirePosition,
      required this.axleId,
      this.vehicleId,
      required this.installedDate,
      this.removedDate,
      required this.isActive,
      required this.id});

  factory GetTireMapping.fromJson(Map<String, dynamic> json) {
    return GetTireMapping(
        id: json['id'],
        tireId: json['tireId'],
        tirePosition: json['tirePosition'],
        axleId: json['axleId'],
        installedDate: json['installedDate'],
        removedDate: json['removeDate'],
        isActive: json['isActive'],
        vehicleId: json['vehicleId']);
  }
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "tireId": tireId,
      "tirePosition": tirePosition,
      "axleId": axleId,
      "vehicleId": vehicleId,
      "installedDate": installedDate,
      "removedDate": removedDate,
      "isActive": isActive
    };
  }
}

abstract class TireMappingState {}

class TireMappingInitial extends TireMappingState {}

class TireMappingLoading extends TireMappingState {}

class TireMappingLoaded extends TireMappingState {
  final List<GetTireMapping> tiremapping;
  TireMappingLoaded(this.tiremapping);
}

class AddedTireMappingState extends TireMappingState {
  final String message;
  AddedTireMappingState(this.message);
}

class UpdateTireMappingState extends TireMappingState {
  final String message;
  UpdateTireMappingState(this.message);
}

class DeleteTireMappingState extends TireMappingState {
  final String message;
  DeleteTireMappingState(this.message);
}

class TireMappingError extends TireMappingState {
  final String message;
  TireMappingError(this.message);
}
