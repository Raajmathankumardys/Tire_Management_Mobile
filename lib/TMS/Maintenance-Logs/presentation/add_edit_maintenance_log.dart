import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Maintenance-Schedule/cubit/maintenance_schedule_state.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_cubit.dart';
import '../../../../TMS/Vehicle/cubit/vehicle_state.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../cubit/maintenance_log_cubit.dart';
import '../cubit/maintenance_logs_state.dart';
import 'package:intl/intl.dart';

class AddEditMaintenanceLog extends StatefulWidget {
  final BuildContext ctx;
  final MaintenanceLog? maintenancelog;
  const AddEditMaintenanceLog(
      {super.key, required this.ctx, this.maintenancelog});

  @override
  State<AddEditMaintenanceLog> createState() => _AddEditMaintenanceLogState();
}

class _AddEditMaintenanceLogState extends State<AddEditMaintenanceLog> {
  final _formKey = GlobalKey<FormState>();
  String? type;
  TextEditingController performedByController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  TextEditingController costController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool completed = false;
  List<TireInventory> alltires = [];
  List<TireInventory> filtires = [];
  List<Vehicle> allvehicles = [];
  bool isload = true;
  String? tireId;
  String? vehicleId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchTires();
    if (widget.maintenancelog != null) {
      notesController.text = (widget.maintenancelog!.notes == null
          ? " "
          : widget.maintenancelog!.notes!.isEmpty
              ? " "
              : widget.maintenancelog!.notes)!;
      type = widget.maintenancelog!.type.toString().split('.').last;
      dateController.text = widget.maintenancelog!.date;
      performedByController.text = widget.maintenancelog!.performedBy;
      costController.text = widget.maintenancelog!.cost.toString();
      descriptionController.text = widget.maintenancelog!.description;
      tireId = widget.maintenancelog!.tireId;
      vehicleId = widget.maintenancelog!.vehicleId;
      completed = widget.maintenancelog!.completed;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> fetchTires() async {
    final state = await context.read<TireInventoryCubit>().state;
    if (state is! TireInventoryLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTires(); // Try again until loaded
      return;
    }
    setState(() {
      alltires = state.tireinventory;
      if (widget.maintenancelog != null) {
        filtires = alltires
            .where(
                (t) => t.currentVehicleId == widget.maintenancelog!.vehicleId)
            .toList();
      }
    });
    fetchVehicle();
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
                        title: widget.maintenancelog == null
                            ? "Add Log"
                            : "Edit Log"),

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
                                filtires = alltires
                                    .where((t) => t.currentVehicleId == value)
                                    .toList();
                              });
                            },
                          ),
                          AppInputField(
                            name: constants.dropdownfield,
                            label: "Tire",
                            isDropdown: true,
                            hint: 'Select tire',
                            defaultValue: tireId != null &&
                                    filtires.any((t) => t.id == tireId)
                                ? tireId
                                : null,
                            dropdownItems: filtires.map((t) {
                              return DropdownMenuItem<String>(
                                value: t.id,
                                child: Text(t.brand +
                                    " " +
                                    t.model +
                                    " " +
                                    "(" +
                                    t.serialNumber +
                                    ")"),
                              );
                            }).toList(),
                            onDropdownChanged: (value) {
                              setState(() {
                                tireId = value;
                              });
                            },
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: "Performed By",
                            hint: "enter performed by",
                            controller: performedByController,
                            required: true,
                          ),
                          AppInputField(
                            name: constants.datefield,
                            label: "Date",
                            format: DateFormat("yyyy-MM-dd"),
                            isDatePicker: true,
                            controller:
                                dateController, // Ensure this is initialized
                            onDateSelected: (date) {
                              setState(() {
                                dateController.text = _formatDate(
                                    date!); // Update field with formatted date
                              });
                            },
                            required: true,
                          ),
                          AppInputField(
                            name: constants.numberfield,
                            label: "Cost",
                            hint: "Enter cost",
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}')),
                            ],
                            controller: costController,
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
                          Row(
                            children: [
                              Checkbox(
                                activeColor: Colors.blueAccent,
                                value: completed,
                                onChanged: (bool? value) {
                                  setState(() {
                                    completed = value!;
                                  });
                                },
                              ),
                              const Text('Marked as Completed')
                            ],
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
                                    final newmaintenancelog = MaintenanceLog(
                                        id: widget.maintenancelog?.id,
                                        vehicleId: vehicleId ?? "",
                                        tireId: tireId,
                                        type: maintenancetype.values.firstWhere(
                                          (e) => e.name == type,
                                          orElse: () => maintenancetype
                                              .ROUTINE, // default fallback
                                        ),
                                        date: dateController.text,
                                        description: descriptionController.text,
                                        cost: double.parse(costController.text),
                                        performedBy: performedByController.text,
                                        notes: notesController.text,
                                        completed: completed);
                                    print(newmaintenancelog.toJson());
                                    if (widget.maintenancelog == null) {
                                      widget.ctx
                                          .read<MaintenanceLogCubit>()
                                          .addMaintenanceLog(newmaintenancelog);
                                    } else {
                                      widget.ctx
                                          .read<MaintenanceLogCubit>()
                                          .updateMaintenanceLog(
                                              newmaintenancelog);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                title: widget.maintenancelog == null
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
