// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
//
// class AddTireScreen extends StatefulWidget {
//   const AddTireScreen({super.key});
//
//   @override
//   State<AddTireScreen> createState() => _AddTireScreenState();
// }
//
// class _AddTireScreenState extends State<AddTireScreen> {
//   DateTime? _selectedDate;
//
//   void _pickDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2020),
//       lastDate: DateTime(2030),
//     );
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Add Tire",
//           style: TextStyle(fontSize: 20),
//         ),
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 10),
//               // Tire Model
//               const Text("Tire Model", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               const TextField(
//                 decoration: InputDecoration(hintText: "Enter tire model", hintStyle: TextStyle(color: Colors.grey)),
//               ),
//               const SizedBox(height: 20),
//
//               // Brand
//               const Text("Brand", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               DropdownButtonFormField(
//                 items: const [
//                   DropdownMenuItem(value: "MRF", child: Text("MRF")),
//                   DropdownMenuItem(value: "Bridgestone", child: Text("Bridgestone")),
//                   DropdownMenuItem(value: "Michelin", child: Text("Michelin")),
//                 ],
//                 onChanged: (val) {},
//                 decoration: const InputDecoration(hintText: "Select brand"),
//               ),
//               const SizedBox(height: 20),
//
//               // Tire Type
//               const Text("Tire Type", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               DropdownButtonFormField(
//                 items: const [
//                   DropdownMenuItem(value: "Radial", child: Text("Radial")),
//                   DropdownMenuItem(value: "Bias", child: Text("Bias")),
//                   DropdownMenuItem(value: "Tubeless", child: Text("Tubeless")),
//                 ],
//                 onChanged: (val) {},
//                 decoration: const InputDecoration(hintText: "Select type"),
//               ),
//               const SizedBox(height: 20),
//
//               // Tire Position
//               const Text("Tire Position", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               DropdownButtonFormField(
//                 items: const [
//                   DropdownMenuItem(value: "Front Left", child: Text("Front Left")),
//                   DropdownMenuItem(value: "Front Right", child: Text("Front Right")),
//                   DropdownMenuItem(value: "Rear Left", child: Text("Rear Left")),
//                   DropdownMenuItem(value: "Rear Right", child: Text("Rear Right")),
//                 ],
//                 onChanged: (val) {},
//                 decoration: const InputDecoration(hintText: "Select position"),
//               ),
//               const SizedBox(height: 20),
//
//               // Purchase Date
//               const Text("Purchase Date", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               GestureDetector(
//                 onTap: () => _pickDate(context),
//                 child: AbsorbPointer(
//                   child: TextField(
//                     decoration: InputDecoration(
//                       hintText: _selectedDate == null
//                           ? "Select date"
//                           : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
//                       hintStyle: const TextStyle(color: Colors.grey),
//                       suffixIcon: const Icon(Icons.calendar_today),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Cost
//               const Text("Cost", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               TextField(
//                 decoration: const InputDecoration(hintText: "Enter cost", hintStyle: TextStyle(color: Colors.grey)),
//                 inputFormatters: [
//                   FilteringTextInputFormatter.digitsOnly,
//                 ],
//               ),
//               const SizedBox(height: 20),
//
//               // Description
//               const Text("Description", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
//               const SizedBox(height: 3),
//               const TextField(
//                 decoration: InputDecoration(hintText: "Enter description", hintStyle: TextStyle(color: Colors.grey)),
//                 keyboardType: TextInputType.multiline,
//                 maxLines: null,
//               ),
//               const SizedBox(height: 20),
//
//               // Buttons
//               Row(
//                 children: [
//                   Expanded(child: AppPrimaryButton(onPressed: () {}, title: "Attach Receipt")),
//                   const SizedBox(width: 10),
//                   Expanded(child: AppPrimaryButton(onPressed: () {}, title: "Submit")),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
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

  @override
  void initState() {
    super.initState();
    print(widget?.tire?.toJson());
    _brand = widget.tire?.brand ?? '';
    _model = widget.tire?.model ?? '';
    _size = widget.tire?.size ?? '';
    _stock = widget.tire?.stock ?? 0;
  }

  _onSubmit() async {
    if (_formKey.currentState!.validate()) {
      var tid = (widget.tire == null) ? null : widget.tire!.tireId;
      _formKey.currentState!.save();
      final tire = TireModel(
        tireId: tid,
        brand: _brand,
        model: _model,
        size: _size.toString(),
        stock: _stock.toInt(),
      );
      print(tire.toJson());
      try {
        final response = await APIService.instance.request(
          widget.tire == null
              ? "https://yaantrac-backend.onrender.com/api/tires"
              : "https://yaantrac-backend.onrender.com/api/tires/${tire.tireId}",
          widget.tire == null ? DioMethod.post : DioMethod.put,
          formData: tire.toJson(),
          contentType: "application/json",
        );
        print(tire.toJson());
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(widget.tire == null
                  ? "Tire added successfully!"
                  : "Tire updated successfully!"),
            ),
          );
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => TiresListScreen()),
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
        title: Text(widget.tire == null ? "Add Tire" : "Edit Tire"),
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
                  onInputChanged: (value) => _size = value.toString() ?? '',
                  //_size = int.tryParse(value ?? '0') ?? 0),
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
                AppPrimaryButton(
                  onPressed: _onSubmit,
                  title: widget.tire == null ? "Add Tire" : "Update Tire",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
