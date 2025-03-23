import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
import 'package:yaantrac_app/screens/tiremapping.dart';
import 'package:yaantrac_app/screens/trip_list_page.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/vehicle/vehicle_bloc.dart';
import '../bloc/vehicle/vehicle_event.dart';
import '../bloc/vehicle/vehicle_state.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../models/vehicle.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  late Future<List<Vehicle>> futureVehicles;
  int? vid;
  void _showAddEditModal(BuildContext ctx, [Vehicle? vehicle]) {
    final _formKey = GlobalKey<FormState>();
    String name = vehicle?.name ?? "";
    String type = vehicle?.type ?? "";
    String licensePlate = vehicle?.licensePlate ?? "";
    int year = vehicle?.manufactureYear ?? 0;
    List<int> axles = [2, 2]; // Default front & rear axles
    Map<String, int> axleMap = {"F": 2, "R": 2};
    void _updateAxleMap(Function setState) {
      setState(() {
        axleMap.clear();
        for (int i = 0; i < axles.length; i++) {
          String key =
              (i == 0) ? "F" : (i == axles.length - 1 ? "R" : "${i + 1}");
          axleMap[key] = axles[i];
        }
      });
      print(axleMap);
    }

    void addAxle(Function setState) {
      setState(() {
        axles.insert(axles.length - 1, 2); // Always insert before rear axle
        _updateAxleMap(setState);
      });
    }

    void addTires(int index, Function setState) {
      setState(() {
        if (index == 0) return; // Front axle fixed at 2 tires
        axles[index] += 2;
        _updateAxleMap(setState);
      });
    }

    void removeTires(int index, Function setState) {
      setState(() {
        if (index == 0) return; // Front axle cannot change
        if (axles[index] > 2 || index == axles.length) {
          axles[index] -= 2;
          _updateAxleMap(setState);
        }
      });
    }

    void removeAxle(int index, Function setState) {
      if (index == 0 || index == axles.length - 1)
        return; // Cannot remove F or R
      setState(() {
        axles.removeAt(index);
        _updateAxleMap(setState);
      });
    }

    BuildContext ct = context;
    showModalBottomSheet(
      context: ct, //
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.50.h,
          minChildSize: 0.2.h,
          maxChildSize: 0.60.h,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(builder: (context, setState) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12,
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15)),
                            ),
                            child: Column(
                              children: [
                                SizedBox(height: 5),
                                Container(
                                  width: 80,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  vehicle == null
                                      ? "Add Vehicle"
                                      : "Edit Vehicle",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Column(
                              children: [
                                AppInputField(
                                  label: "Name",
                                  hint: "Enter vehicle name",
                                  defaultValue: name,
                                  onInputChanged: (value) => name = value ?? '',
                                ),
                                AppInputField(
                                  label: "Type",
                                  hint: "Enter vehicle type",
                                  defaultValue: type,
                                  onInputChanged: (value) => type = value ?? '',
                                ),
                                AppInputField(
                                  label: "License Plate",
                                  hint: "Enter license plate",
                                  defaultValue: licensePlate,
                                  onInputChanged: (value) =>
                                      licensePlate = value ?? '',
                                ),
                                AppInputField(
                                  label: "Manufacture Year",
                                  hint: "Enter year",
                                  keyboardType: TextInputType.number,
                                  defaultValue: year.toString(),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly
                                  ],
                                  onInputChanged: (value) =>
                                      year = int.tryParse(value!) ?? 0,
                                ),
                                Container(
                                  // Set an appropriate height
                                  child: ListView.builder(
                                    shrinkWrap:
                                        true, // Helps ListView avoid infinite height
                                    physics:
                                        BouncingScrollPhysics(), // Prevents unnecessary scrolling issues
                                    itemCount: axles.length,
                                    itemBuilder: (ct, index) {
                                      return Card(
                                        color: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                        ),
                                        margin:
                                            EdgeInsets.symmetric(vertical: 6.r),
                                        elevation: 4,
                                        child: ListTile(
                                          leading: Icon(
                                            Icons.directions_car,
                                            color: Colors.blue,
                                            size: 20.h,
                                          ),
                                          title: Text(
                                            axleMap.keys.elementAt(index) == "F"
                                                ? "Front Axle"
                                                : axleMap.keys
                                                            .elementAt(index) ==
                                                        "R"
                                                    ? "Rear Axle"
                                                    : "Axle ${axleMap.keys.elementAt(index)}",
                                            style: TextStyle(
                                              fontSize: 10.h,
                                            ),
                                          ),
                                          subtitle: Text(
                                            "Tires: ${axles[index]}",
                                            style: TextStyle(
                                                fontSize: 10.h,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (index != 0) ...[
                                                Tooltip(
                                                  message: "Remove 2 tires",
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.remove_circle,
                                                      color: Colors.red,
                                                    ),
                                                    onPressed: () =>
                                                        removeTires(
                                                            index, setState),
                                                  ),
                                                ),
                                                Tooltip(
                                                  message: "Add 2 tires",
                                                  child: IconButton(
                                                    icon: Icon(
                                                      Icons.add_circle,
                                                      color: Colors.green,
                                                    ),
                                                    onPressed: () => addTires(
                                                        index, setState),
                                                  ),
                                                ),
                                                if (index != axles.length - 1)
                                                  Tooltip(
                                                    message: "Remove Axle",
                                                    child: IconButton(
                                                      icon: Icon(Icons.delete,
                                                          color: Colors.grey),
                                                      onPressed: () =>
                                                          removeAxle(
                                                              index, setState),
                                                    ),
                                                  ),
                                              ],
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(8.h),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.shade50,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Axle Summary",
                                            style: TextStyle(
                                                fontSize: 10.h,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(height: 6.h),
                                          ...axleMap.entries.map(
                                            (entry) => Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 2.h),
                                              child: Text(
                                                "${entry.key}: ${entry.value} tires",
                                                style: TextStyle(
                                                  fontSize: 12.h,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    FloatingActionButton.extended(
                                      onPressed: () => {addAxle(setState)},
                                      label: Text("Add Axle"),
                                      icon: Icon(Icons.add),
                                      backgroundColor: Colors.blue,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    AppPrimaryButton(
                                      width: 130,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      title: "Cancel",
                                    ),
                                    AppPrimaryButton(
                                      width: 130,
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          final newVehicle = Vehicle(
                                            id: vehicle?.id,
                                            name: name,
                                            licensePlate: licensePlate,
                                            manufactureYear: year,
                                            type: type,
                                          );
                                          ctx.read<VehicleBloc>().add(
                                              vehicle == null
                                                  ? AddVehicle(newVehicle)
                                                  : UpdateVehicle(newVehicle));
                                          Navigator.pop(context);
                                        }
                                      },
                                      title:
                                          vehicle == null ? "Save" : "Update",
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
          },
        );
      },
    );
  }

  Future<List<Vehicle>> getTrips() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles",
        DioMethod.get,
        contentType: "application/json",
      );

      debugPrint("Full API Response: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is List) {
          List<Vehicle> vehicles = response.data
              .map<Vehicle>((json) => Vehicle.fromJson(json))
              .toList();
          return Future.value(
              vehicles); // ✅ Wrap in Future.value to match return type
        } else {
          throw Exception("Unexpected API response format");
        }
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e, stacktrace) {
      debugPrint("Error fetching vehicles: $e");
      debugPrint(stacktrace.toString());
      return Future.value([]); // ✅ Return empty list inside Future.value
    }
  }

  Future<void> _confirmDeleteVehicle(BuildContext ctx, int vehicleId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 25),
              SizedBox(width: 8),
              Text("Confirm Delete",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this vehicle? This action cannot be undone.",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ctx
                    .read<VehicleBloc>()
                    .add(DeleteVehicle(vehicleId)); // ✅ Use outer context
                Navigator.pop(context);
              },
              child:
                  const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteVehicle(int vehicleId) async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/$vehicleId",
        DioMethod.delete,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        setState(() {
          futureVehicles = getTrips();
        });
        ToastHelper.showCustomToast(
            context, "Vehicle deleted successfully", Colors.red, Icons.delete);
      } else {
        ToastHelper.showCustomToast(
            context, "Failed to process request", Colors.red, Icons.error);
      }
    } catch (err) {
      debugPrint("Request failed: $err");
      ToastHelper.showCustomToast(
          context, "Network error. Please try again.", Colors.red, Icons.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => VehicleBloc()..add(LoadVehicles()),
        child: BlocListener<VehicleBloc, VehicleState>(
          listenWhen: (previous, current) =>
              current is VehicleSuccess || current is VehicleError,
          listener: (context, state) {
            if (state is VehicleSuccess) {
              ToastHelper.showCustomToast(
                context,
                state.message, // Example: "Vehicle deleted successfully"
                Colors.green,
                Icons.check_circle,
              );
            } else if (state is VehicleError) {
              ToastHelper.showCustomToast(
                context,
                state.message, // Example: "Failed to delete vehicle"
                Colors.red,
                Icons.error,
              );
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text("Vehicles",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              backgroundColor: AppColors.secondaryColor,
              leading: IconButton(
                  onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
            ),
            body: Column(
              children: [
                Expanded(
                  child: BlocBuilder<VehicleBloc, VehicleState>(
                    builder: (context, state) {
                      return Column(
                        children: [
                          Expanded(
                            child: state is VehicleLoaded
                                ? ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    itemCount: state.vehicles.length,
                                    itemBuilder: (context, index) {
                                      final vehicle = state.vehicles[index];
                                      return Card(
                                        elevation: 2.h,
                                        child: ExpansionTile(
                                          tilePadding: EdgeInsets.all(2.h),
                                          onExpansionChanged: (value) {
                                            setState(() {
                                              vid = vehicle.id;
                                            });
                                          },
                                          title: _buildVehicleListItem(
                                              vehicle, context),
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 10.h,
                                                  horizontal: 20.w),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  IconButton(
                                                      onPressed: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        AxleAnimationPage(
                                                                          vehicleid:
                                                                              vehicle.id!,
                                                                        )));
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .tire_repair_outlined,
                                                        color: Colors.grey,
                                                        size: 20.h,
                                                      )),
                                                  IconButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  TripListScreen(
                                                                    vehicleid:
                                                                        vehicle
                                                                            .id!,
                                                                  )));
                                                    },
                                                    icon: Icon(Icons.tour),
                                                    color: Colors.cyanAccent,
                                                    iconSize: 20.h,
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      _showAddEditModal(
                                                          context, vehicle);
                                                    },
                                                    icon: const FaIcon(
                                                        Icons.edit),
                                                    color: Colors.green,
                                                    iconSize: 20.h,
                                                  ),
                                                  IconButton(
                                                      onPressed: () {
                                                        _confirmDeleteVehicle(
                                                            context,
                                                            vehicle.id!);
                                                      },
                                                      icon: const FaIcon(
                                                          FontAwesomeIcons
                                                              .trash),
                                                      color: Colors.red,
                                                      iconSize: 15.h),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  )
                                : Center(child: CircularProgressIndicator()),
                          ),
                          Builder(
                            builder: (ctx) => Padding(
                              padding: EdgeInsets.all(8.h),
                              child: AppPrimaryButton(
                                  onPressed: () {
                                    _showAddEditModal(ctx);
                                  },
                                  title: "Add Vehicle"),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                // ✅ Add Button Inside BlocBuilder (Always Visible)
              ],
            ),
          ),
        ));
  }

  Widget _buildVehicleListItem(Vehicle vehicle, BuildContext context) {
    return ListTile(
      leading: Icon(Icons.directions_car, size: 30.h, color: Colors.blueAccent),
      title: Text("${vehicle.name + " " + vehicle.type}",
          style: TextStyle(
              fontSize: 12.w,
              fontWeight: FontWeight.bold,
              color: Colors.black)),
      subtitle: Text(
          'License: ${vehicle.licensePlate}  Year: ${vehicle.manufactureYear}',
          style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
    );
  }
}
