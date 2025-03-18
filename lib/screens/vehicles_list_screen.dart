import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
import 'package:yaantrac_app/screens/tiremapping.dart';
import 'package:yaantrac_app/screens/trip_list_page.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../models/vehicle.dart';
import 'Homepage.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  late Future<List<Vehicle>> futureVehicles;
  int? vid; // Stores vehicle ID for reference

  @override
  void initState() {
    super.initState();
    futureVehicles = getTrips();
  }

  void _showAddEditModal({Vehicle? vehicle}) {
    final _formKey = GlobalKey<FormState>();
    String name = vehicle?.name ?? "";
    String type = vehicle?.type ?? "";
    String licensePlate = vehicle?.licensePlate ?? "";
    int year = vehicle?.manufactureYear ?? 0;
    bool isLoading = false;

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        builder: (
          context,
        ) {
          return DraggableScrollableSheet(
            initialChildSize: 0.45.h, // Starts at of screen height
            minChildSize: 0.2.h, // Minimum height
            maxChildSize: 0.55.h, // Maximum height
            expand: false,
            builder: (context, scrollController) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35.r)),
                  ),
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                      ),
                      child: SingleChildScrollView(
                        controller:
                            scrollController, // Attach the scroll controller
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 50.h,
                                decoration: BoxDecoration(
                                  color: AppColors
                                      .secondaryColor, // Adjust color as needed
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(15.r)),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(height: 5.h),
                                    Container(
                                      width: 80.w,
                                      height: 5.h,
                                      padding: EdgeInsets.all(12.h),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(20.h),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      vehicle == null
                                          ? "Add Vehicle"
                                          : "Edit Vehicle",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 12.w,
                                    right: 12.w,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        12.h,
                                    top: 12.h,
                                  ),
                                  child: Column(
                                    children: [
                                      AppInputField(
                                        label: "Name",
                                        hint: "Enter vehicle name",
                                        defaultValue: name,
                                        onInputChanged: (value) =>
                                            name = value ?? '',
                                      ),
                                      AppInputField(
                                        label: "Type",
                                        hint: "Enter vehicle type",
                                        defaultValue: type,
                                        onInputChanged: (value) =>
                                            type = value ?? '',
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
                                      isLoading
                                          ? const CircularProgressIndicator()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                AppPrimaryButton(
                                                    width: 130.h,
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    title: "Cancel"),
                                                AppPrimaryButton(
                                                  width: 130.h,
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      setState(() =>
                                                          isLoading = true);

                                                      final newVehicle =
                                                          Vehicle(
                                                        id: vehicle?.id,
                                                        name: name,
                                                        type: type,
                                                        licensePlate:
                                                            licensePlate,
                                                        manufactureYear: year,
                                                      );

                                                      try {
                                                        final response =
                                                            await APIService
                                                                .instance
                                                                .request(
                                                          vehicle == null
                                                              ? "https://yaantrac-backend.onrender.com/api/vehicles"
                                                              : "https://yaantrac-backend.onrender.com/api/vehicles/${vehicle.id}",
                                                          vehicle == null
                                                              ? DioMethod.post
                                                              : DioMethod.put,
                                                          formData: newVehicle
                                                              .toJson(),
                                                          contentType:
                                                              "application/json",
                                                        );

                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          ToastHelper
                                                              .showCustomToast(
                                                            context,
                                                            vehicle == null
                                                                ? "Vehicle added successfully"
                                                                : "Vehicle updated successfully",
                                                            Colors.green,
                                                            Icons.check,
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                          Navigator.of(context)
                                                              .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        HomeScreen()),
                                                            (route) => false,
                                                          );
                                                        } else {
                                                          ToastHelper
                                                              .showCustomToast(
                                                            context,
                                                            "Failed to process request",
                                                            Colors.red,
                                                            Icons.error,
                                                          );
                                                        }
                                                      } catch (err) {
                                                        ToastHelper
                                                            .showCustomToast(
                                                          context,
                                                          "Error: $err",
                                                          Colors.red,
                                                          Icons.error,
                                                        );
                                                      } finally {
                                                        setState(() =>
                                                            isLoading = false);
                                                      }
                                                    }
                                                  },
                                                  title: vehicle == null
                                                      ? "Save"
                                                      : "Update",
                                                )
                                              ],
                                            ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          );
        });
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

  Future<void> _confirmDeleteVehicle(int vehicleId) async {
    bool isDeleting = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.h),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 25.h),
                  SizedBox(width: 8.h),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10.h),
                        Text("Deleting... Please wait",
                            style:
                                TextStyle(fontSize: 10.h, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this vehicle? This action cannot be undone.",
                      style: TextStyle(fontSize: 12.sp)),
              actions: isDeleting
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _deleteVehicle(vehicleId);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
            );
          },
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child:
              Text("Vehicles", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        leading: Container(
          padding: EdgeInsets.all(4.w),
          alignment: Alignment.center,
          child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
              )),
        ),
        actions: [
          Container(
            padding: EdgeInsets.all(4.w),
            alignment: Alignment.center,
            child: IconButton(
                onPressed: () {
                  _showAddEditModal();
                },
                icon: Icon(
                  Icons.add_circle_sharp,
                  color: isDarkMode ? Colors.white : Colors.black,
                  size: 25.h,
                )),
          )
        ],
        backgroundColor: AppColors.secondaryColor,
      ),
      body: FutureBuilder<List<Vehicle>>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error loading vehicles"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No Vehicles available"));
          } else {
            List<Vehicle> vehicles = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return Card(
                  color: isDarkMode ? Colors.grey[800] : Colors.white,
                  elevation: 2.h,
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(2.h),
                    onExpansionChanged: (value) {
                      setState(() {
                        vid = vehicle.id;
                      });
                    },
                    title: _buildVehicleListItem(vehicle, context, isDarkMode),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AxleAnimationPage(
                                                vehicleid: vehicle.id!,
                                              )));
                                },
                                icon: Icon(
                                  Icons.tire_repair_outlined,
                                  color: Colors.grey,
                                  size: 20.h,
                                )),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TripListScreen(
                                              vehicleid: vehicle.id!,
                                            )));
                              },
                              icon: Icon(Icons.tour),
                              color: Colors.cyanAccent,
                              iconSize: 20.h,
                            ),
                            IconButton(
                              onPressed: () {
                                _showAddEditModal(vehicle: vehicle);
                              },
                              icon: const FaIcon(Icons.edit),
                              color: Colors.green,
                              iconSize: 20.h,
                            ),
                            IconButton(
                                onPressed: () {
                                  _confirmDeleteVehicle(vehicle.id!);
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                                iconSize: 15.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    ));
  }

  Widget _buildVehicleListItem(
      Vehicle vehicle, BuildContext context, bool isDarkMode) {
    return ListTile(
      leading: Icon(Icons.directions_car, size: 30.h, color: Colors.blueAccent),
      title: Text("${vehicle.name + " " + vehicle.type}",
          style: TextStyle(
              fontSize: 12.w,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black)),
      subtitle: Text(
          'License: ${vehicle.licensePlate}  Year: ${vehicle.manufactureYear}',
          style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
    );
  }
}
