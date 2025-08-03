import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/Expense_Tracker/Driver/cubit/driver_state.dart';
import 'package:yaantrac_app/Expense_Tracker/Report/presentation/screen/report_screen.dart';
import 'package:yaantrac_app/helpers/components/shimmer.dart';
import 'package:yaantrac_app/helpers/components/widgets/Toast/Toast.dart';
import '../../helpers/components/widgets/input/app_input_field.dart';
import '../../helpers/constants.dart';

import '../../helpers/components/themes/app_colors.dart';
import '../../helpers/components/widgets/button/app_primary_button.dart';
import '../Expense_Tracker/Driver/cubit/driver_cubit.dart';
import '../Expense_Tracker/Report/cubit/report_cubit.dart';
import '../Expense_Tracker/Report/repository/report_repository.dart';
import '../Expense_Tracker/Report/service/report_service.dart';
import '../Expense_Tracker/Trips/cubit/trips_cubit.dart';
import '../Expense_Tracker/Trips/cubit/trips_state.dart';
import '../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../TMS/Vehicle/cubit/vehicle_state.dart';

class FilterExpenseScreen extends StatefulWidget {
  const FilterExpenseScreen({super.key});

  @override
  State<FilterExpenseScreen> createState() => _FilterExpenseScreenState();
}

class _FilterExpenseScreenState extends State<FilterExpenseScreen> {
  DateTime? startDate;
  DateTime? endDate;

  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _vehiclenumberController =
      TextEditingController();
  final TextEditingController _drivernameController = TextEditingController();

  List<Trip> tripIds = [];
  List<Trip> filteredtripIds = [];
  List<Driver> drivers = [];
  List<Driver> filtereddrivers = [];
  List<Vehicle> vehicles = [];
  String? selectedTripId = null;
  String? svn;
  String? sdn;
  bool isload = true;

  Future<void> fetchTrips() async {
    final state = await context.read<TripCubit>().state;
    if (state is! TripLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTrips(); // Try again until loaded
      return;
    }
    setState(() {
      tripIds = state.trip;
      filteredtripIds = tripIds;
    });
    fetchDrivers();
  }

  Future<void> fetchDrivers() async {
    final state = await context.read<DriverCubit>().state;
    if (state is! DriverLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchDrivers(); // Try again until loaded
      return;
    }
    setState(() {
      drivers = state.driver;
      filtereddrivers = drivers;
    });
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final state = await context.read<VehicleCubit>().state;
    if (state is! VehicleLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchVehicles(); // Try again until loaded
      return;
    }
    setState(() {
      vehicles = state.vehicles;
      isload = false;
    });
  }

  void _setDateRange(DateTime start, DateTime end) {
    setState(() {
      startDate = start;
      endDate = end;
      _startDateController.text = DateFormat('yyyy-MM-dd').format(start);
      _endDateController.text = DateFormat('yyyy-MM-dd').format(end);
    });
  }

  void _applyChip(String label) {
    final today = DateTime.now();
    switch (label) {
      case "Day Before Yesterday":
        _setDateRange(today.subtract(const Duration(days: 2)),
            today.subtract(const Duration(days: 2)));
        break;
      case "Yesterday":
        _setDateRange(today.subtract(const Duration(days: 1)),
            today.subtract(const Duration(days: 1)));
        break;
      case "Today":
        _setDateRange(today, today);
        break;
      case "Tomorrow":
        _setDateRange(today.add(const Duration(days: 1)),
            today.add(const Duration(days: 1)));
        break;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  @override
  void initState() {
    super.initState();
    fetchTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        centerTitle: true,
        title: const Text("Filter Reports",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: isload
          ? shimmer()
          : Padding(
              padding: EdgeInsets.all(12.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Date Range",
                        style: TextStyle(
                            fontSize: 16.h, fontWeight: FontWeight.w700)),
                    Wrap(
                      spacing: 5.h,
                      children: [
                        "Day Before Yesterday",
                        "Yesterday",
                        "Today",
                        "Tomorrow"
                      ]
                          .map((label) => ChoiceChip(
                                label: Text(label),
                                selected: false,
                                onSelected: (_) => _applyChip(label),
                              ))
                          .toList(),
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: "Start Date",
                      required: true,
                      isDatePicker: true,
                      controller: _startDateController,
                      format: DateFormat("yyyy-MM-dd"),
                      onDateSelected: (value) {
                        if (value != null) {
                          setState(() {
                            startDate = value;
                            _startDateController.text =
                                DateFormat("yyyy-MM-dd").format(value);
                          });
                        }
                      },
                      datevalidator: (value) {
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: "End Date",
                      required: true,
                      isDatePicker: true,
                      controller: _endDateController,
                      format: DateFormat("yyyy-MM-dd"),
                      onDateSelected: (value) {
                        if (value != null) {
                          setState(() {
                            endDate = value;
                            _endDateController.text =
                                DateFormat("yyyy-MM-dd").format(value);
                          });
                        }
                      },
                      datevalidator: (value) {
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    DropdownButtonFormField<String>(
                      value: vehicles.any((t) => t.id == svn) ? svn : null,
                      decoration: InputDecoration(
                        labelText: 'Vehicle Number',
                        hintText: 'Enter Vehicle Number',
                        border: OutlineInputBorder(),
                      ),
                      items: vehicles.map((t) {
                        return DropdownMenuItem<String>(
                          value: t.id,
                          child: Text(
                            t.vehicleNumber,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          svn = value;
                          filteredtripIds = tripIds
                              .where((trip) => trip.vehicleId == svn)
                              .toList();
                          final driverIds =
                              filteredtripIds.map((t) => t.driverId).toSet();
                          filtereddrivers = drivers
                              .where((d) => driverIds.contains(d.id))
                              .toList();

                          // Reset driver and trip selections on vehicle change
                          sdn = null;
                          selectedTripId = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    DropdownButtonFormField<String>(
                      value:
                          filtereddrivers.any((d) => d.id == sdn) ? sdn : null,
                      decoration: InputDecoration(
                        labelText: 'Drivers',
                        hintText: 'Select driver',
                        border: OutlineInputBorder(),
                      ),
                      items: filtereddrivers.map((t) {
                        return DropdownMenuItem<String>(
                          value: t.id,
                          child: Text(
                            '${t.firstName} ${t.lastName} ${t.email}',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          sdn = value;
                          filteredtripIds = tripIds
                              .where((trip) =>
                                  trip.driverId == sdn && trip.vehicleId == svn)
                              .toList();

                          // Reset trip on driver change
                          selectedTripId = null;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    DropdownButtonFormField<String>(
                      value: filteredtripIds.any((t) => t.id == selectedTripId)
                          ? selectedTripId
                          : null,
                      decoration: InputDecoration(
                        labelText: 'Trip',
                        hintText: 'Select Trip',
                        border: OutlineInputBorder(),
                      ),
                      items: filteredtripIds.map((t) {
                        return DropdownMenuItem<String>(
                          value: t.id,
                          child: Text(
                            '${t.source} - ${t.destination} (${t.startDate} to ${t.endDate})',
                            style: TextStyle(fontSize: 12.sp),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTripId = value;
                        });
                      },
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                      child: AppPrimaryButton(
                        onPressed: () {
                          if (startDate == null || endDate == null) {
                            ToastHelper.showCustomToast(
                                context,
                                "Please select both start and end dates.",
                                Colors.red,
                                Icons.warning);

                            return;
                          }

                          if (startDate!.isAfter(endDate!)) {
                            ToastHelper.showCustomToast(
                                context,
                                "Start date cannot be after end date.",
                                Colors.red,
                                Icons.warning);
                            return;
                          }

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    MultiBlocProvider(providers: [
                                  Provider<ReportService>(
                                    create: (_) => ReportService(),
                                  ),
                                  BlocProvider<ReportCubit>(
                                    create: (context) {
                                      final service =
                                          context.read<ReportService>();
                                      final repo = ReportRepository(service);
                                      return ReportCubit(repo)
                                        ..fetchReport(
                                            startDate:
                                                _startDateController.text,
                                            endDate: _endDateController.text,
                                            tripId: selectedTripId,
                                            driverName: sdn,
                                            vehicleNumber: svn);
                                    },
                                  ),
                                ], child: ReportScreen()),
                              ));
                        },
                        title: "Apply Filters",
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
