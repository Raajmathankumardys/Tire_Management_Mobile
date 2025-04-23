import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yaantrac_app/TMS/helpers/components/widgets/button/action_button.dart';
import '../TMS/Trips/cubit/trips_state.dart';
import '../TMS/helpers/components/shimmer.dart';
import '../TMS/helpers/components/themes/app_colors.dart';
import '../TMS/helpers/components/widgets/Card/customcard.dart';

import '../TMS/helpers/components/widgets/Toast/Toast.dart';
import '../TMS/helpers/components/widgets/button/app_primary_button.dart';
import '../TMS/helpers/components/widgets/input/app_input_field.dart';

import '../screens/Homepage.dart';
import '../screens/expensescreen.dart';
import '../TMS/cubit/base_cubit.dart';
import '../TMS/cubit/base_state.dart';
import '../TMS/repository/base_repository.dart';
import '../TMS/service/base_service.dart';

class tripslistscreen extends StatefulWidget {
  final int vehicleid;
  const tripslistscreen({super.key, required this.vehicleid});

  @override
  State<tripslistscreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<tripslistscreen> {
  int? tid;

  void _showAddEditModal(BuildContext ctx, {Trip? trip, int? vehicleid}) {
    final _formKey = GlobalKey<FormState>();
    String source = trip?.source ?? "";
    String destination = trip?.destination ?? "";
    DateTime startdate = trip?.startDate ?? DateTime.now();
    DateTime enddate = trip?.endDate ?? DateTime.now();
    late TextEditingController _dateController1 = TextEditingController();
    late TextEditingController _dateController2 = TextEditingController();
    _dateController1.text = _formatDate(startdate);
    _dateController2.text = _formatDate(enddate);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: AppColors
                              .secondaryColor, // Adjust color as needed
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15.r)),
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 5.h),
                            Container(
                              width: 80.w,
                              height: 5.h,
                              padding: EdgeInsets.all(12.h),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20.h),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              trip == null ? "Add Trip" : "Edit Trip",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.h,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                top: 20.h,
                                left: 16.h,
                                right: 16.h,
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                        16.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppInputField(
                                    name: 'text_field',
                                    label: "Source",
                                    hint: "Enter Source",
                                    defaultValue: source,
                                    onInputChanged: (value) =>
                                        source = value ?? '',
                                  ),
                                  AppInputField(
                                    name: 'text_field',
                                    label: "Destination",
                                    hint: "Enter Destination",
                                    defaultValue: destination,
                                    onInputChanged: (value) =>
                                        destination = value ?? '',
                                  ),
                                  AppInputField(
                                    name: 'date_field',
                                    label: "Start Date",
                                    isDatePicker: true,
                                    controller: _dateController1,
                                    onDateSelected: (date) {
                                      setState(() {
                                        startdate = date!;
                                        _dateController1.text =
                                            _formatDate(date);
                                      });
                                    },
                                  ),
                                  AppInputField(
                                    name: 'date_field',
                                    label: "End Date",
                                    isDatePicker: true,
                                    controller: _dateController2,
                                    onDateSelected: (date) {
                                      setState(() {
                                        enddate = date!;
                                        _dateController2.text =
                                            _formatDate(date);
                                      });
                                    },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                          child: AppPrimaryButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              title: "Cancel")),
                                      SizedBox(width: 10.h),
                                      Expanded(
                                        child: AppPrimaryButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              Trip newtrip = Trip(
                                                id: trip?.id,
                                                source: source,
                                                destination: destination,
                                                startDate: startdate,
                                                endDate: enddate,
                                                createdAt: DateTime.now(),
                                                updatedAt: DateTime.now(),
                                              );
                                              print(newtrip.toJson());
                                              trip == null
                                                  ? ctx
                                                      .read<BaseCubit<Trip>>()
                                                      .addItem(newtrip,
                                                          endpoint:
                                                              "https://yaantrac-backend.onrender.com/api/trips?vehicleId=${widget.vehicleid}")
                                                  : ctx
                                                      .read<BaseCubit<Trip>>()
                                                      .updateItem(
                                                          newtrip, trip.id!,
                                                          endpoint:
                                                              "https://yaantrac-backend.onrender.com/api/trips/${trip.id}/?vehicleId=${widget.vehicleid}");
                                              Navigator.pop(context);
                                            }
                                          },
                                          title:
                                              trip == null ? "Add" : "Update",
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _confirmDeleteTrip(BuildContext ctx, int tripId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28.sp),
                  SizedBox(width: 8.sp),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: Text(
                  "Are you sure you want to delete this trip? This action cannot be undone.",
                  style: TextStyle(fontSize: 14.sp)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Cancel", style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r)),
                  ),
                  onPressed: () async {
                    ctx.read<BaseCubit<Trip>>().deleteItem(tripId,
                        endpoint:
                            "https://yaantrac-backend.onrender.com/api/trips/$tripId");
                    Navigator.pop(context);
                  },
                  child: Text("Delete", style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          title: const Center(
            child: Text("Trips", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          HomeScreen())); // Go back to the previous page
            },
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _showAddEditModal(context, vehicleid: widget.vehicleid);
                },
                icon: Icon(
                  Icons.add_circle,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                ))
          ],
          backgroundColor:
              isdark ? Colors.grey.shade900 : AppColors.lightappbar,
        ),
        body: BlocConsumer<BaseCubit<Trip>, BaseState<Trip>>(
          listener: (context, state) {
            if (state is AddedState) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context, message, Colors.green, Icons.check);
            } else if (state is DeletedState) {
              final message = (state as dynamic).message;
              ToastHelper.showCustomToast(
                  context, message, Colors.green, Icons.check);
            } else if (state is ErrorState<Trip>) {
              ToastHelper.showCustomToast(
                  context, state.message, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is LoadingState<Trip>) {
              return shimmer();
            } else if (state is ErrorState<Trip>) {
              return Center(child: Text(state.message));
            } else if (state is LoadedState<Trip>) {
              return ListView.builder(
                itemCount: state.items.length,
                itemBuilder: (context, index) {
                  final trip = state.items[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                    child: CustomCard(
                      color: isdark ? Colors.black54 : Colors.grey.shade100,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Start and End Dates
                                Row(
                                  children: [
                                    Text("Start Date: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(_formatDate(trip.startDate)),
                                  ],
                                ),
                                SizedBox(height: 3.h),
                                Row(
                                  children: [
                                    Text("End Date: ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(_formatDate(trip.endDate)),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                // Source with Icon
                                Row(
                                  children: [
                                    Icon(Icons.trip_origin,
                                        size: 18.sp, color: Colors.blue),
                                    SizedBox(width: 6.w),
                                    Text(trip.source,
                                        style: TextStyle(fontSize: 14.sp)),
                                  ],
                                ),

                                // Dotted path
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 1.w, bottom: 0.w),
                                  child: Column(
                                    children: List.generate(
                                      2,
                                      (_) => Icon(Icons.more_vert,
                                          size: 14.sp, color: Colors.grey),
                                    ),
                                  ),
                                ),

                                // Destination with Icon
                                Row(
                                  children: [
                                    Icon(Icons.location_pin, color: Colors.red),
                                    SizedBox(width: 6.w),
                                    Text(trip.destination,
                                        style: TextStyle(fontSize: 14.sp)),
                                  ],
                                ),
                              ],
                            ),

                            // Right side: Action buttons
                            Column(
                              children: [
                                ActionButton(
                                  icon: Icons.summarize_sharp,
                                  color: Colors.grey,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TripViewPage(
                                          tripId: trip.id!,
                                          trip: trip,
                                          vehicleId: widget.vehicleid,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: 1.h),
                                ActionButton(
                                  icon: Icons.edit,
                                  color: Colors.green,
                                  onPressed: () {
                                    _showAddEditModal(context,
                                        trip: trip,
                                        vehicleid: widget.vehicleid);
                                  },
                                ),
                                SizedBox(height: 1.h),
                                ActionButton(
                                  icon: Icons.delete_outline,
                                  color: Colors.red,
                                  onPressed: () {
                                    _confirmDeleteTrip(context, trip.id!);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text("No trips available"));
          },
        ));
  }

  Widget _buildVehicleListItem({
    required Trip vehicle,
    required BuildContext context,
  }) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: ListTile(
        leading: Icon(
          Icons.tour,
          size: 30.h,
        ),
        iconColor: Colors.cyanAccent,
        title: Text("${vehicle.source + "-" + vehicle.destination}",
            style: TextStyle(
                fontSize: 12.h,
                fontWeight: FontWeight.bold,
                color: isDarkMode ? Colors.white : Colors.black)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Start Date: ${_formatDate(vehicle.startDate)}',
                style: TextStyle(fontSize: 10.h, color: Colors.grey)),
            Text(' End Date : ${_formatDate(vehicle.endDate)}',
                style: TextStyle(fontSize: 10.h, color: Colors.grey))
          ],
        ),
      ),
    );
  }
}
