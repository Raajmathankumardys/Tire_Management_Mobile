import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/cubit/vehicle_axle_state.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/cubit/vehicle_category_cubit.dart';
import 'package:yaantrac_app/TMS/Vehicle-Category/cubit/vehicle_category_state.dart';
import 'package:yaantrac_app/helpers/DateValidatorUtils.dart';
import 'package:yaantrac_app/helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/vehicle_state.dart';
import 'package:intl/intl.dart';

class add_edit_modal_vehicle extends StatefulWidget {
  final Vehicle? vehicle;
  final BuildContext ctx;
  const add_edit_modal_vehicle({super.key, this.vehicle, required this.ctx});

  @override
  State<add_edit_modal_vehicle> createState() => _add_edit_modal_vehicleState();
}

class _add_edit_modal_vehicleState extends State<add_edit_modal_vehicle> {
  final _formKey = GlobalKey<FormState>();

  String? status;
  String? type;
  late TextEditingController dotInspectionDateController;
  late TextEditingController freewaySpeedLimitController;
  late TextEditingController fuelCapacityController;
  late TextEditingController fuelTypeController;
  late TextEditingController insuranceExpiryDateController;
  late TextEditingController insuranceNameController;
  late TextEditingController lastServicedDateController;
  late TextEditingController overSpeedLimitController;
  late TextEditingController nonFreewaySpeedLimitController;
  late TextEditingController policyNumberController;
  late TextEditingController registeredStateController;
  late TextEditingController vehicleChassisNumberController;
  late TextEditingController vehicleColorController;
  late TextEditingController vehicleEngineNumberController;
  late TextEditingController vehicleExpirationDateController;
  late TextEditingController vehicleFitnessController;
  late TextEditingController fitnessExpireDateController;
  late TextEditingController vehicleInsuranceController;
  late TextEditingController vehicleMakeController;
  late TextEditingController vehicleModelController;
  late TextEditingController vehicleNumberController;
  late TextEditingController rcExpireDateController;
  late TextEditingController vehicleRcController;
  late TextEditingController vehicleRegistrationDateController;
  late TextEditingController vehicleIdentificationNumberController;
  late TextEditingController yearOfPurchaseController;
  late TextEditingController normalAxleController;
  late TextEditingController stepneyAxleController;
  late TextEditingController driveTypeController;
  late TextEditingController emissionStandardController;
  late TextEditingController engineCapacityController;
  late TextEditingController engineTypeController;
  late TextEditingController manufacturedYearController;
  late TextEditingController subTypeController;
  late TextEditingController transmissionTypeController;

  String? vehicleTypeId;
  String? vehicleCategoryId;
  late int dotInspectionDate;
  late int registrationDate;
  late int expirationDate;
  late int rcExpiryDate;
  late int fitnessExpiryDate;
  late int insuranceDateExpiry;
  late int lastServicedDate;

  String formatEpoch(int epochSeconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    return DateFormat('yyyy-MM-dd HH:mm').format(date);
  }

  VehicleAxle? getMatchingAxle(String axleNumber) {
    try {
      return widget.vehicle?.axles
          ?.firstWhere((v) => v.axleNumber == axleNumber);
    } catch (e) {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    context.read<VehicleCategoryCubit>().fetchVehicleCategories();
    dotInspectionDateController = TextEditingController();
    freewaySpeedLimitController = TextEditingController();
    fuelCapacityController = TextEditingController();
    fuelTypeController = TextEditingController();
    insuranceExpiryDateController = TextEditingController();
    insuranceNameController = TextEditingController();
    lastServicedDateController = TextEditingController();
    overSpeedLimitController = TextEditingController();
    nonFreewaySpeedLimitController = TextEditingController();
    policyNumberController = TextEditingController();
    registeredStateController = TextEditingController();
    vehicleChassisNumberController = TextEditingController();
    vehicleColorController = TextEditingController();
    vehicleEngineNumberController = TextEditingController();
    vehicleExpirationDateController = TextEditingController();
    vehicleFitnessController = TextEditingController();
    fitnessExpireDateController = TextEditingController();
    vehicleInsuranceController = TextEditingController();
    vehicleMakeController = TextEditingController();
    vehicleModelController = TextEditingController();
    vehicleNumberController = TextEditingController();
    rcExpireDateController = TextEditingController();
    vehicleRcController = TextEditingController();
    vehicleRegistrationDateController = TextEditingController();
    vehicleIdentificationNumberController = TextEditingController();
    yearOfPurchaseController = TextEditingController();
    stepneyAxleController = TextEditingController();
    normalAxleController = TextEditingController();
    driveTypeController = TextEditingController();
    emissionStandardController = TextEditingController();
    engineCapacityController = TextEditingController();
    engineTypeController = TextEditingController();
    subTypeController = TextEditingController();
    manufacturedYearController = TextEditingController();
    transmissionTypeController = TextEditingController();
    int stepneyCount = 0;

    if (widget.vehicle != null) {
      final v = widget.vehicle!;
      dotInspectionDateController.text = formatEpoch(v.dotInspectionDate);
      freewaySpeedLimitController.text = v.freewaySpeedLimit?.toString() ?? '';
      fuelCapacityController.text = v.fuelCapacity?.toString() ?? '';
      fuelTypeController.text = v.fuelType ?? '';
      insuranceExpiryDateController.text = formatEpoch(v.insuranceExpiryDate);
      insuranceNameController.text = v.insuranceName ?? '';
      lastServicedDateController.text = formatEpoch(v.lastServicedDate);
      overSpeedLimitController.text = v.overSpeedLimit?.toString() ?? '';
      nonFreewaySpeedLimitController.text =
          v.nonFreewaySpeedLimit?.toString() ?? '';
      policyNumberController.text = v.policyNumber ?? '';
      registeredStateController.text = v.registeredState ?? '';
      vehicleChassisNumberController.text = v.vehicleChassisNumber ?? '';
      vehicleColorController.text = v.vehicleColor ?? '';
      vehicleEngineNumberController.text = v.vehicleEngineNumber ?? '';
      vehicleExpirationDateController.text =
          formatEpoch(v.vehicleExpirationDate);
      vehicleFitnessController.text = v.vehicleFitness ?? '';
      fitnessExpireDateController.text = formatEpoch(v.fitnessExpireDate);
      vehicleInsuranceController.text = v.vehicleInsurance ?? '';
      vehicleMakeController.text = v.vehicleMake ?? '';
      vehicleModelController.text = v.vehicleModel ?? '';
      vehicleNumberController.text = v.vehicleNumber ?? '';
      rcExpireDateController.text = formatEpoch(v.rcExpireDate);
      vehicleRcController.text = v.vehicleRc ?? '';
      vehicleRegistrationDateController.text =
          formatEpoch(v.vehicleRegistrationDate);
      vehicleIdentificationNumberController.text =
          v.vehicleIdentificationNumber ?? '';
      yearOfPurchaseController.text = v.yearOfPurchase?.toString() ?? '';
      vehicleTypeId = v.vehicleTypeId;
      vehicleCategoryId = v.vehicleCategoryId;
      driveTypeController.text = v.vehicleDetail!.driveType ?? '';
      emissionStandardController.text = v.vehicleDetail!.emissionStandard;
      engineTypeController.text = v.vehicleDetail!.engineType;
      engineCapacityController.text = v.vehicleDetail!.engineCapacity;
      manufacturedYearController.text =
          v.vehicleDetail!.manufacturedYear.toString();
      subTypeController.text = v.vehicleDetail!.subType;
      transmissionTypeController.text = v.vehicleDetail!.transmissionType;
      for (VehicleAxle a in v.axles!) {
        if (a.axleNumber[0] == "S") {
          stepneyAxleMap['${a.axleNumber[1]}'] = a.numberOfWheels;
          stepneyAxles.add(a.numberOfWheels);
          stepneyCount += 1;
        } else {
          axleMap['${a.axleNumber[1]}'] = a.numberOfWheels;
          axles.add(a.numberOfWheels);
        }
      }
      stepneyAxleController.text = stepneyCount.toString();
      normalAxleController.text = (v.axles!.length - stepneyCount).toString();
      registrationDate = v.vehicleRegistrationDate;
      expirationDate = v.vehicleExpirationDate;
      rcExpiryDate = v.rcExpireDate;
      fitnessExpiryDate = v.fitnessExpireDate;
      insuranceDateExpiry = v.insuranceExpiryDate;
      dotInspectionDate = v.dotInspectionDate;
      lastServicedDate = v.insuranceExpiryDate;
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
  }

  List<int> axles = [];
  Map<String, int> axleMap = {};

  List<int> stepneyAxles = [];
  Map<String, int> stepneyAxleMap = {};

  void _updateAxleMap(Function setState) {
    setState(() {
      axleMap.clear();
      for (int i = 0; i < axles.length; i++) {
        String key = "${i + 1}";
        axleMap[key] = axles[i];
      }
    });
  }

  void addAxle(Function setState) {
    setState(() {
      axles.insert(axles.length - 1, 2);
      _updateAxleMap(setState);
    });
  }

  void addTires(int index, Function setState) {
    setState(() {
      if (index == 0) return;
      axles[index] += 2;
      _updateAxleMap(setState);
    });
  }

  void removeTires(int index, Function setState) {
    setState(() {
      if (index == 0) return;
      if (axles[index] > 2 || index == axles.length) {
        axles[index] -= 2;
        _updateAxleMap(setState);
      }
    });
  }

  void removeAxle(int index, Function setState) {
    if (index == 0 || index == axles.length - 1) return;
    if (index == 0 || index == axles.length - 1) return;
    setState(() {
      axles.removeAt(index);
      _updateAxleMap(setState);
    });
  }

  void _supdateAxleMap(Function setState) {
    setState(() {
      stepneyAxleMap.clear();
      for (int i = 0; i < stepneyAxles.length; i++) {
        String key = '${i + 1}';
        stepneyAxleMap[key] = stepneyAxles[i];
      }
    });
  }

  void saddAxle(Function setState) {
    setState(() {
      stepneyAxles.insert(stepneyAxles.length - 1, 1);
      _supdateAxleMap(setState);
    });
  }

  void saddTires(int index, Function setState) {
    if (stepneyAxles[index] < 3) {
      setState(() {
        stepneyAxles[index] += 1;
        _supdateAxleMap(setState);
      });
    }
  }

  void sremoveTires(int index, Function setState) {
    setState(() {
      if (stepneyAxles[index] > 1) {
        stepneyAxles[index] -= 1;
        _supdateAxleMap(setState);
      }
    });
  }

  void sremoveAxle(int index, Function setState) {
    setState(() {
      stepneyAxles.removeAt(index);
      _supdateAxleMap(setState);
    });
  }

  String axleSummary(String axlenumbers) {
    return "Axle $axlenumbers";
  }

  String saxleSummary(String axlenumbers) {
    return "Stepney $axlenumbers";
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  title: widget.vehicle == null
                      ? vehicleconstants.addvehicle
                      : vehicleconstants.editvehicle),
              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    Column(
                      children: [
                        BlocBuilder<VehicleCategoryCubit, VehicleCategoryState>(
                          builder: (context, state) {
                            if (state is VehicleCategoryLoaded) {
                              return AppInputField(
                                label: "Vehicle Category",
                                name: "vehicleCategoryId",
                                isDropdown: true,
                                required: true,
                                defaultValue: vehicleCategoryId.toString(),
                                dropdownItems: state.categories
                                    .map((e) => DropdownMenuItem<String>(
                                          value: e.vehicleCategory,
                                          child: Text(e.vehicleCategory),
                                        ))
                                    .toList(),
                              );
                            } else if (state is VehicleCategoryLoading) {
                              return shimmer(
                                count: 1,
                              );
                            }
                            return SizedBox();
                          },
                        ),
                        AppInputField(
                            controller: vehicleNumberController,
                            label: "Vehicle Number",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleChassisNumberController,
                            label: "Chassis Number",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleEngineNumberController,
                            label: "Engine Number",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleColorController,
                            label: "Color",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleFitnessController,
                            label: "Fitness",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleRcController,
                            label: "RC Number",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: policyNumberController,
                            label: "Policy Number",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: registeredStateController,
                            label: "Registered State",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleIdentificationNumberController,
                            label: "VIN",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: insuranceNameController,
                            label: "Insurance Name",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleInsuranceController,
                            label: "Insurance Company",
                            name: 'text',
                            required: true),

                        AppInputField(
                            controller: vehicleMakeController,
                            label: "Vehicle Make",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: vehicleModelController,
                            label: "Vehicle Model",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: fuelTypeController,
                            label: "Fuel Type",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: freewaySpeedLimitController,
                            label: "Freeway Speed Limit",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: nonFreewaySpeedLimitController,
                            label: "Non-Freeway Speed Limit",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: overSpeedLimitController,
                            label: "Over Speed Limit",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: fuelCapacityController,
                            label: "Fuel Capacity",
                            name: 'text',
                            required: true),
                        AppInputField(
                            controller: yearOfPurchaseController,
                            label: "Year of Purchase",
                            name: 'text',
                            required: true),

                        AppInputField(
                          controller: vehicleRegistrationDateController,
                          label: "Registration Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            registrationDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),
                        AppInputField(
                          controller: vehicleExpirationDateController,
                          label: "Expiration Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            expirationDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),
                        AppInputField(
                          controller: rcExpireDateController,
                          label: "RC Expiry Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            rcExpiryDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),
                        AppInputField(
                          controller: fitnessExpireDateController,
                          label: "Fitness Expiry Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            fitnessExpiryDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),
                        AppInputField(
                          controller: insuranceExpiryDateController,
                          label: "Insurance Expiry Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            insuranceDateExpiry =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),
                        AppInputField(
                          name: 'dotInspectionDate',
                          label: 'DOT Inspection Date',
                          controller: dotInspectionDateController,
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            dotInspectionDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),

                        AppInputField(
                          controller: lastServicedDateController,
                          label: "Last Serviced Date",
                          name: 'text',
                          isDateTimePicker: true,
                          required: true,
                          onDateSelected: (DateTime? dateTime) {
                            lastServicedDate =
                                EpochDateConverter.toEpochSeconds(dateTime!);
                          },
                        ),

                        // Dropdowns
                        AppInputField(
                            label: "Vehicle Type",
                            //isDropdown: true,
                            defaultValue: vehicleTypeId.toString(),
                            name: 'text',
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Drive Type",
                            controller: driveTypeController,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Emission Standard",
                            controller: emissionStandardController,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Engine Capacity",
                            controller: engineCapacityController,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Engine Type",
                            controller: engineTypeController,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Manufacture Year",
                            controller: manufacturedYearController,
                            keyboardType: TextInputType.number,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Sub Type",
                            controller: subTypeController,
                            required: true),
                        AppInputField(
                            name: "name",
                            label: "Transmisson Type",
                            controller: transmissionTypeController,
                            required: true),

                        AppInputField(
                          name: 'name',
                          label: "No of Non Stepney Axle",
                          controller: normalAxleController,
                          keyboardType: TextInputType.number,
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Non-Stepney Axle is required";
                            }
                            final intVal = int.tryParse(value);
                            if (intVal == null) {
                              return "Please enter a valid number";
                            }
                            if (intVal < 0) {
                              return "Axle count cannot be negative";
                            }
                            return null;
                          },
                          onInputChanged: (val) {
                            setState(() {
                              axleMap.clear();
                              axles.clear();

                              final count = int.tryParse(val ?? '') ?? 0;

                              if (count > 0) {
                                for (int i = 0; i < count; i++) {
                                  axleMap['${i + 1}'] = 2;
                                  axles.add(
                                      2); // ✅ assuming axles is a List<int>
                                }
                              }
                            });
                          },
                        ),
                        AppInputField(
                          name: 'stepney_axle',
                          label: "No of Stepney Axle",
                          controller: stepneyAxleController,
                          keyboardType: TextInputType.number,
                          required: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Stepney Axle is required";
                            }
                            final intVal = int.tryParse(value);
                            if (intVal == null) {
                              return "Please enter a valid number";
                            }

                            if (intVal < 0) {
                              return "Stepney Axle cannot be negative";
                            }

                            if (intVal > 2) {
                              return "Stepney Axle should not exceed 2";
                            }

                            return null;
                          },
                          onInputChanged: (val) {
                            setState(() {
                              // Clear previously added stepney axles
                              stepneyAxleMap.clear();
                              stepneyAxles.clear();

                              final count = int.tryParse(val ?? '') ?? 0;

                              for (int i = 0; i < count; i++) {
                                stepneyAxleMap['${i + 1}'] =
                                    1; // Assuming 1 tire per stepney axle
                                stepneyAxles.add(1);
                              }
                            });
                          },
                        ),

                        // Placeholder for child DTOs
                        const SizedBox(height: 16),
                        const Text("Non Stepney Axles",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      // Set an appropriate height
                      child: ListView.builder(
                        shrinkWrap: true,
                        // Helps ListView avoid infinite height
                        physics: BouncingScrollPhysics(),
                        // Prevents unnecessary scrolling issues
                        itemCount: axles.length,
                        itemBuilder: (ct, index) {
                          return CustomCard(
                              child: ListTile(
                            leading: SvgPicture.asset(
                              'assets/vectors/T_i.svg',
                              height: 25.sp,
                            ),
                            title: Text(
                              "Axle ${axleMap.keys.elementAt(index)}",
                              style: TextStyle(
                                fontSize: 10.h,
                              ),
                            ),
                            subtitle: Text(
                              "Tires: ${axles[index]}",
                              style: TextStyle(
                                  fontSize: 10.h, fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index != 0) ...[
                                  Tooltip(
                                    message: "Remove 2 tires",
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          removeTires(index, setState),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Add 2 tires",
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () =>
                                          addTires(index, setState),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    const Text("Stepney Axles",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    Container(
                      // Set an appropriate height
                      child: ListView.builder(
                        shrinkWrap: true,
                        // Helps ListView avoid infinite height
                        physics: BouncingScrollPhysics(),
                        // Prevents unnecessary scrolling issues
                        itemCount: stepneyAxles.length,
                        itemBuilder: (ct, index) {
                          return CustomCard(
                              child: ListTile(
                            leading: SvgPicture.asset(
                              'assets/vectors/T_i.svg',
                              height: 25.sp,
                            ),
                            title: Text(
                              "Stepney ${stepneyAxleMap.keys.elementAt(index)}",
                              style: TextStyle(
                                fontSize: 10.h,
                              ),
                            ),
                            subtitle: Text(
                              "Tires: ${stepneyAxles[index]}",
                              style: TextStyle(
                                  fontSize: 10.h, fontWeight: FontWeight.bold),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ...[
                                  Tooltip(
                                    message: "Remove 2 tires",
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          sremoveTires(index, setState),
                                    ),
                                  ),
                                  Tooltip(
                                    message: "Add 2 tires",
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.add_circle,
                                        color: Colors.green,
                                      ),
                                      onPressed: () =>
                                          saddTires(index, setState),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ));
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(15.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(color: Colors.grey, width: 2)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Axle Summary",
                            style: TextStyle(
                                fontSize: 15.h, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 6.h),
                          ...axleMap.entries.map(
                            (entry) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                "${axleSummary(entry.key)}: ${entry.value} tires",
                                style: TextStyle(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          ...stepneyAxleMap.entries.map(
                            (entry) => Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.h),
                              child: Text(
                                "${saxleSummary(entry.key)}: ${entry.value} tires",
                                style: TextStyle(
                                  fontSize: 12.h,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
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
                              List<VehicleAxle> axles = [];
                              int c = 1;

// Regular axles
                              for (var i in axleMap.entries) {
                                final matchingAxle =
                                    getMatchingAxle("A${i.key}");

                                axles.add(VehicleAxle(
                                  id: matchingAxle?.id,
                                  vehicleId: widget.vehicle?.id ?? '',
                                  axleNumber: "A${i.key}",
                                  position: c,
                                  numberOfWheels: i.value,
                                ));

                                c++;
                              }

// Stepney axles
                              for (var i in stepneyAxleMap.entries) {
                                final matchingAxle =
                                    getMatchingAxle("S${i.key}");

                                axles.add(VehicleAxle(
                                  id: matchingAxle?.id,
                                  vehicleId: widget.vehicle?.id ?? '',
                                  axleNumber: "S${i.key}",
                                  position: c,
                                  numberOfWheels: i.value,
                                ));

                                c++;
                              }

                              final newVehicle = Vehicle(
                                id: widget.vehicle?.id,
                                dotInspectionDate: dotInspectionDate,
                                freewaySpeedLimit: double.parse(
                                    freewaySpeedLimitController.text),
                                fuelCapacity:
                                    double.parse(fuelCapacityController.text),
                                fuelType: fuelTypeController.text,
                                // from dropdown or text
                                insuranceExpiryDate: insuranceDateExpiry,
                                insuranceName: insuranceNameController.text,
                                lastServicedDate: lastServicedDate,
                                overSpeedLimit:
                                    double.parse(overSpeedLimitController.text),
                                nonFreewaySpeedLimit: double.parse(
                                    nonFreewaySpeedLimitController.text),
                                policyNumber: policyNumberController.text,
                                registeredState: registeredStateController.text,
                                vehicleChassisNumber:
                                    vehicleChassisNumberController.text,
                                vehicleColor: vehicleColorController.text,
                                vehicleEngineNumber:
                                    vehicleEngineNumberController.text,
                                vehicleExpirationDate: expirationDate,
                                vehicleFitness: vehicleFitnessController.text,
                                fitnessExpireDate: fitnessExpiryDate,
                                vehicleInsurance:
                                    vehicleInsuranceController.text,
                                vehicleMake: vehicleMakeController.text,
                                vehicleModel: vehicleModelController.text,
                                vehicleNumber: vehicleNumberController.text,
                                rcExpireDate: rcExpiryDate,
                                vehicleRc: vehicleRcController.text,
                                vehicleRegistrationDate: registrationDate,
                                vehicleIdentificationNumber:
                                    vehicleIdentificationNumberController.text,
                                yearOfPurchase:
                                    int.parse(yearOfPurchaseController.text),
                                vehicleTypeId: vehicleTypeId!,
                                // from dropdown
                                vehicleCategoryId:
                                    vehicleCategoryId!, // from dropdown

                                // Nested detail DTO
                                vehicleDetail: VehicleDetail(
                                    transmissionType:
                                        transmissionTypeController.text,
                                    driveType: driveTypeController.text,
                                    engineCapacity:
                                        engineCapacityController.text,
                                    engineType: engineTypeController.text,
                                    emissionStandard:
                                        emissionStandardController.text,
                                    subType: subTypeController.text,
                                    manufacturedYear: int.parse(
                                        manufacturedYearController.text)),
                                axles:
                                    axles, // List<Axle> from user input or selection
                              );

                              /*if (widget.vehicle == null) {
                                widget.ctx
                                    .read<VehicleCubit>()
                                    .addVehicle(newVehicle);
                              } else {
                                widget.ctx
                                    .read<VehicleCubit>()
                                    .updateVehicle(newVehicle);
                              }
                              Navigator.pop(context);*/
                            }
                          },
                          title: widget.vehicle == null
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
