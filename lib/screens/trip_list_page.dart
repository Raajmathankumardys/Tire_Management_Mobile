// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
// import 'package:yaantrac_app/screens/Homepage.dart';
// import 'package:yaantrac_app/trash/add_trip_screen.dart';
// import 'package:yaantrac_app/trash/add_vehicle_screen.dart';
// import 'package:yaantrac_app/screens/expense_screen.dart';
// import 'package:yaantrac_app/screens/tires_list_screen.dart';
// import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
// import 'package:yaantrac_app/services/api_service.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import '../common/widgets/button/app_primary_button.dart';
// import '../common/widgets/input/app_input_field.dart';
// import '../config/themes/app_colors.dart';
// import '../models/expense.dart';
// import '../models/income.dart';
// import '../models/tire.dart';
// import '../models/trip.dart';
// import '../models/vehicle.dart';
//
// class TripListScreen extends StatefulWidget {
//   final int vehicleid;
//   const TripListScreen({super.key, required this.vehicleid});
//
//   @override
//   State<TripListScreen> createState() => _TripListScreenState();
// }
//
// class _TripListScreenState extends State<TripListScreen> {
//   final List<bool> _isExpandedList = [false, false, false, false];
//   late Future<List<Trip>> futureVehicles;
//   var tid;
//
//   @override
//   void initState() {
//     print(widget.vehicleid);
//     super.initState();
//     futureVehicles = getTrips();
//   }
//
//   int _selectedValue = 1;
//   void _showAddEditExpenseModal({ExpenseModel? expense, required int tripId}) {
//     final _formKey = GlobalKey<FormState>();
//     ExpenseCategory selectedExpenseType = ExpenseCategory.MISCELLANEOUS;
//
//     late double _amount;
//     late ExpenseCategory _category;
//     late DateTime _expenseDate;
//     late String _description;
//     final TextEditingController _dateController = TextEditingController();
//     late String cat;
//     bool _isLoading = false;
//     _amount = expense?.amount ?? 0.0;
//     _category = expense?.category ?? ExpenseCategory.FUEL;
//     _expenseDate = expense?.expenseDate ?? DateTime.now();
//     _dateController.text = _formatDate(_expenseDate);
//     _description = expense?.description ?? " ";
//     selectedExpenseType = expense?.category ?? ExpenseCategory.FUEL;
//     switch (_category.toString().split(".")[1]) {
//       case "FUEL":
//         cat = "Fuel Costs";
//         break;
//       case "DRIVER_ALLOWANCE":
//         cat = "Driver Allowances";
//         break;
//       case "TOLL":
//         cat = "Toll Charges";
//         break;
//       case "MAINTENANCE":
//         cat = "Maintenance";
//         break;
//       default:
//         cat = "Miscellaneous";
//     }
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return SizedBox(
//           height: 300,
//           child: StatefulBuilder(
//             builder: (context, setState) {
//               return SizedBox(
//                 height: 300,
//                 child: SingleChildScrollView(
//                   child: Form(
//                     key: _formKey,
//                     child: SingleChildScrollView(
//                       scrollDirection: Axis.vertical,
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               "Add a new expense",
//                               style: TextStyle(
//                                   fontWeight: FontWeight.w800, fontSize: 25),
//                             ),
//                             const SizedBox(height: 10),
//                             AppInputField(
//                               label: "Expense Type",
//                               isDropdown: true, hint: cat,
//                               defaultValue: selectedExpenseType
//                                   .toString(), // Correct default value
//                               dropdownItems: const [
//                                 DropdownMenuItem(
//                                     value: "FUEL", child: Text("Fuel Costs")),
//                                 DropdownMenuItem(
//                                     value: "DRIVER_ALLOWANCE",
//                                     child: Text("Driver Allowances")),
//                                 DropdownMenuItem(
//                                     value: "TOLL", child: Text("Toll Charges")),
//                                 DropdownMenuItem(
//                                     value: "MAINTENANCE",
//                                     child: Text("Maintenance")),
//                                 DropdownMenuItem(
//                                     value: "MISCELLANEOUS",
//                                     child: Text("Miscellaneous")),
//                               ],
//                               onDropdownChanged: (value) {
//                                 //print(value);
//                                 setState(() {
//                                   selectedExpenseType =
//                                       ExpenseCategory.values.firstWhere(
//                                     (e) => e.name == value,
//                                     orElse: () => ExpenseCategory.MISCELLANEOUS,
//                                   );
//                                   print(
//                                       "Selected Expense Type: $selectedExpenseType");
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 5),
//                             AppInputField(
//                               label: "Amount",
//                               hint: "Enter Amount",
//                               defaultValue: _amount.toString(),
//                               keyboardType: TextInputType.number,
//                               inputFormatters: [
//                                 FilteringTextInputFormatter.digitsOnly
//                               ],
//                               onInputChanged: (value) {
//                                 setState(() {
//                                   _amount = double.parse(value!);
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 5),
//                             AppInputField(
//                               label: "Date",
//                               isDatePicker: true,
//                               controller: _dateController, // Show only date
//                               onDateSelected: (date) {
//                                 setState(() {
//                                   _expenseDate = date;
//                                   _dateController.text =
//                                       _formatDate(date); // Update text in field
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 5),
//                             AppInputField(
//                               label: "Description",
//                               hint: "Enter Description",
//                               defaultValue: _description,
//                               keyboardType: TextInputType.multiline,
//                               onInputChanged: (value) {
//                                 setState(() {
//                                   _description = value!;
//                                 });
//                               },
//                             ),
//                             const SizedBox(height: 5),
//                             _isLoading
//                                 ? const Center(
//                                     child: CircularProgressIndicator())
//                                 : Row(
//                                     children: [
//                                       Expanded(
//                                           child: AppPrimaryButton(
//                                               onPressed: () {},
//                                               title: "Attach Receipt")),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                           child: AppPrimaryButton(
//                                               onPressed: () async {
//                                                 if (_formKey.currentState!
//                                                     .validate()) {
//                                                   //print("Submitted Expense Data: ${expense}");
//                                                   setState(() {
//                                                     _isLoading =
//                                                         true; // Disable button & show loader
//                                                   });
//                                                   var f = {
//                                                     "id": expense?.id,
//                                                     "tripId": tripId,
//                                                     "amount": _amount,
//                                                     "category":
//                                                         selectedExpenseType
//                                                             .toString()
//                                                             .split('.')[1],
//                                                     "expenseDate": _expenseDate
//                                                         .toIso8601String(),
//                                                     "description": _description,
//                                                     "attachmentUrl": "",
//                                                     "createdAt": DateTime.now()
//                                                         .toIso8601String(),
//                                                     "updatedAt": DateTime.now()
//                                                         .toIso8601String()
//                                                   };
//                                                   try {
//                                                     final response = await APIService
//                                                         .instance
//                                                         .request(
//                                                             expense == null
//                                                                 ? "https://yaantrac-backend.onrender.com/api/expenses/${tripId}"
//                                                                 : "https://yaantrac-backend.onrender.com/api/expenses/${expense.id}",
//                                                             expense == null
//                                                                 ? DioMethod.post
//                                                                 : DioMethod.put,
//                                                             formData: f,
//                                                             contentType:
//                                                                 "application/json");
//                                                     if (response.statusCode ==
//                                                         200) {
//                                                       ToastHelper.showCustomToast(
//                                                           context,
//                                                           (expense == null)
//                                                               ? "Expense Added Sucessfully"
//                                                               : "Expense Updated Sucessfully",
//                                                           Colors.green,
//                                                           expense == null
//                                                               ? Icons.add
//                                                               : Icons.edit);
//
//                                                       _formKey.currentState
//                                                           ?.reset();
//                                                       Navigator.pop(context);
//                                                       _confirmexpenseincome(
//                                                           tripId);
//                                                     } else {
//                                                       print(response
//                                                           .statusMessage);
//                                                     }
//                                                   } catch (e) {
//                                                     throw Exception(
//                                                         "Error Posting Income: $e");
//                                                   } finally {
//                                                     ToastHelper.showCustomToast(
//                                                         context,
//                                                         "Network error! Please try again.",
//                                                         Colors.red,
//                                                         Icons.error);
//                                                     setState(() {
//                                                       _isLoading =
//                                                           false; // Re-enable button after request
//                                                     });
//                                                   }
//                                                 }
//                                               },
//                                               title: expense == null
//                                                   ? "Add"
//                                                   : "Update")),
//                                     ],
//                                   ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   void _showAddEditIncomeModal({IncomeModel? income, required int tripId}) {
//     final _formKey = GlobalKey<FormState>();
//     bool isLoading = false;
//     late double _amount;
//     late DateTime _incomeDate;
//     late String _description;
//     final TextEditingController _dateController = TextEditingController();
//     _amount = income?.amount ?? 0.0;
//     _incomeDate = income?.incomeDate ?? DateTime.now();
//     _dateController.text =
//         "$_incomeDate.toLocal()}".split(' ')[0]; // Format the date
//     _description = income?.description ?? "";
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return Padding(
//               padding: EdgeInsets.only(
//                 top: 20,
//                 left: 16,
//                 right: 16,
//                 bottom: MediaQuery.of(context).viewInsets.bottom + 16,
//               ),
//               child: SingleChildScrollView(
//                 child: Form(
//                   key: _formKey,
//                   child: SingleChildScrollView(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Add a new income",
//                             style: TextStyle(
//                                 fontWeight: FontWeight.w800, fontSize: 25),
//                           ),
//                           const SizedBox(height: 5),
//                           AppInputField(
//                             label: "Amount",
//                             hint: "Enter Amount",
//                             keyboardType: TextInputType.number,
//                             defaultValue: _amount.toString(),
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             onInputChanged: (value) {
//                               setState(() {
//                                 _amount = double.parse(value!);
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 5),
//                           AppInputField(
//                             label: "Date",
//                             isDatePicker: true,
//                             controller:
//                                 _dateController, // Use the controller instead of defaultValue
//                             onDateSelected: (date) {
//                               setState(() {
//                                 _incomeDate = date;
//                                 _dateController.text =
//                                     _formatDate(date); // Update text in field
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 5),
//                           AppInputField(
//                             label: "Description",
//                             hint: "Enter Description",
//                             keyboardType: TextInputType.multiline,
//                             defaultValue: _description.toString(),
//                             onInputChanged: (value) {
//                               setState(() {
//                                 _description = value!;
//                               });
//                             },
//                           ),
//                           const SizedBox(height: 5),
//                           isLoading
//                               ? const Center(child: CircularProgressIndicator())
//                               : Row(
//                                   children: [
//                                     Expanded(
//                                         child: AppPrimaryButton(
//                                             onPressed: () {},
//                                             title: "Attach Receipt")),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                         child: AppPrimaryButton(
//                                             onPressed: () async {
//                                               if (_formKey.currentState!
//                                                   .validate()) {
//                                                 setState(() {
//                                                   isLoading =
//                                                       true; // Disable button & show loader
//                                                 });
//                                                 IncomeModel inc = IncomeModel(
//                                                   id: income?.id,
//                                                   amount: _amount,
//                                                   incomeDate: _incomeDate,
//                                                   tripId: tripId,
//                                                   description: _description,
//                                                   createdAt: DateTime.now(),
//                                                   updatedAt: DateTime.now(),
//                                                 );
//                                                 print(inc.toJson());
//                                                 try {
//                                                   final response =
//                                                       await APIService.instance
//                                                           .request(
//                                                     income == null
//                                                         ? "https://yaantrac-backend.onrender.com/api/income/${tripId}"
//                                                         : "https://yaantrac-backend.onrender.com/api/income/${income.id}",
//                                                     income == null
//                                                         ? DioMethod.post
//                                                         : DioMethod.put,
//                                                     formData: inc.toJson(),
//                                                     contentType:
//                                                         "application/json",
//                                                   );
//                                                   if (response.statusCode ==
//                                                       200) {
//                                                     ToastHelper.showCustomToast(
//                                                         context,
//                                                         income == null
//                                                             ? "Income added successfully!"
//                                                             : "Income updated successfully!",
//                                                         Colors.green,
//                                                         income == null
//                                                             ? Icons.add
//                                                             : Icons.edit);
//                                                     _formKey.currentState
//                                                         ?.reset();
//                                                     _confirmexpenseincome(
//                                                         tripId);
//                                                   } else {
//                                                     print(
//                                                         response.statusMessage);
//                                                   }
//                                                 } catch (e) {
//                                                   throw Exception(
//                                                       "Error Posting Income: $e");
//                                                 } finally {
//                                                   ToastHelper.showCustomToast(
//                                                       context,
//                                                       "Network error! Please try again.",
//                                                       Colors.red,
//                                                       Icons.error);
//                                                   setState(() {
//                                                     isLoading =
//                                                         false; // Re-enable button after request
//                                                   });
//                                                 }
//                                               }
//                                             },
//                                             title: income?.id == null
//                                                 ? "Add"
//                                                 : "Update")),
//                                   ],
//                                 ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _confirmexpenseincome(int tripId) async {
//     bool isyes = false;
//     int? _selectedValue; // Initialize selected value
//
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               title: Row(
//                 children: [
//                   Icon(Icons.currency_exchange, color: Colors.green, size: 20),
//                   SizedBox(width: 8),
//                   Text("Add Expense/Income",
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               content: isyes
//                   ? Container(
//                       height: 130,
//                       child: Column(
//                         children: [
//                           RadioListTile(
//                             title: Text('Expense'),
//                             value: 1,
//                             groupValue: _selectedValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedValue = value as int;
//                               });
//                             },
//                           ),
//                           RadioListTile(
//                             title: Text('Income'),
//                             value: 2,
//                             groupValue: _selectedValue,
//                             onChanged: (value) {
//                               setState(() {
//                                 _selectedValue = value as int;
//                               });
//                             },
//                           )
//                         ],
//                       ))
//                   : Text("Are you sure you want to add Expense/Income?",
//                       style: TextStyle(fontSize: 15)),
//               actions: isyes
//                   ? [
//                       ElevatedButton(
//                         onPressed: () {
//                           print("Selected Value: $_selectedValue");
//                           if (_selectedValue == 1 || _selectedValue == 2) {
//                             Navigator.pop(context);
//                             if (_selectedValue == 1) {
//                               _showAddEditExpenseModal(
//                                   expense: null, tripId: tripId);
//                             } else if (_selectedValue == 2) {
//                               _showAddEditIncomeModal(
//                                   income: null, tripId: tripId);
//                             }
//                           } else {
//                             ToastHelper.showCustomToast(
//                                 context,
//                                 "Expense/Income not selected ",
//                                 Colors.red,
//                                 Icons.currency_exchange);
//                           }
//                         },
//                         child: Text("Submit"),
//                       ),
//                     ]
//                   : [
//                       TextButton(
//                         onPressed: () {
//                           Navigator.of(context).pushAndRemoveUntil(
//                             MaterialPageRoute(
//                                 builder: (context) => TripListScreen(
//                                     vehicleid: widget.vehicleid!)),
//                             (route) => false,
//                           );
//                         },
//                         child: Text("No", style: TextStyle(color: Colors.grey)),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8)),
//                         ),
//                         onPressed: () {
//                           setState(() {
//                             isyes = true; // Ensure UI rebuilds
//                           });
//                         },
//                         child: Text("Yes"),
//                       ),
//                     ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   void _showAddEditModal({Trip? trip, int? vehicleid}) {
//     final _formKey = GlobalKey<FormState>();
//     String source = trip?.source ?? "";
//     String destination = trip?.destination ?? "";
//     DateTime startdate = trip?.startDate ?? DateTime.now();
//     DateTime enddate = trip?.endDate ?? DateTime.now();
//     late TextEditingController _dateController1 = TextEditingController();
//     late TextEditingController _dateController2 = TextEditingController();
//     _dateController1.text = _formatDate(startdate);
//     _dateController2.text = _formatDate(enddate);
//     bool _isLoading = false;
//
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return DraggableScrollableSheet(
//             initialChildSize: 0.3.h, // Starts at of screen height
//             minChildSize: 0.2.h, // Minimum height
//             maxChildSize: 0.40.h,
//             expand: false,
//             builder: (context, scrollController) {
//               return StatefulBuilder(
//                 builder: (context, setState) {
//                   return Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(35.r)),
//                     ),
//                     child: SingleChildScrollView(
//                       controller: scrollController,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                           bottom:
//                               MediaQuery.of(context).viewInsets.bottom + 12.h,
//                         ),
//                         child: Column(
//                           children: [
//                             Container(
//                               width: double.infinity,
//                               height: 50.h,
//                               decoration: BoxDecoration(
//                                 color: AppColors
//                                     .secondaryColor, // Adjust color as needed
//                                 borderRadius: BorderRadius.vertical(
//                                     top: Radius.circular(15.r)),
//                               ),
//                               child: Column(
//                                 children: [
//                                   SizedBox(height: 5.h),
//                                   Container(
//                                     width: 80.w,
//                                     height: 5.h,
//                                     padding: EdgeInsets.all(12.h),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20.h),
//                                     ),
//                                   ),
//                                   SizedBox(height: 8.h),
//                                   Text(
//                                     trip == null ? "Add Trip" : "Edit Trip",
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 16.h,
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Form(
//                               key: _formKey,
//                               child: Column(
//                                 mainAxisSize: MainAxisSize.min,
//                                 children: [
//                                   Padding(
//                                     padding: EdgeInsets.only(
//                                       top: 20.h,
//                                       left: 16.h,
//                                       right: 16.h,
//                                       bottom: MediaQuery.of(context)
//                                               .viewInsets
//                                               .bottom +
//                                           16.h,
//                                     ),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                       children: [
//                                         AppInputField(
//                                           label: "Source",
//                                           hint: "Enter Source",
//                                           defaultValue: source,
//                                           onInputChanged: (value) =>
//                                               source = value ?? '',
//                                         ),
//                                         AppInputField(
//                                           label: "Destination",
//                                           hint: "Enter Destination",
//                                           defaultValue: destination,
//                                           onInputChanged: (value) =>
//                                               destination = value ?? '',
//                                         ),
//                                         AppInputField(
//                                           label: "Start Date",
//                                           isDatePicker: true,
//                                           controller: _dateController1,
//                                           onDateSelected: (date) {
//                                             setState(() {
//                                               startdate = date;
//                                               _dateController1.text =
//                                                   _formatDate(date);
//                                             });
//                                           },
//                                         ),
//                                         AppInputField(
//                                           label: "End Date",
//                                           isDatePicker: true,
//                                           controller: _dateController2,
//                                           onDateSelected: (date) {
//                                             setState(() {
//                                               enddate = date;
//                                               _dateController2.text =
//                                                   _formatDate(date);
//                                             });
//                                           },
//                                         ),
//                                         (_isLoading)
//                                             ? const CircularProgressIndicator()
//                                             : Row(
//                                                 children: [
//                                                   Expanded(
//                                                       child: AppPrimaryButton(
//                                                           onPressed: () {
//                                                             Navigator.pop(
//                                                                 context);
//                                                           },
//                                                           title: "Cancel")),
//                                                   SizedBox(width: 10.h),
//                                                   Expanded(
//                                                     child: AppPrimaryButton(
//                                                       onPressed: () async {
//                                                         if (_formKey
//                                                             .currentState!
//                                                             .validate()) {
//                                                           setState(() {
//                                                             _isLoading =
//                                                                 true; // Disable button & show loader
//                                                           });
//
//                                                           final vehicle = Trip(
//                                                             id: trip?.id,
//                                                             source: source,
//                                                             destination:
//                                                                 destination,
//                                                             startDate:
//                                                                 startdate,
//                                                             endDate: enddate,
//                                                             createdAt:
//                                                                 DateTime.now(),
//                                                             updatedAt:
//                                                                 DateTime.now(),
//                                                           );
//
//                                                           try {
//                                                             final response =
//                                                                 await APIService
//                                                                     .instance
//                                                                     .request(
//                                                               trip == null
//                                                                   ? "https://yaantrac-backend.onrender.com/api/trips?vehicleId=${widget.vehicleid}"
//                                                                   : "https://yaantrac-backend.onrender.com/api/trips/${trip.id}/?vehicleId=${widget.vehicleid}",
//                                                               trip == null
//                                                                   ? DioMethod
//                                                                       .post
//                                                                   : DioMethod
//                                                                       .put,
//                                                               formData: vehicle
//                                                                   .toJson(),
//                                                               contentType:
//                                                                   "application/json",
//                                                             );
//
//                                                             if (response
//                                                                     .statusCode ==
//                                                                 200) {
//                                                               ToastHelper.showCustomToast(
//                                                                   context,
//                                                                   trip == null
//                                                                       ? "Trip added successfully"
//                                                                       : "Trip Updated successfully",
//                                                                   Colors.green,
//                                                                   Icons.add);
//                                                               Navigator.pop(
//                                                                   context);
//                                                               if (trip ==
//                                                                   null) {
//                                                                 _confirmexpenseincome(
//                                                                     response.data[
//                                                                         'id']);
//                                                               }
//                                                             } else {
//                                                               ToastHelper
//                                                                   .showCustomToast(
//                                                                       context,
//                                                                       "Failed to add trip",
//                                                                       Colors
//                                                                           .red,
//                                                                       Icons
//                                                                           .error);
//                                                             }
//                                                           } catch (err) {
//                                                             ToastHelper
//                                                                 .showCustomToast(
//                                                                     context,
//                                                                     "Error: $err",
//                                                                     Colors.red,
//                                                                     Icons
//                                                                         .error);
//                                                           } finally {
//                                                             ToastHelper
//                                                                 .showCustomToast(
//                                                                     context,
//                                                                     "Network error! Please try again.",
//                                                                     Colors.red,
//                                                                     Icons
//                                                                         .error);
//                                                             setState(() {
//                                                               _isLoading =
//                                                                   false; // Re-enable button after request
//                                                             });
//                                                           }
//                                                         }
//                                                       },
//                                                       title: trip == null
//                                                           ? "Add"
//                                                           : "Update",
//                                                     ),
//                                                   )
//                                                 ],
//                                               )
//                                       ],
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             });
//       },
//     );
//   }
//
//   Future<List<Trip>> getTrips() async {
//     try {
//       final response = await APIService.instance.request(
//         "https://yaantrac-backend.onrender.com/api/vehicles/${widget.vehicleid}/trips",
//         DioMethod.get,
//         contentType: "application/json",
//       );
//
//       if (response.statusCode == 200) {
//         if (response.data is Map<String, dynamic> &&
//             response.data.containsKey("data")) {
//           List<dynamic> vehicleList = response.data["data"];
//           print(vehicleList);
//           return vehicleList.map((json) => Trip.fromJson(json)).toList();
//         } else if (response.data is List) {
//           return response.data.map((json) => Trip.fromJson(json)).toList();
//         } else {
//           throw Exception("Unexpected response format");
//         }
//       } else {
//         throw Exception("API Error: ${response.statusMessage}");
//       }
//     } catch (e) {
//       debugPrint("Network Error: $e");
//       return []; // Avoids crashing by returning an empty list
//     }
//   }
//
//   Future<void> _confirmDeleteTrip(int tripId) async {
//     bool isDeleting = false;
//
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setState) {
//             return AlertDialog(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(20.r),
//               ),
//               title: Row(
//                 children: [
//                   Icon(Icons.warning_amber_rounded,
//                       color: Colors.red, size: 28.sp),
//                   SizedBox(width: 8.sp),
//                   Text("Confirm Delete",
//                       style: TextStyle(fontWeight: FontWeight.bold)),
//                 ],
//               ),
//               content: isDeleting
//                   ? Column(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         CircularProgressIndicator(),
//                         SizedBox(height: 10.sp),
//                         Text("Deleting Trip... Please wait",
//                             style:
//                                 TextStyle(fontSize: 12.sp, color: Colors.grey)),
//                       ],
//                     )
//                   : Text(
//                       "Are you sure you want to delete this trip? This action cannot be undone.",
//                       style: TextStyle(fontSize: 14.sp)),
//               actions: isDeleting
//                   ? []
//                   : [
//                       TextButton(
//                         onPressed: () => Navigator.pop(context),
//                         child: Text("Cancel",
//                             style: TextStyle(color: Colors.grey)),
//                       ),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(8.r)),
//                         ),
//                         onPressed: () async {
//                           setState(() => isDeleting = true);
//                           await _onDeleteTrip(tripId);
//                           if (context.mounted) Navigator.pop(context);
//                         },
//                         child: Text("Delete",
//                             style: TextStyle(color: Colors.white)),
//                       ),
//                     ],
//             );
//           },
//         );
//       },
//     );
//   }
//
//   Future<void> _onDeleteTrip(int tripId) async {
//     try {
//       final response = await APIService.instance.request(
//         "https://yaantrac-backend.onrender.com/api/trips/$tripId",
//         DioMethod.delete,
//         contentType: "application/json",
//       );
//       if (response.statusCode == 204) {
//         setState(() {
//           futureVehicles = getTrips();
//         });
//         ToastHelper.showCustomToast(
//             context, "Trip deleted successfully", Colors.red, Icons.delete);
//       } else {
//         ToastHelper.showCustomToast(
//             context, "Failed to process request", Colors.red, Icons.error);
//       }
//     } catch (err) {
//       debugPrint("Request failed: $err");
//       ToastHelper.showCustomToast(
//           context, "Network error. Please try again.", Colors.red, Icons.error);
//     }
//   }
//
//   String _formatDate(DateTime date) {
//     return "${date.day.toString().padLeft(2, '0')}-"
//         "${date.month.toString().padLeft(2, '0')}-"
//         "${date.year}";
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;
//
//     return SafeArea(
//         child: Scaffold(
//       appBar: AppBar(
//         title: const Center(
//           child: Text("Trips", style: TextStyle(fontWeight: FontWeight.bold)),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                     builder: (context) =>
//                         HomeScreen())); // Go back to the previous page
//           },
//         ),
//         actions: [
//           IconButton(
//               onPressed: () {
//                 _showAddEditModal(vehicleid: widget.vehicleid);
//               },
//               icon: Icon(
//                 Icons.add_circle,
//                 size: 20.h,
//                 color: Colors.black,
//               ))
//         ],
//         backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
//       ),
//       body: FutureBuilder<List<Trip>>(
//         future: futureVehicles,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError || snapshot.data == null) {
//             return const Center(child: Text("Error loading vehicles"));
//           } else if (snapshot.data!.isEmpty) {
//             return const Center(child: Text("No Trips available"));
//           } else {
//             List<Trip> vehicles = snapshot.data!;
//             return ListView.builder(
//               padding: EdgeInsets.all(12.h),
//               itemCount: vehicles.length,
//               itemBuilder: (context, index) {
//                 final vehicle = vehicles[index];
//                 return Card(
//                   color: isDarkMode ? Colors.grey[800] : Colors.white,
//                   shape:
//                       RoundedRectangleBorder(borderRadius: BorderRadius.zero),
//                   elevation: 2.h,
//                   child: ExpansionTile(
//                     maintainState: true,
//                     tilePadding: EdgeInsets.all(1.h),
//                     onExpansionChanged: (value) => {tid = vehicle.id},
//                     title: _buildVehicleListItem(
//                         vehicle: vehicle,
//                         context: context,
//                         isDarkMode: isDarkMode),
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 10.h, horizontal: 30.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               onPressed: () {
//                                 print(vehicle.id);
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (context) => TripViewPage(
//                                               tripId: vehicle.id!,
//                                               trip: vehicle,
//                                               vehicleId: widget.vehicleid,
//                                             )));
//                               },
//                               icon: Icon(Icons.remove_red_eye),
//                               color: Colors.yellow,
//                               iconSize: 20.h,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _showAddEditModal(
//                                     trip: vehicle, vehicleid: widget.vehicleid);
//                               },
//                               icon: Icon(Icons.edit),
//                               color: Colors.green,
//                               iconSize: 20.h,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _confirmDeleteTrip(tid);
//                               },
//                               icon: const FaIcon(FontAwesomeIcons.trash),
//                               color: Colors.red,
//                               iconSize: 15.h,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     ));
//   }
//
//   Widget _buildVehicleListItem(
//       {required Trip vehicle,
//       required BuildContext context,
//       required bool isDarkMode}) {
//     return SingleChildScrollView(
//       scrollDirection: Axis.vertical,
//       child: ListTile(
//         leading: Icon(
//           Icons.tour,
//           size: 30.h,
//         ),
//         iconColor: Colors.cyanAccent,
//         title: Text("${vehicle.source + "-" + vehicle.destination}",
//             style: TextStyle(
//                 fontSize: 12.h,
//                 fontWeight: FontWeight.bold,
//                 color: isDarkMode ? Colors.white : Colors.black)),
//         subtitle: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Start Date: ${_formatDate(vehicle.startDate)}',
//                 style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
//             Text('End Date: ${_formatDate(vehicle.endDate)}',
//                 style: TextStyle(fontSize: 10.h, color: Colors.blueGrey))
//           ],
//         ),
//       ),
//     );
//   }
// }
