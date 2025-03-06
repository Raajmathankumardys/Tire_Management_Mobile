import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import '../common/widgets/Toast/Toast.dart';
import '../models/tire.dart';

class AddEditTireScreen extends StatefulWidget {
  final TireModel? tire;

  const AddEditTireScreen({super.key, this.tire});

  @override
  State<AddEditTireScreen> createState() => _AddEditTireScreenState();
}

class _AddEditTireScreenState extends State<AddEditTireScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _brand;
  late String _model;
  late String _size;
  late int _stock;
  bool _isLoading = false; // Track form submission state

  @override
  void initState() {
    super.initState();
    _brand = widget.tire?.brand ?? '';
    _model = widget.tire?.model ?? '';
    _size = widget.tire?.size ?? '';
    _stock = widget.tire?.stock ?? 0;
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Disable button & show loader
      });

      int? id = widget.tire?.id;
      _formKey.currentState!.save();

      final tire = TireModel(
        id: id,
        brand: _brand,
        model: _model,
        size: _size.toString(),
        stock: _stock.toInt(),
      );

      try {
        final response = await APIService.instance.request(
          widget.tire == null
              ? "https://yaantrac-backend.onrender.com/api/tires"
              : "https://yaantrac-backend.onrender.com/api/tires/${tire.id}",
          widget.tire == null ? DioMethod.post : DioMethod.put,
          formData: tire.toJson(),
          contentType: "application/json",
        );

        if (response.statusCode == 200) {
          // Success toast
          ToastHelper.showCustomToast(
              context,
              widget.tire == null
                  ? "Tire added successfully"
                  : "Tire updated successfully",
              Colors.green,
              widget.tire == null ? Icons.add : Icons.edit);

          // Navigate to the list screen
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const TiresListScreen()),
              (route) => false);
        } else {
          // Show error toast if the response is unsuccessful
          ToastHelper.showCustomToast(
              context, "Failed to process request", Colors.red, Icons.error);
        }
      } catch (err) {
        print("Request failed: $err");

        // Show error toast
        ToastHelper.showCustomToast(context, "Network error Please try again.",
            Colors.red, Icons.error);
      } finally {
        setState(() {
          _isLoading = false; // Enable button after request
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(widget.tire == null ? "Add Tire" : "Edit Tire"),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppInputField(
                  label: "Tire Model",
                  hint: "Enter tire model",
                  defaultValue: _model,
                  onInputChanged: (value) => _model = value ?? '',
                ),
                AppInputField(
                  label: "Brand",
                  hint: "Enter brand",
                  defaultValue: _brand,
                  onInputChanged: (value) => _brand = value ?? '',
                ),
                AppInputField(
                  label: "Size",
                  hint: "Enter size",
                  defaultValue: _size,
                  onInputChanged: (value) => _size = value.toString(),
                ),
                AppInputField(
                  label: "Stock",
                  hint: "Enter stock quantity",
                  defaultValue: _stock.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onInputChanged: (value) =>
                      _stock = int.tryParse(value ?? '0') ?? 0,
                ),
                const SizedBox(height: 16),
                _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      ) // Show loader when submitting
                    : AppPrimaryButton(
                        onPressed: _onSubmit,
                        title: widget.tire == null ? "Add Tire" : "Update Tire",
                      ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
