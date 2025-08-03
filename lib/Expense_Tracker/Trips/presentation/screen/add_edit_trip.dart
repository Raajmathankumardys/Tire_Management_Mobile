import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_state.dart';
import '../../../../TMS/Vehicle/repository/vehicle_repository.dart';
import '../../../../TMS/Vehicle/service/vehicle_service.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../../Driver/cubit/driver_cubit.dart';
import '../../../Driver/cubit/driver_state.dart';
import '../../../Driver/repository/driver_repository.dart';
import '../../../Driver/service/driver_service.dart';
import '../../cubit/trips_cubit.dart';
import '../../cubit/trips_state.dart';
import 'package:intl/intl.dart';

class AddEditTrip extends StatefulWidget {
  final BuildContext ctx;
  final Trip? trip;
  final String? vehicleId;
  const AddEditTrip({super.key, required this.ctx, this.trip, this.vehicleId});

  @override
  State<AddEditTrip> createState() => _AddEditTripState();
}

class _AddEditTripState extends State<AddEditTrip> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  TextEditingController startdateController = TextEditingController();
  TextEditingController enddateController = TextEditingController();
  DateTime _startdate = DateTime.now();
  DateTime _enddate = DateTime.now();
  TextEditingController distanceController = TextEditingController();
  TextEditingController incomeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String? status;
  List<Driver> alldrivers = [];
  List<Vehicle> allvehicles = [];
  bool isload = true;
  String? driverId;
  String? vehicleId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.trip != null) {
      sourceController.text = widget.trip!.source;
      destinationController.text = widget.trip!.destination;
      startdateController.text = widget.trip!.startDate;
      enddateController.text = widget.trip!.endDate;
      /*_startdate = widget.trip!.startTime;
      _enddate = widget.trip!.endTime;*/
      incomeController.text = widget.trip!.income.toString();
      distanceController.text = widget.trip!.distance.toString();
      status = widget.trip!.status.toString().split('.').last;
      descriptionController.text = widget.trip!.description ?? " ";
      driverId = widget.trip!.driverId;
      vehicleId = widget.trip!.vehicleId;
    }
    fetchDriver();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> fetchDriver({int maxRetries = 50}) async {
    print("Driver");
    int retry = 0;
    while (retry < maxRetries) {
      final state = context.read<DriverCubit>().state;
      if (state is DriverLoaded) {
        setState(() {
          alldrivers = state.driver;
        });
        await fetchVehicle(); // Call next function after success
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }

    // Handle timeout or error
    print('Driver data failed to load after $maxRetries attempts');
  }

  Future<void> fetchVehicle({int maxRetries = 50}) async {
    int retry = 0;
    while (retry < maxRetries) {
      final state = context.read<VehicleCubit>().state;
      if (state is VehicleLoaded) {
        setState(() {
          allvehicles = state.vehicles;
          print(allvehicles);
          isload = false;
        });
        return;
      }
      await Future.delayed(const Duration(milliseconds: 100));
      retry++;
    }

    // Handle timeout or error
    print('Vehicle data failed to load after $maxRetries attempts');
  }

  @override
  Widget build(BuildContext context) {
    return isload
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    add_edit_modal_top(
                        title: widget.trip == null
                            ? tripconstants.addtrip
                            : tripconstants.edittrip),

                    // Form Inputs
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Column(
                        children: [
                          AppInputField(
                            name: constants.dropdownfield,
                            label: "Driver Name",
                            isDropdown: true,
                            hint: 'Select driver',
                            defaultValue: driverId != null &&
                                    alldrivers.any((t) => t.id == driverId)
                                ? driverId
                                : null,
                            dropdownItems: alldrivers.map((t) {
                              return DropdownMenuItem<String>(
                                value: t.id,
                                child: Text(t.firstName + " " + t.lastName),
                              );
                            }).toList(),
                            required: true,
                            onDropdownChanged: (value) {
                              setState(() {
                                driverId = value;
                              });
                            },
                          ),
                          Visibility(
                            child: AppInputField(
                              name: constants.dropdownfield,
                              label: "Vehicle Number",
                              isDropdown: true,
                              hint: 'Select vehicle number',
                              defaultValue: vehicleId != null &&
                                      allvehicles.any((t) => t.id == vehicleId)
                                  ? vehicleId
                                  : null,
                              dropdownItems: allvehicles.map((t) {
                                return DropdownMenuItem<String>(
                                  value: t.id,
                                  child: Text(t.vehicleNumber),
                                );
                              }).toList(),
                              required: true,
                              onDropdownChanged: (value) {
                                setState(() {
                                  vehicleId = value;
                                });
                              },
                            ),
                            visible: widget.vehicleId == null,
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: tripconstants.source,
                            hint: tripconstants.sourcehint,
                            controller: sourceController,
                            required: true,
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: tripconstants.destination,
                            hint: tripconstants.destinationhint,
                            controller: destinationController,
                            required: true,
                          ),
                          AppInputField(
                            name: constants.datefield,
                            label: tripconstants.startDate,
                            isDatePicker: true,
                            format: DateFormat("yyyy-MM-dd"),
                            controller:
                                startdateController, // Ensure this is initialized
                            onDateSelected: (date) {
                              setState(() {
                                _startdate = date!;
                                startdateController.text = _formatDate(
                                    date); // Update field with formatted date
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.datefield,
                            label: tripconstants.endDate,
                            isDatePicker: true,
                            format: DateFormat("yyyy-MM-dd"),
                            controller:
                                enddateController, // Ensure this is initialized
                            onDateSelected: (date) {
                              setState(() {
                                _enddate = date!;
                                enddateController.text = _formatDate(
                                    date); // Update field with formatted date
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.numberfield,
                            label: "Income",
                            hint: "Enter Income",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            controller: incomeController,
                            required: true,
                          ),
                          AppInputField(
                            name: constants.numberfield,
                            label: "Distance",
                            hint: "Enter Distance",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: distanceController,
                            required: true,
                          ),
                          AppInputField(
                            name: constants.dropdownfield,
                            label: "Status",
                            isDropdown: true,
                            defaultValue: status,
                            dropdownItems: const [
                              DropdownMenuItem(
                                  value: "PLANNED", child: Text("Planned")),
                              DropdownMenuItem(
                                  value: "ACTIVE", child: Text("Active")),
                              DropdownMenuItem(
                                  value: "COMPLETED", child: Text("Completed")),
                              DropdownMenuItem(
                                  value: "CANCELLED", child: Text("Cancelled")),
                            ],
                            onDropdownChanged: (value) {
                              setState(() {
                                status = value;
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: "Description",
                            hint: "Enter description",
                            controller: descriptionController,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppPrimaryButton(
                                width: 130,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                title: constants.cancel,
                              ),
                              AppPrimaryButton(
                                width: 130,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final newtrip = Trip(
                                      id: widget.trip?.id,
                                      source: sourceController.text,
                                      destination: destinationController.text,
                                      startDate: startdateController.text,
                                      endDate: enddateController.text,
                                      vehicleId: widget.vehicleId != null
                                          ? widget.vehicleId!
                                          : vehicleId!,
                                      driverId: driverId!,
                                      distance:
                                          double.parse(distanceController.text),
                                      income:
                                          double.parse(incomeController.text),
                                      status: TripStatus.values.firstWhere(
                                        (e) => e.name == status,
                                        orElse: () => TripStatus
                                            .ACTIVE, // default fallback
                                      ),
                                      description: descriptionController.text,
                                    );

                                    if (widget.trip == null) {
                                      widget.ctx.read<TripCubit>().addTrip(
                                          newtrip,
                                          vehicleId: widget.vehicleId);
                                    } else {
                                      widget.ctx.read<TripCubit>().updateTrip(
                                          newtrip,
                                          vehicleId: widget.vehicleId);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                title: widget.trip == null
                                    ? constants.save
                                    : constants.update,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
