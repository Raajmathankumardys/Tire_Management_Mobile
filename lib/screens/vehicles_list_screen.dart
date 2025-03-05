import 'package:flutter/material.dart';
import 'package:yaantrac_app/screens/add_vehicle_screen.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

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
  var tripid;
  Future<List<Vehicle>> getTrips() async {
    try {
      print("API Called");
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/trips",
        DioMethod.get,
        contentType: "application/json",
      );

      print("Response Type: ${response.data.runtimeType}");
      print("Response Data: ${response.data}");

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          // Inspect the response to find the actual list
          if (response.data.containsKey("data")) {
            // Example key
            List<dynamic> vehicleList = response.data["data"];
            return vehicleList.map((json) => Vehicle.fromJson(json)).toList();
          } else {
            throw Exception(
                "Unexpected API response format: Missing 'data' key");
          }
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

  Future<void> _confirmDeleteexpense(int tripId) async {
    print(tripId);
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this Trip?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // No
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Yes
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _onDeleteexpense(tripId); // Call delete function if confirmed
    }
  }

  Future<void> _onDeleteexpense(int tripId) async {
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Trip deleted successfully!"),
          ),
        );
        /*Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    ExpensesListScreen(tripId: widget.tripId)),
            (route) => false);*/
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  @override
  void initState() {
    futureVehicles = getTrips();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle"),
        leading:
            IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
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
                  return Column(
                    children: [
                      ExpansionPanelList(
                        elevation: 1,
                        expansionCallback: (panelIndex, isExpanded) {
                          setState(() {
                            _isExpandedList[index] = !_isExpandedList[index];
                            tripid = vehicle.id;
                            print(tripid);
                          });
                        },
                        children: [
                          ExpansionPanel(
                            headerBuilder: (context, isExpanded) {
                              return ListTile(
                                title: _buildVehicleListItem(
                                    vehicle: vehicle, context: context),
                              );
                            },
                            body: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 30),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                      alignment: Alignment.center,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const TiresListScreen()));
                                      },
                                      icon: const Icon(
                                        Icons.tire_repair_sharp,
                                        color: Colors.grey,
                                      )),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ExpenseScreen(
                                                      tripid: tripid)));
                                    },
                                    icon: const Icon(
                                      Icons.wallet,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    tooltip: "Tires",
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      _confirmDeleteexpense(tripid);
                                    },
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    tooltip: "Expense/Income",
                                  ),
                                ],
                              ),
                            ),
                            isExpanded: _isExpandedList[index],
                            canTapOnHeader: true,
                          ),
                        ],
                      ),
                      const SizedBox(height: 16), // Space between each panel
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildVehicleListItem(
      {required Vehicle vehicle, required BuildContext context}) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${vehicle.vehicleNumber}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  vehicle.driverName.toString(),
                  style: const TextStyle(
                    color: Color(0xFF93adc8),
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Start Date:${_formatDate(vehicle.startDate)} ',
                  style: const TextStyle(
                    color: Color(0xFF93adc8),
                    fontSize: 12,
                  ),
                ),
                Text(
                  'End Date:${_formatDate(vehicle.endDate)} ',
                  style: const TextStyle(
                    color: Color(0xFF93adc8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
