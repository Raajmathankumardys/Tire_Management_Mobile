import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yaantrac_app/services/api_service.dart';
import '../../models/vehicle.dart';
import 'vehicle_event.dart';
import 'vehicle_state.dart';

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleInitial()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<AddVehicle>(_onAddVehicle);
    on<UpdateVehicle>(_onUpdateVehicle);
    on<DeleteVehicle>(_onDeleteVehicle);
  }

  Future<void> _onLoadVehicles(
      LoadVehicles event, Emitter<VehicleState> emit) async {
    emit(VehicleLoading());
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200 && response.data is List) {
        List<Vehicle> vehicles = response.data
            .map<Vehicle>((json) => Vehicle.fromJson(json))
            .toList();

        emit(VehicleLoaded(vehicles));
      } else {
        emit(VehicleError("Failed to load vehicles"));
      }
    } catch (e) {
      emit(VehicleError("Error: $e"));
    }
  }

  Future<void> _onAddVehicle(
      AddVehicle event, Emitter<VehicleState> emit) async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles",
        DioMethod.post,
        formData: event.vehicle.toJson(),
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        emit(VehicleSuccess("Vehicle Added Sucessfully"));
        add(LoadVehicles()); // Reload vehicles
      } else {
        emit(VehicleError("Failed to add vehicle"));
      }
    } catch (e) {
      emit(VehicleError("Error: $e"));
    }
  }

  Future<void> _onUpdateVehicle(
      UpdateVehicle event, Emitter<VehicleState> emit) async {
    try {
      await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/${event.vehicle.id}",
        DioMethod.put,
        formData: event.vehicle.toJson(),
        contentType: "application/json",
      );
      emit(VehicleSuccess("Vehicle Updated Sucessfully"));
      add(LoadVehicles()); // ✅ Reload data immediately
    } catch (e) {
      emit(VehicleError("Error updating vehicle: $e"));
    }
  }

  Future<void> _onDeleteVehicle(
      DeleteVehicle event, Emitter<VehicleState> emit) async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/${event.id}",
        DioMethod.delete,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        emit(VehicleSuccess("Vehicle Deleted Sucessfully"));
        add(LoadVehicles()); // Reload vehicles
      } else {
        emit(VehicleError("Failed to Delete vehicle"));
      }
      //add(LoadVehicles()); // ✅ Reload data immediately
    } catch (e) {
      emit(VehicleError("Error deleting vehicle: $e"));
    }
  }
}
