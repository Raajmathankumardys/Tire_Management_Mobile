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
import 'package:yaantrac_app/services/api_service.dart';

import '../models/tire.dart';


class AddTireScreen extends StatefulWidget {
  const AddTireScreen({super.key});

  @override
  State<AddTireScreen> createState() => _AddTireScreenState();
}

class _AddTireScreenState extends State<AddTireScreen> {
  final _formKey = GlobalKey<FormState>();
  String _brand = '';
  String _model = '';
  String _size = '';
  int _stock = 0;
  String _purchaseDate = '';

  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate;

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      _purchaseDate = "${date.day}/${date.month}/${date.year}";
      _dateController.text = _purchaseDate;
    });
  }

  Future<void> _onSubmit() async{
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final tire = TireModel(
        tireId: DateTime.now().millisecondsSinceEpoch,
        brand: _brand,
        model: _model,
        size: _size,
        stock: _stock,
      );
      try{
        final response=await APIService.instance.request(
          "/tires",
          DioMethod.post,
          formData: tire.toJson(),
          contentType: "application/json",
        );
        if(response.statusCode==200){
          Map<String,dynamic> responseData=response.data;
          Map<String,dynamic> tire=responseData["data"];
          TireModel tireModel=TireModel.fromJson(tire);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Created successfully with id ${tireModel.tireId}"),),);
          Navigator.pop(context);
        }
        else{
          print(response.statusMessage);
        }

      }
      catch(err){
        print(err);
      }
      print(tire.toJson());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Tire", style: TextStyle(fontSize: 20)),
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
                  onInputChanged: (value) => _model = value ?? '',
                ),
                AppInputField(
                  label: "Brand",
                  hint: "Enter brand",
                  onInputChanged: (value) => _brand = value ?? '',
                ),
                AppInputField(
                  label: "Size",
                  hint: "Enter size",
                  onInputChanged: (value) => _size = value ?? '',
                ),
                AppInputField(
                  label: "Stock",
                  hint: "Enter stock quantity",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onInputChanged: (value) => _stock = int.tryParse(value ?? '0') ?? 0,
                ),

                Row(
                  children: [
                    Expanded(child: AppPrimaryButton(onPressed: () {}, title: "Attach Receipt")),
                    const SizedBox(width: 10),
                    Expanded(child: AppPrimaryButton(onPressed: _onSubmit, title: "Submit")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
