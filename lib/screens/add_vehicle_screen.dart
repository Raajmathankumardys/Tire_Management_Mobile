import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/models/vehicle.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../services/api_service.dart';

class AddVehicleScreen extends StatefulWidget {
  const AddVehicleScreen({super.key});

  @override
  State<AddVehicleScreen> createState() => _AddVehicleScreenState();
}

class _AddVehicleScreenState extends State<AddVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  String vehiclenumber = "";
  String drivername = "";
  DateTime startdate = DateTime.now();
  DateTime enddate = DateTime.now();
  final TextEditingController _dateController1 = TextEditingController();
  final TextEditingController _dateController2 = TextEditingController();
  bool _isLoading = false;

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Disable button & show loader
      });

      final vehicle = Vehicle(
        id: null,
        vehicleNumber: vehiclenumber,
        driverName: drivername,
        startDate: startdate,
        endDate: enddate,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips",
          DioMethod.post,
          formData: vehicle.toJson(),
          contentType: "application/json",
        );

        if (response.statusCode == 200) {
          ToastHelper.showCustomToast(
              context, "Trip added successfully", Colors.green, Icons.add);
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => VehiclesListScreen()),
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
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Add Trip"),
        backgroundColor: Colors.blue,
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
                AppInputField(
                  label: "Vehicle Number",
                  hint: "Enter vehicle number",
                  defaultValue: vehiclenumber,
                  onInputChanged: (value) => vehiclenumber = value ?? '',
                ),
                AppInputField(
                  label: "Driver Name",
                  hint: "Enter driver name",
                  defaultValue: drivername,
                  onInputChanged: (value) => drivername = value ?? '',
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
