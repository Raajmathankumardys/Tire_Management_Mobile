// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
// import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
// import 'package:yaantrac_app/models/income.dart'; // Replace with the actual income model
// import 'package:yaantrac_app/trash/expense_list_screen.dart';
// import 'package:yaantrac_app/screens/expense_screen.dart';
// import 'package:yaantrac_app/services/api_service.dart';
//
// class AddIncomeScreen extends StatefulWidget {
//   final IncomeModel? income;
//   final int tripid;
//   const AddIncomeScreen({super.key, this.income, required this.tripid});
//
//   @override
//   State<AddIncomeScreen> createState() => _AddIncomeScreenState();
// }
//
// class _AddIncomeScreenState extends State<AddIncomeScreen> {
//   final int tripId = 1;
//   String selectedIncomeType = "";
//   DateTime selectedDate = DateTime.now();
//   double amount = 0.0;
//   String description = "";
//   late double _amount;
//   late DateTime _incomeDate;
//   late String _description;
//   final TextEditingController _dateController = TextEditingController();
//
//   @override
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     print(widget.tripid);
//     _amount = widget.income?.amount ?? 0.0;
//     _incomeDate = widget.income?.incomeDate ?? DateTime.now();
//     _dateController.text =
//         "$_incomeDate.toLocal()}".split(' ')[0]; // Format the date
//     _description = widget.income?.description ?? "";
//   }
//
//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}-"
//         "${date.month.toString().padLeft(2, '0')}-"
//         "${date.year}";
//   }
//
//   final _formKey = GlobalKey<FormState>();
//
//   void _submitIncome() async {
//     var iid = (widget.income == null) ? null : widget.income!.id;
//     if (_formKey.currentState!.validate()) {
//       IncomeModel income = IncomeModel(
//         id: iid,
//         amount: _amount,
//         incomeDate: _incomeDate,
//         tripId: widget.tripid,
//         description: _description,
//         createdAt: DateTime.now(),
//         updatedAt: DateTime.now(),
//       );
//       print(income.toJson());
//       try {
//         final response = await APIService.instance.request(
//           widget.income == null
//               ? "https://yaantrac-backend.onrender.com/api/income/${income.tripId}"
//               : "https://yaantrac-backend.onrender.com/api/income/${income.id}",
//           widget.income == null ? DioMethod.post : DioMethod.put,
//           formData: income.toJson(),
//           contentType: "application/json",
//         );
//         if (response.statusCode == 200) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//                 content: Text(widget.income == null
//                     ? "Income added successfully!"
//                     : "Income updated successfully!")),
//           );
//           _formKey.currentState?.reset();
//           /*Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (context) => TripViewPage(tripId: tripId)),
//               (route) => false);*/
//         } else {
//           print(response.statusMessage);
//         }
//       } catch (e) {
//         throw Exception("Error Posting Income: $e");
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Income",
//           style: TextStyle(fontSize: 20),
//         ),
//         leading: Builder(builder: (BuildContext context) {
//           return IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back),
//           );
//         }),
//       ),
//       body: Form(
//         key: _formKey,
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Add a new income",
//                   style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
//                 ),
//                 const SizedBox(height: 10),
//                 AppInputField(
//                   label: "Trip Id",
//                   hint: "Enter Trip Id",
//                   keyboardType: TextInputType.number,
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   disabled: true,
//                   defaultValue: widget.tripid.toString(),
//                 ),
//                 const SizedBox(height: 5),
//                 AppInputField(
//                   label: "Amount",
//                   hint: "Enter Amount",
//                   keyboardType: TextInputType.number,
//                   defaultValue: _amount.toString(),
//                   inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                   onInputChanged: (value) {
//                     setState(() {
//                       _amount = double.parse(value!);
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 5),
//                 AppInputField(
//                   label: "Date",
//                   isDatePicker: true,
//                   controller:
//                       _dateController, // Use the controller instead of defaultValue
//                   onDateSelected: (date) {
//                     setState(() {
//                       _incomeDate = date;
//                       _dateController.text =
//                           _formatDate(date); // Update text in field
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 5),
//                 AppInputField(
//                   label: "Description",
//                   hint: "Enter Description",
//                   keyboardType: TextInputType.multiline,
//                   defaultValue: _description.toString(),
//                   onInputChanged: (value) {
//                     setState(() {
//                       _description = value!;
//                     });
//                   },
//                 ),
//                 const SizedBox(height: 5),
//                 Row(
//                   children: [
//                     Expanded(
//                         child: AppPrimaryButton(
//                             onPressed: () {}, title: "Attach Receipt")),
//                     const SizedBox(width: 10),
//                     Expanded(
//                         child: AppPrimaryButton(
//                             onPressed: _submitIncome,
//                             title: widget.income?.id == null
//                                 ? "Submit"
//                                 : "Update")),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
