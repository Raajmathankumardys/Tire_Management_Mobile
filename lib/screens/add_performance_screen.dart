import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import '../common/widgets/Toast/Toast.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../services/api_service.dart';

class AddPerformanceScreen extends StatefulWidget {
  final int tid;
  const AddPerformanceScreen({super.key, required this.tid});

  @override
  State<AddPerformanceScreen> createState() => _AddPerformanceScreen();
}

class _AddPerformanceScreen extends State<AddPerformanceScreen> {
  final _formKey = GlobalKey<FormState>();
  double pressure = 0.0;
  double temperature = 0.0;
  double wear = 0.0;
  double distanctravelled = 0.0;
  String localdate = "2025-03-05T17:22:26.353Z";
  bool isLoading = false;

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      final tirep = TirePerformanceModel(
          tireId: widget.tid,
          pressure: pressure,
          temperature: temperature,
          wear: wear,
          distanceTraveled: distanctravelled,
          localDateTime: localdate);
      //print(tirep.toJson());
      try {
        final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/tires/${widget.tid}/add-performance",
          DioMethod.post,
          formData: tirep.toJson(),
          contentType: "application/json",
        );
        if (response.statusCode == 200) {
          ToastHelper.showCustomToast(context, "Performance added successfully",
              Colors.green, Icons.add);

          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => TireStatusScreen(tireId: widget.tid)),
              (route) => false);
        } else {
          ToastHelper.showCustomToast(
              context, "Failed to process request", Colors.green, Icons.add);
        }
      } catch (err) {
        ToastHelper.showCustomToast(
            context, "Error: $err", Colors.red, Icons.error);
      } finally {
        ToastHelper.showCustomToast(context, "Network error Please try again.",
            Colors.red, Icons.error);
        if (mounted) setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Trip"),
        leading: IconButton(
          onPressed: () => {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) => TireStatusScreen(
                          tireId: widget.tid,
                        )),
                (route) => false)
          },
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
                  label: "Pressure",
                  hint: "Enter pressure",
                  keyboardType: TextInputType.number,
                  defaultValue: pressure.toString(),
                  onInputChanged: (value) => pressure = double.parse(value!),
                ),
                AppInputField(
                  label: "Temperature",
                  hint: "Enter temperature",
                  keyboardType: TextInputType.number,
                  defaultValue: temperature.toString(),
                  onInputChanged: (value) => temperature = double.parse(value!),
                ),
                AppInputField(
                  label: "Wear",
                  hint: "Enter wear",
                  keyboardType: TextInputType.number,
                  defaultValue: wear.toString(),
                  onInputChanged: (value) => wear = double.parse(value!),
                ),
                AppInputField(
                  label: "Distance Travelled",
                  hint: "Enter distance travelled",
                  keyboardType: TextInputType.number,
                  defaultValue: distanctravelled.toString(),
                  onInputChanged: (value) =>
                      distanctravelled = double.parse(value!),
                ),
                const SizedBox(height: 16),
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : AppPrimaryButton(
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
