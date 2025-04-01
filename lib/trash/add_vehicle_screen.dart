// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
// import 'package:yaantrac_app/models/vehicle.dart';
// import 'package:yaantrac_app/screens/Homepage.dart';
// import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
// import '../common/widgets/button/app_primary_button.dart';
// import '../common/widgets/input/app_input_field.dart';
// import '../services/api_service.dart';
//
// class AddVehicleScreen extends StatefulWidget {
//   final Vehicle? vehicle;
//   const AddVehicleScreen({super.key, this.vehicle});
//
//   @override
//   State<AddVehicleScreen> createState() => _AddVehicleScreenState();
// }
//
// class _AddVehicleScreenState extends State<AddVehicleScreen> {
//   final _formKey = GlobalKey<FormState>();
//   late String name;
//   late String type;
//   late String licenseplate;
//   late int year;
//   bool _isLoading = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     name = widget.vehicle?.name ?? "";
//     type = widget.vehicle?.type ?? "";
//     licenseplate = widget.vehicle?.licensePlate ?? "";
//     year = widget.vehicle?.manufactureYear ?? 0;
//   }
//
//   _onSubmit() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isLoading = true; // Disable button & show loader
//       });
//
//       final vehicle = Vehicle(
//           id: widget.vehicle?.id,
//           name: name,
//           type: type,
//           licensePlate: licenseplate,
//           manufactureYear: year,
//           axleNo: 0);
//
//       try {
//         final response = await APIService.instance.request(
//           widget.vehicle == null
//               ? "https://yaantrac-backend.onrender.com/api/vehicles"
//               : "https://yaantrac-backend.onrender.com/api/vehicles/${widget.vehicle?.id}",
//           widget.vehicle == null ? DioMethod.post : DioMethod.put,
//           formData: vehicle.toJson(),
//           contentType: "application/json",
//         );
//
//         if (response.statusCode == 200) {
//           ToastHelper.showCustomToast(
//               context,
//               widget.vehicle == null
//                   ? "Vehicle added successfully"
//                   : "Vehicle updated successfully",
//               Colors.green,
//               Icons.add);
//           Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(builder: (context) => HomeScreen()),
//             (route) => false,
//           );
//         } else {
//           ToastHelper.showCustomToast(
//               context, "Failed to add vehicle", Colors.red, Icons.error);
//         }
//       } catch (err) {
//         ToastHelper.showCustomToast(
//             context, "Error: $err", Colors.red, Icons.error);
//       } finally {
//         ToastHelper.showCustomToast(context, "Network error! Please try again.",
//             Colors.red, Icons.error);
//         setState(() {
//           _isLoading = false; // Re-enable button after request
//         });
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context).brightness;
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text("Add Vehicle"),
//         ),
//         backgroundColor:
//             theme == Brightness.dark ? Colors.black : Colors.blueAccent,
//         leading: IconButton(
//           onPressed: () => Navigator.pop(context),
//           icon: const Icon(Icons.arrow_back),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 AppInputField(
//                   label: "Name",
//                   hint: "Enter Name",
//                   defaultValue: name,
//                   onInputChanged: (value) => name = value ?? '',
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 AppInputField(
//                   label: "Type",
//                   hint: "Enter type",
//                   defaultValue: type,
//                   onInputChanged: (value) => type = value ?? '',
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 AppInputField(
//                   label: "License Plate",
//                   hint: "Enter License Plate",
//                   defaultValue: licenseplate,
//                   onInputChanged: (value) => licenseplate = value ?? '',
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 AppInputField(
//                   label: "Manufacture Year",
//                   hint: "Enter Manufacture Year",
//                   keyboardType: TextInputType.number,
//                   defaultValue: year.toString(),
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   onInputChanged: (value) {
//                     setState(() {
//                       year = int.parse(value!);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 16),
//                 _isLoading
//                     ? const CircularProgressIndicator()
//                     : AppPrimaryButton(
//                         onPressed: _onSubmit,
//                         title: "Submit",
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     ));
//   }
// }
