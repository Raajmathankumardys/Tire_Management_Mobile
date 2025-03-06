import 'package:flutter/material.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/screens/add_vehicle_screen.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../common/widgets/button/app_primary_button.dart';
import '../models/vehicle.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final List<bool> _isExpandedList = [false, false, false, false];
  late Future<List<Vehicle>> futureVehicles;
  var tid;
  Future<void> _confirmDeletetrip(int tripId) async {
    bool isDeleting = false;

    await showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissals
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Deleting Trip... Please wait",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this trip? This action cannot be undone.",
                      style: TextStyle(fontSize: 15)),
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
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDeletetrip(tripId);
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

  Future<void> _onDeletetrip(int tripId) async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/trips/$tripId",
        DioMethod.delete,
        contentType: "application/json",
      );
      if (response.statusCode == 204) {
        setState(() {
          futureVehicles = getTrips();
        });
        ToastHelper.showCustomToast(
            context, "Trip deleted successfully", Colors.red, Icons.delete);
        /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    ExpensesListScreen(tripId: widget.tripId)),
            (route) => false);*/
      } else {
        ToastHelper.showCustomToast(
            context, "Failed to process request", Colors.red, Icons.error);
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Request failed: $err");
      // Show error toast
      ToastHelper.showCustomToast(
          context, "Network error Please try again.", Colors.red, Icons.error);
    }
  }

  Future<List<Vehicle>> getTrips() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/trips",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey("data")) {
          List<dynamic> vehicleList = response.data["data"];
          return vehicleList.map((json) => Vehicle.fromJson(json)).toList();
        } else if (response.data is List) {
          return response.data.map((json) => Vehicle.fromJson(json)).toList();
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching Vehicles: $e");
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  void initState() {
    futureVehicles = getTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title:
            const Text("Trips", style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppPrimaryButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddVehicleScreen()));
          },
          title: "Add Trip",
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Vehicle>>(
          future: futureVehicles,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No Vehicles available"));
            } else {
              List<Vehicle> vehicles = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = vehicles[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: ExpansionTile(
                      onExpansionChanged: (value) => {tid = vehicle.id},
                      title: _buildVehicleListItem(
                          vehicle: vehicle, context: context),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const TiresListScreen()));
                                },
                                icon: const FaIcon(Icons.tire_repair_outlined),
                                color: Colors.grey,
                                iconSize: 30,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ExpenseScreen(tripid: tid)));
                                },
                                icon: const FaIcon(FontAwesomeIcons.wallet),
                                color: Colors.green,
                                iconSize: 25,
                              ),
                              IconButton(
                                onPressed: () {
                                  _confirmDeletetrip(tid);
                                },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                                iconSize: 23,
                              ),
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
      ),
    ));
  }

  Widget _buildVehicleListItem(
      {required Vehicle vehicle, required BuildContext context}) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              color: Colors.blue, borderRadius: BorderRadius.circular(8)),
          child:
              const Icon(Icons.directions_car, color: Colors.white, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                vehicle.vehicleNumber,
                style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              Text(
                vehicle.driverName,
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              Text(
                'Start Date: ${_formatDate(vehicle.startDate)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                'End Date: ${_formatDate(vehicle.endDate)}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
