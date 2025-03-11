import 'package:flutter/material.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/screens/Homepage.dart';
import 'package:yaantrac_app/trash/add_trip_screen.dart';
import 'package:yaantrac_app/trash/add_vehicle_screen.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../models/tire.dart';
import '../models/trip.dart';
import '../models/vehicle.dart';

class TripListScreen extends StatefulWidget {
  final int vehicleid;
  const TripListScreen({super.key, required this.vehicleid});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final List<bool> _isExpandedList = [false, false, false, false];
  late Future<List<Trip>> futureVehicles;
  var tid;

  @override
  void initState() {
    print(widget.vehicleid);
    super.initState();
    futureVehicles = getTrips();
  }

  void _showAddEditModal({Trip? trip, int? vehicleid}) {
    final _formKey = GlobalKey<FormState>();
    String source = trip?.source ?? "";
    String destination = trip?.destination ?? "";
    DateTime startdate = trip?.startDate ?? DateTime.now();
    DateTime enddate = trip?.endDate ?? DateTime.now();
    late TextEditingController _dateController1 = TextEditingController();
    late TextEditingController _dateController2 = TextEditingController();
    _dateController1.text = _formatDate(startdate);
    _dateController2.text = _formatDate(enddate);
    bool _isLoading = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      AppInputField(
                        label: "Source",
                        hint: "Enter Source",
                        defaultValue: source,
                        onInputChanged: (value) => source = value ?? '',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppInputField(
                        label: "Destination",
                        hint: "Enter Destination",
                        defaultValue: destination,
                        onInputChanged: (value) => destination = value ?? '',
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppInputField(
                        label: "Start Date",
                        isDatePicker: true,
                        controller: _dateController1,
                        onDateSelected: (date) {
                          setState(() {
                            startdate = date;
                            _dateController1.text = _formatDate(date);
                          });
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      AppInputField(
                        label: "End Date",
                        isDatePicker: true,
                        controller: _dateController2,
                        onDateSelected: (date) {
                          setState(() {
                            enddate = date;
                            _dateController2.text = _formatDate(date);
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : AppPrimaryButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    _isLoading =
                                        true; // Disable button & show loader
                                  });

                                  final vehicle = Trip(
                                    id: trip?.id,
                                    source: source,
                                    destination: destination,
                                    startDate: startdate,
                                    endDate: enddate,
                                    createdAt: DateTime.now(),
                                    updatedAt: DateTime.now(),
                                  );

                                  try {
                                    final response =
                                        await APIService.instance.request(
                                      trip == null
                                          ? "https://yaantrac-backend.onrender.com/api/trips?vehicleId=${widget.vehicleid}"
                                          : "https://yaantrac-backend.onrender.com/api/trips/${trip.id}/?vehicleId=${widget.vehicleid}",
                                      trip == null
                                          ? DioMethod.post
                                          : DioMethod.put,
                                      formData: vehicle.toJson(),
                                      contentType: "application/json",
                                    );

                                    if (response.statusCode == 200) {
                                      ToastHelper.showCustomToast(
                                          context,
                                          trip == null
                                              ? "Trip added successfully"
                                              : "Trip Updated successfully",
                                          Colors.green,
                                          Icons.add);
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TripListScreen(
                                                    vehicleid: vehicleid!)),
                                        (route) => false,
                                      );
                                    } else {
                                      ToastHelper.showCustomToast(
                                          context,
                                          "Failed to add trip",
                                          Colors.red,
                                          Icons.error);
                                    }
                                  } catch (err) {
                                    ToastHelper.showCustomToast(context,
                                        "Error: $err", Colors.red, Icons.error);
                                  } finally {
                                    ToastHelper.showCustomToast(
                                        context,
                                        "Network error! Please try again.",
                                        Colors.red,
                                        Icons.error);
                                    setState(() {
                                      _isLoading =
                                          false; // Re-enable button after request
                                    });
                                  }
                                }
                              },
                              title: trip == null ? "Add" : "Update",
                            ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Trip>> getTrips() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/${widget.vehicleid}/trips",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic> &&
            response.data.containsKey("data")) {
          List<dynamic> vehicleList = response.data["data"];
          print(vehicleList);
          return vehicleList.map((json) => Trip.fromJson(json)).toList();
        } else if (response.data is List) {
          return response.data.map((json) => Trip.fromJson(json)).toList();
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

    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Trips", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen())); // Go back to the previous page
          },
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AppPrimaryButton(
          onPressed: () {
            _showAddEditModal(vehicleid: widget.vehicleid);
          },
          title: "Add Trip",
        ),
      ),
      body: FutureBuilder<List<Trip>>(
        future: futureVehicles,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(child: Text("Error loading vehicles"));
          } else if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No Vehicles available"));
          } else {
            List<Trip> vehicles = snapshot.data!;
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
                                print(vehicle.id);
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TripViewPage(
                                              tripId: vehicle.id!,
                                              trip: vehicle,
                                              vehicleId: widget.vehicleid,
                                            )));
                              },
                              icon: Icon(Icons.remove_red_eye),
                              color: Colors.yellow,
                              iconSize: 25,
                            ),
                            IconButton(
                              onPressed: () {
                                _showAddEditModal(
                                    trip: vehicle, vehicleid: widget.vehicleid);
                              },
                              icon: Icon(Icons.edit),
                              color: Colors.green,
                              iconSize: 30,
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
    ));
  }

  Widget _buildVehicleListItem(
      {required Trip vehicle,
      required BuildContext context,
      required bool isDarkMode}) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListTile(
        leading: Icon(
          Icons.tour,
          size: 30,
        ),
        iconColor: Colors.cyanAccent,
        title: Text("${vehicle.source + "-" + vehicle.destination}",
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Date: ${_formatDate(vehicle.startDate)}',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey)),
            Text('End Date: ${_formatDate(vehicle.endDate)}',
                style: TextStyle(fontSize: 14, color: Colors.blueGrey))
          ],
        ),
      ),
    );
  }
}
