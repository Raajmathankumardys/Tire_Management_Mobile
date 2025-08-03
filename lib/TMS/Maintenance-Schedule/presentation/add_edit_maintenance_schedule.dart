import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Maintenance-Schedule/cubit/maintenance_schedule_state.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_state.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import 'package:intl/intl.dart';
import '../cubit/maintenance_schedule_cubit.dart';

class AddEditMaintenanceSchedule extends StatefulWidget {
  final BuildContext ctx;
  final MaintenanceSchedule? maintenanceSchedule;
  const AddEditMaintenanceSchedule(
      {super.key, required this.ctx, this.maintenanceSchedule});

  @override
  State<AddEditMaintenanceSchedule> createState() =>
      _AddEditMaintenanceScheduleState();
}

class _AddEditMaintenanceScheduleState
    extends State<AddEditMaintenanceSchedule> {
  final _formKey = GlobalKey<FormState>();
  String? type;
  String? status;
  TextEditingController scheduledDateController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<Vehicle> allvehicles = [];
  bool isload = true;
  String? vehicleId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchVehicle();
    if (widget.maintenanceSchedule != null) {
      notesController.text = (widget.maintenanceSchedule!.notes == null
          ? " "
          : widget.maintenanceSchedule!.notes!.isEmpty
              ? " "
              : widget.maintenanceSchedule!.notes)!;
      type = widget.maintenanceSchedule!.type.toString().split('.').last;
      scheduledDateController.text = widget.maintenanceSchedule!.scheduledDate;
      descriptionController.text = widget.maintenanceSchedule!.description;
      vehicleId = widget.maintenanceSchedule!.vehicleId;
      status = widget.maintenanceSchedule!.status.toString().split('.').last;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> fetchVehicle() async {
    final state = await context.read<VehicleCubit>().state;
    if (state is! VehicleLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchVehicle(); // Try again until loaded
      return;
    }
    setState(() {
      allvehicles = state.vehicles;
      isload = false;
    });
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
                        title: widget.maintenanceSchedule == null
                            ? "Add Schedule"
                            : "Edit Schedule"),

                    // Form Inputs
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Column(
                        children: [
                          AppInputField(
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
                          AppInputField(
                            name: constants.datefield,
                            label: "Scheduled Date",
                            format: DateFormat("yyyy-MM-dd"),
                            isDatePicker: true,
                            controller:
                                scheduledDateController, // Ensure this is initialized
                            onDateSelected: (date) {
                              setState(() {
                                scheduledDateController.text = _formatDate(
                                    date!); // Update field with formatted date
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.dropdownfield,
                            label: "TYPE",
                            isDropdown: true,
                            defaultValue: type,
                            dropdownItems: const [
                              DropdownMenuItem(
                                  value: "ROUTINE", child: Text("Routine")),
                              DropdownMenuItem(
                                  value: "PREVENTIVE",
                                  child: Text("Preventive")),
                              DropdownMenuItem(
                                  value: "CORRECTIVE",
                                  child: Text("Corrective")),
                              DropdownMenuItem(
                                  value: "PREDICTIVE",
                                  child: Text("Predictive")),
                              DropdownMenuItem(
                                  value: "CONDITION_BASED",
                                  child: Text("Condition Based")),
                            ],
                            onDropdownChanged: (value) {
                              setState(() {
                                type = value;
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.dropdownfield,
                            label: "STATUS",
                            isDropdown: true,
                            defaultValue: status,
                            dropdownItems: const [
                              DropdownMenuItem(
                                  value: "PENDING", child: Text("Pending")),
                              DropdownMenuItem(
                                  value: "IN_PROGRESS",
                                  child: Text("In Progress")),
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
                            required: true,
                            controller: descriptionController,
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: "Notes",
                            hint: "enter notes",
                            controller: notesController,
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
                                    final newmaintenanceschedule =
                                        MaintenanceSchedule(
                                            id: widget.maintenanceSchedule?.id,
                                            vehicleId: vehicleId!,
                                            type: maintenancetype.values
                                                .firstWhere(
                                              (e) => e.name == type,
                                              orElse: () => maintenancetype
                                                  .ROUTINE, // default fallback
                                            ),
                                            scheduledDate:
                                                scheduledDateController.text,
                                            description:
                                                descriptionController.text,
                                            status: maintenancestatus.values
                                                .firstWhere(
                                              (e) => e.name == status,
                                              orElse: () => maintenancestatus
                                                  .PENDING, // default fallback
                                            ),
                                            createdAt: widget
                                                        .maintenanceSchedule ==
                                                    null
                                                ? _formatDate(DateTime.now())
                                                : widget.maintenanceSchedule!
                                                    .createdAt,
                                            updatedAt:
                                                _formatDate(DateTime.now()));
                                    if (widget.maintenanceSchedule == null) {
                                      widget.ctx
                                          .read<MaintenanceScheduleCubit>()
                                          .addMaintenanceSchedule(
                                              newmaintenanceschedule);
                                    } else {
                                      widget.ctx
                                          .read<MaintenanceScheduleCubit>()
                                          .updateMaintenanceSchedule(
                                              newmaintenanceschedule);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                title: widget.maintenanceSchedule == null
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
