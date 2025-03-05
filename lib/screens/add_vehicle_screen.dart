import 'package:flutter/material.dart';
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

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      final vehicle = Vehicle(
          tripId: null,
          vehicleNumber: vehiclenumber.toString(),
          driverName: drivername.toString(),
          startDate: startdate,
          endDate: enddate,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());
      try {
        final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips",
          DioMethod.post,
          formData: vehicle.toJson(),
          contentType: "application/json",
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Trip added successfully!"),
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => VehiclesListScreen()),
              (route) => false);
        } else {
          print(response.statusMessage);
        }
      } catch (err) {
        print(err);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Trip"),
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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                  controller:
                      _dateController1, // Use the controller instead of defaultValue
                  onDateSelected: (date) {
                    setState(() {
                      startdate = date;
                      _dateController1.text =
                          _formatDate(date); // Update text in field
                    });
                  },
                ),
                AppInputField(
                  label: "End Date",
                  isDatePicker: true,
                  controller:
                      _dateController2, // Use the controller instead of defaultValue
                  onDateSelected: (date) {
                    setState(() {
                      enddate = date;
                      _dateController2.text =
                          _formatDate(date); // Update text in field
                    });
                  },
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  onPressed: _onSubmit,
                  title: "Submit",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
