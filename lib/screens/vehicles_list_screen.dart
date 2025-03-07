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

  @override
  void initState() {
    super.initState();
    futureVehicles = getTrips();
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
          print(vehicleList);
          return vehicleList.map((json) => Vehicle.fromJson(json)).toList();
        } else if (response.data is List) {
          return response.data.map((json) => Vehicle.fromJson(json)).toList();
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception("API Error: ${response.statusMessage}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
      return []; // Avoids crashing by returning an empty list
    }
  }

  Future<void> _confirmDeleteTrip(int tripId) async {
    bool isDeleting = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
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
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDeleteTrip(tripId);
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

  Future<void> _onDeleteTrip(int tripId) async {
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Trips", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
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
                  shape:
                      RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                  elevation: 4,
                  child: ExpansionTile(
                    maintainState: true,
                    tilePadding: EdgeInsets.all(1),
                    onExpansionChanged: (value) => {tid = vehicle.id},
                    title: _buildVehicleListItem(
                        vehicle: vehicle,
                        context: context,
                        isDarkMode: isDarkMode),
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
                                        builder: (context) => ExpenseScreen(
                                            tripid: tid, ve: vehicle)));
                              },
                              icon: const FaIcon(FontAwesomeIcons.wallet),
                              color: Colors.green,
                              iconSize: 25,
                            ),
                            IconButton(
                              onPressed: () {
                                _confirmDeleteTrip(tid);
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
    );
  }

  Widget _buildVehicleListItem(
      {required Vehicle vehicle,
      required BuildContext context,
      required bool isDarkMode}) {
    return ListTile(
      leading: Icon(
        Icons.car_crash_sharp,
        size: 30,
      ),
      iconColor: Colors.blueAccent,
      title: Text(vehicle.vehicleNumber,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(vehicle.driverName,
              style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
          Text('Start Date: ${_formatDate(vehicle.startDate)}',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
          Text('End Date: ${_formatDate(vehicle.endDate)}',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey))
        ],
      ),
    );
  }
}
