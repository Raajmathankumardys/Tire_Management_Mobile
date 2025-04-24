// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:yaantrac_app/TMS/helpers/components/shimmer.dart';
//
// import '../../../models/trip.dart';
// import '../../../models/vehicle.dart';
//
// import '../../../trash/tiremapping.dart';
// import '../../cubit/base_cubit.dart';
// import '../../cubit/base_state.dart';
// import '../../helpers/components/themes/app_colors.dart';
// import '../../helpers/components/widgets/Toast/Toast.dart';
// import '../../helpers/components/widgets/button/app_primary_button.dart';
// import '../../helpers/components/widgets/input/app_input_field.dart';
// import '../../repository/base_repository.dart';
// import '../../service/base_service.dart';
// import '../../../models/trip_list_screen.dart';
//
// class vehiclelistscreen_ extends StatefulWidget {
//   const vehiclelistscreen_({super.key});
//   @override
//   State<vehiclelistscreen_> createState() => _vehiclelistscreen_State();
// }
//
// class _vehiclelistscreen_State extends State<vehiclelistscreen_> {
//   late Future<List<Vehicle>> futureVehicles;
//   int? vid;
//   void _showAddEditModal(BuildContext ctx, [Vehicle? vehicle]) {
//     final _formKey = GlobalKey<FormState>();
//
//     // Initialize controllers
//     TextEditingController nameController = TextEditingController();
//     TextEditingController typeController = TextEditingController();
//     TextEditingController licensePlateController = TextEditingController();
//     TextEditingController yearController = TextEditingController();
//     TextEditingController axleNoController = TextEditingController();
//
//     // Prefill values if editing an existing vehicle
//     if (vehicle != null) {
//       nameController.text = vehicle.name;
//       typeController.text = vehicle.type;
//       licensePlateController.text = vehicle.licensePlate;
//       yearController.text = vehicle.manufactureYear.toString();
//       axleNoController.text = vehicle.axleNo.toString();
//     }
//
//     showModalBottomSheet(
//       context: ctx,
//       isScrollControlled: true,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (context) {
//         return StatefulBuilder(builder: (context, setState) {
//           return Padding(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom + 12,
//             ),
//             child: SingleChildScrollView(
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     // Header
//                     Container(
//                       width: double.infinity,
//                       height: 40.h,
//                       decoration: BoxDecoration(
//                         color: Colors.blueAccent,
//                         borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(15.r)),
//                       ),
//                       child: Column(
//                         children: [
//                           SizedBox(height: 5.h),
//                           Container(
//                             width: 80,
//                             height: 5.h,
//                             decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                           ),
//                           SizedBox(height: 5.h),
//                           Text(
//                             vehicle == null ? "Add Vehicle" : "Edit Vehicle",
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 10.h,
//                               fontWeight: FontWeight.w500,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//
//                     // Form Inputs
//                     Padding(
//                       padding: EdgeInsets.symmetric(
//                           horizontal: 12.w, vertical: 12.h),
//                       child: Column(
//                         children: [
//                           AppInputField(
//                             name: 'text_field',
//                             label: "Name",
//                             hint: "Enter vehicle name",
//                             controller: nameController,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'This field is required';
//                               }
//                               if (value.length < 3) {
//                                 return "Name must have 3 atleast characters";
//                               }
//                               return null;
//                             },
//                           ),
//                           AppInputField(
//                             name: 'text_field',
//                             label: "Type",
//                             hint: "Enter vehicle type",
//                             controller: typeController,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'This field is required';
//                               }
//                               if (value.length < 2) {
//                                 return "Vehicle Type must have 2 atleast characters";
//                               }
//                               return null;
//                             },
//                           ),
//                           AppInputField(
//                             name: 'text_field',
//                             label: "License Plate",
//                             hint: "Enter license plate",
//                             controller: licensePlateController,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return "License plate is required";
//                               }
//                               // Regular expression for alphanumeric license plate (6-10 chars)
//                               final licensePlatePattern = RegExp(
//                                   r'^[A-Z0-9]{6,10}$',
//                                   caseSensitive: false);
//                               if (!licensePlatePattern.hasMatch(value)) {
//                                 return "Invalid license plate format (6-10 alphanumeric characters)";
//                               }
//                               return null;
//                             },
//                           ),
//                           AppInputField(
//                             name: 'number_field',
//                             label: "Manufacture Year",
//                             hint: "Enter year",
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             controller: yearController,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'This field is required';
//                               } else if (int.parse(value) <= 1900 ||
//                                   int.parse(value) >
//                                       (DateTime.now().year).toInt()) {
//                                 return "Pls enter a Valid year";
//                               }
//                               return null;
//                             },
//                           ),
//                           AppInputField(
//                             name: 'number_field',
//                             label: "Axle No",
//                             hint: "Enter axle no.",
//                             keyboardType: TextInputType.number,
//                             inputFormatters: [
//                               FilteringTextInputFormatter.digitsOnly
//                             ],
//                             controller: axleNoController,
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'This field is required';
//                               } else if (int.parse(value) < 2) {
//                                 return "Vehcile must have atleast 2 axles ";
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(height: 10),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                             children: [
//                               AppPrimaryButton(
//                                 width: 130,
//                                 onPressed: () {
//                                   Navigator.pop(context);
//                                 },
//                                 title: "Cancel",
//                               ),
//                               AppPrimaryButton(
//                                 width: 130,
//                                 onPressed: () {
//                                   if (_formKey.currentState!.validate()) {
//                                     final newVehicle = Vehicle(
//                                       id: vehicle?.id,
//                                       name: nameController.text,
//                                       licensePlate: licensePlateController.text,
//                                       manufactureYear:
//                                           int.parse(yearController.text),
//                                       type: typeController.text,
//                                       axleNo: int.parse(axleNoController.text),
//                                     );
//
//                                     if (vehicle == null) {
//                                       ctx
//                                           .read<BaseCubit<Vehicle>>()
//                                           .addItem(newVehicle);
//                                     } else {
//                                       ctx
//                                           .read<BaseCubit<Vehicle>>()
//                                           .updateItem(newVehicle, vehicle.id!);
//                                     }
//                                     Navigator.pop(context);
//                                   }
//                                 },
//                                 title: vehicle == null ? "Save" : "Update",
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//       },
//     );
//   }
//
//   Future<void> _confirmDeleteVehicle(BuildContext ctx, int vehicleId) async {
//     await showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//           title: Row(
//             children: const [
//               Icon(Icons.warning_amber_rounded, color: Colors.red, size: 25),
//               SizedBox(width: 8),
//               Text("Confirm Delete",
//                   style: TextStyle(fontWeight: FontWeight.bold)),
//             ],
//           ),
//           content: const Text(
//             "Are you sure you want to delete this vehicle? This action cannot be undone.",
//             style: TextStyle(fontSize: 14),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
//             ),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//               ),
//               onPressed: () {
//                 ctx.read<BaseCubit<Vehicle>>().deleteItem(vehicleId);
//                 Navigator.pop(context);
//               },
//               child:
//                   const Text("Delete", style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Center(
//             child: Text("Vehicles",
//                 style: TextStyle(fontWeight: FontWeight.bold))),
//         backgroundColor: AppColors.secondaryColor,
//         leading: IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back_ios)),
//         actions: [
//           IconButton(
//               onPressed: () => {_showAddEditModal(context)},
//               icon: Icon(
//                 Icons.add_circle,
//                 color: Colors.black,
//               ))
//         ],
//       ),
//       body: BlocConsumer<BaseCubit<Vehicle>, BaseState<Vehicle>>(
//         listener: (context, state) {
//           print(state);
//           if (state is AddedState ||
//               state is UpdatedState ||
//               state is DeletedState) {
//             final message = (state as dynamic).message;
//             String updatedMessage = message.toString().replaceAllMapped(
//                 RegExp(r'\bitem\b', caseSensitive: false),
//                 (match) => "Vehicle");
//             ToastHelper.showCustomToast(
//                 context,
//                 updatedMessage,
//                 Colors.green,
//                 (state is AddedState)
//                     ? Icons.add
//                     : (state is UpdatedState)
//                         ? Icons.edit
//                         : Icons.delete);
//           } else if (state is ApiErrorState<Vehicle>) {
//             String updatedMessage = state.message.toString().replaceAllMapped(
//                 RegExp(r'\bitem\b', caseSensitive: false),
//                 (match) => "vehicle");
//             ToastHelper.showCustomToast(
//                 context, updatedMessage, Colors.red, Icons.error);
//           }
//         },
//         builder: (context, state) {
//           if (state is LoadingState<Vehicle>) {
//             return shimmer();
//           } else if (state is ErrorState<Vehicle>) {
//             String updatedMessage = state.message.toString().replaceAllMapped(
//                 RegExp(r'\bitem\b', caseSensitive: false),
//                 (match) => "vehicle");
//             return Center(child: Text(updatedMessage));
//           } else if (state is LoadedState<Vehicle>) {
//             return ListView.builder(
//               itemCount: state.items.length,
//               itemBuilder: (context, index) {
//                 final vehicle = state.items[index];
//                 return Card(
//                   elevation: 2.h,
//                   child: ExpansionTile(
//                     tilePadding: EdgeInsets.all(2.h),
//                     onExpansionChanged: (value) {
//                       setState(() {
//                         vid = vehicle.id;
//                       });
//                     },
//                     title: _buildVehicleListItem(vehicle, context),
//                     children: [
//                       Padding(
//                         padding: EdgeInsets.symmetric(
//                             vertical: 10.h, horizontal: 20.w),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                                 onPressed: () {
//                                   Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                           builder: (context) =>
//                                               AxleAnimationPage(
//                                                 vehicleid: vehicle.id!,
//                                               )));
//                                 },
//                                 icon: Icon(
//                                   Icons.tire_repair_outlined,
//                                   color: Colors.grey,
//                                   size: 20.h,
//                                 )),
//                             IconButton(
//                               onPressed: () {
//                                 /*Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                        builder: (context) => tripslistscreen(
//                                               vehicleid: vehicle.id!,
//                                             )));*/
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) => BlocProvider(
//                                       create: (context) => BaseCubit<Trip>(
//                                         BaseRepository<Trip>(
//                                           BaseService<Trip>(
//                                             baseUrl:
//                                                 "/vehicles/${vehicle.id!}/trips",
//                                             fromJson: Trip.fromJson,
//                                             toJson: (trip) => trip.toJson(),
//                                           ),
//                                         ),
//                                       )..fetchItems(),
//                                       child: tripslistscreen(
//                                           vehicleid: vehicle.id!),
//                                     ),
//                                   ),
//                                 );
//                               },
//                               icon: Icon(Icons.tour),
//                               color: Colors.cyanAccent,
//                               iconSize: 20.h,
//                             ),
//                             IconButton(
//                               onPressed: () {
//                                 _showAddEditModal(context, vehicle);
//                               },
//                               icon: const FaIcon(Icons.edit),
//                               color: Colors.green,
//                               iconSize: 20.h,
//                             ),
//                             IconButton(
//                                 onPressed: () {
//                                   _confirmDeleteVehicle(context, vehicle.id!);
//                                 },
//                                 icon: const FaIcon(FontAwesomeIcons.trash),
//                                 color: Colors.red,
//                                 iconSize: 15.h),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           }
//           return Center(child: Text("No vehicles available"));
//         },
//       ),
//     );
//   }
//
//   Widget _buildVehicleListItem(Vehicle vehicle, BuildContext context) {
//     return ListTile(
//       leading: Icon(Icons.directions_car, size: 30.h, color: Colors.blueAccent),
//       title: Text("${vehicle.name + " " + vehicle.type}",
//           style: TextStyle(
//               fontSize: 12.w,
//               fontWeight: FontWeight.bold,
//               color: Colors.black)),
//       subtitle: Text(
//           'License: ${vehicle.licensePlate}  Year: ${vehicle.manufactureYear}',
//           style: TextStyle(fontSize: 10.h, color: Colors.blueGrey)),
//     );
//   }
// }
