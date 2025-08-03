enum DriverStatus { ACTIVE, INACTIVE, ON_LEAVE, ON_TRIP, SUSPENDED }

class Driver {
  String? id;
  String firstName;
  String lastName;
  String licenseNumber;
  String? licenseExpiry;
  String? contactNumber;
  String email;
  String? address;
  bool active;
  bool isActive;
  DriverStatus status;

  Driver(
      {this.id,
      required this.firstName,
      required this.lastName,
      required this.licenseNumber,
      this.licenseExpiry,
      this.contactNumber,
      required this.email,
      this.address,
      required this.active,
      required this.isActive,
      required this.status});

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
        id: json['id'].toString(),
        firstName: json['firstName'],
        lastName: json['lastName'],
        licenseNumber: json['licenseNumber'],
        licenseExpiry: json['licenseExpiry'],
        contactNumber: json['contactNumber'],
        email: json['email'],
        address: json['address'],
        active: json['active'] ?? false,
        isActive: json['active'] ?? false,
        status: DriverStatus.values.firstWhere(
          (e) => e.toString().split('.').last == json['status'],
          orElse: () => DriverStatus.INACTIVE,
        ));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['licenseNumber'] = this.licenseNumber;
    data['licenseExpiry'] = this.licenseExpiry;
    data['contactNumber'] = this.contactNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['active'] = this.active;
    data['isActive'] = this.isActive;
    data['status'] = status.toString().split('.').last;
    return data;
  }
}

abstract class DriverState {}

class DriverInitial extends DriverState {}

class DriverLoading extends DriverState {}

class DriverLoaded extends DriverState {
  final List<Driver> driver;
  final bool hasNext;
  DriverLoaded(this.driver, this.hasNext);
}

class DriverPaginatedResponse extends DriverState {
  final List<Driver> content;
  final bool hasNext;

  DriverPaginatedResponse({required this.content, required this.hasNext});
}

class AddedDriverState extends DriverState {
  final String message;
  AddedDriverState(this.message);
}

class UpdatedDriverState extends DriverState {
  final String message;
  UpdatedDriverState(this.message);
}

class DeletedDriverState extends DriverState {
  final String message;
  DeletedDriverState(this.message);
}

class DriverError extends DriverState {
  final String message;
  DriverError(this.message);
}
