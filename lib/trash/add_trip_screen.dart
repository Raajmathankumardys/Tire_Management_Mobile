import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/models/vehicle.dart';
import 'package:yaantrac_app/screens/trip_list_page.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../models/trip.dart';
import '../services/api_service.dart';

class AddTripScreen extends StatefulWidget {
  final Trip? trip;
  final int vehicleid;
  const AddTripScreen({super.key, this.trip, required this.vehicleid});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  late String source;
  late String destination;
  late DateTime startdate = DateTime.now();
  late DateTime enddate = DateTime.now();
  late TextEditingController _dateController1 = TextEditingController();
  late TextEditingController _dateController2 = TextEditingController();
  bool _isLoading = false;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    source = widget.trip?.source ?? "";
    destination = widget.trip?.destination ?? '';
    startdate = widget.trip?.startDate ?? DateTime.now();
    enddate = widget.trip?.endDate ?? DateTime.now();
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Disable button & show loader
      });

      final vehicle = Trip(
        id: widget.trip?.id,
        source: source,
        destination: destination,
        startDate: startdate,
        endDate: enddate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips?vehicleId=${widget.vehicleid}",
          DioMethod.post,
          formData: vehicle.toJson(),
          contentType: "application/json",
        );

        if (response.statusCode == 200) {
          ToastHelper.showCustomToast(
              context, "Trip added successfully", Colors.green, Icons.add);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) =>
                    TripListScreen(vehicleid: widget.vehicleid)),
            (route) => false,
          );
        } else {
          ToastHelper.showCustomToast(
              context, "Failed to add trip", Colors.red, Icons.error);
        }
      } catch (err) {
        ToastHelper.showCustomToast(
            context, "Error: $err", Colors.red, Icons.error);
      } finally {
        ToastHelper.showCustomToast(context, "Network error! Please try again.",
            Colors.red, Icons.error);
        setState(() {
          _isLoading = false; // Re-enable button after request
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).brightness;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Add Trip"),
        ),
        backgroundColor:
            theme == Brightness.dark ? Colors.black : Colors.blueAccent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                        onPressed: _onSubmit,
                        title: "Submit",
                      ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
