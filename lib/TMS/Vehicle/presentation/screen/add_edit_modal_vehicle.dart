import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yaantrac_app/TMS/helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import 'package:yaantrac_app/TMS/helpers/components/widgets/Card/customcard.dart';

import '../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../helpers/constants.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';

class add_edit_modal_vehicle extends StatefulWidget {
  final Vehicle? vehicle;
  final BuildContext ctx;
  const add_edit_modal_vehicle({super.key, this.vehicle, required this.ctx});

  @override
  State<add_edit_modal_vehicle> createState() => _add_edit_modal_vehicleState();
}

class _add_edit_modal_vehicleState extends State<add_edit_modal_vehicle> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController yearController = TextEditingController();
  TextEditingController axleNoController = TextEditingController();
  List<int> axles = [2, 2];
  Map<String, int> axleMap = {"F": 2, "R": 2};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.vehicle != null) {
      nameController.text = widget.vehicle!.name;
      typeController.text = widget.vehicle!.type;
      licensePlateController.text = widget.vehicle!.licensePlate;
      yearController.text = widget.vehicle!.manufactureYear.toString();
      axleNoController.text = widget.vehicle!.axleNo.toString();
    }
  }

  void _updateAxleMap(Function setState) {
    setState(() {
      axleMap.clear();
      for (int i = 0; i < axles.length; i++) {
        String key =
            (i == 0) ? "F" : (i == axles.length - 1 ? "R" : "${i + 1}");
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

  String axleSummary(String axlenumbers) {
    if (axlenumbers == "F") {
      return "Front";
    }
    if (axlenumbers == "R") {
      return "Rear";
    } else {
      return "Axle $axlenumbers";
    }
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
                    AppInputField(
                      name: constants.textfield,
                      label: vehicleconstants.name,
                      hint: vehicleconstants.namehint,
                      controller: nameController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        if (value.length < 3) {
                          return vehicleconstants.namevalidation;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: vehicleconstants.type,
                      hint: vehicleconstants.typehint,
                      controller: typeController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        if (value.length < 2) {
                          return vehicleconstants.typevalidation;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: vehicleconstants.licenseplate,
                      hint: vehicleconstants.licenseplatehint,
                      controller: licensePlateController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        // Regular expression for alphanumeric license plate (6-10 chars)
                        final licensePlatePattern = RegExp(
                            vehicleconstants.licenseplateregex,
                            caseSensitive: false);
                        if (!licensePlatePattern.hasMatch(value)) {
                          return vehicleconstants.licenseplatevalidation;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.numberfield,
                      label: vehicleconstants.manufactureyear,
                      hint: vehicleconstants.manufactureyearhint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: yearController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        } else if (int.parse(value) <= 1900 ||
                            int.parse(value) > (DateTime.now().year).toInt()) {
                          return vehicleconstants.manufactureyearvalidation;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.numberfield,
                      label: vehicleconstants.axleno,
                      hint: vehicleconstants.axlenohint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: axleNoController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        } else if (int.parse(value) < 0) {
                          return vehicleconstants.axlenovalidation;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Container(
                      // Set an appropriate height
                      child: ListView.builder(
                        shrinkWrap:
                            true, // Helps ListView avoid infinite height
                        physics:
                            BouncingScrollPhysics(), // Prevents unnecessary scrolling issues
                        itemCount: axles.length,
                        itemBuilder: (ct, index) {
                          return CustomCard(
                              child: ListTile(
                            leading: SvgPicture.asset(
                              'assets/vectors/T_i.svg',
                              height: 25.sp,
                            ),
                            title: Text(
                              axleMap.keys.elementAt(index) == "F"
                                  ? "Front Axle"
                                  : axleMap.keys.elementAt(index) == "R"
                                      ? "Rear Axle"
                                      : "Axle ${axleMap.keys.elementAt(index)}",
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
                                  if (index != axles.length - 1)
                                    Tooltip(
                                      message: "Remove Axle",
                                      child: IconButton(
                                        icon: Icon(Icons.delete,
                                            color: Colors.grey),
                                        onPressed: () =>
                                            removeAxle(index, setState),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: Colors.grey, width: 2)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Axle Summary",
                                style: TextStyle(
                                    fontSize: 10.h,
                                    fontWeight: FontWeight.bold),
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
                            ],
                          ),
                        ),
                        FloatingActionButton.extended(
                          onPressed: () => {addAxle(setState)},
                          label: Text("Add Axle"),
                          icon: Icon(Icons.add),
                          backgroundColor: Colors.blue,
                        ),
                      ],
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
                              final newVehicle = Vehicle(
                                id: widget.vehicle?.id,
                                name: nameController.text,
                                licensePlate: licensePlateController.text,
                                manufactureYear: int.parse(yearController.text),
                                type: typeController.text,
                                axleNo: int.parse(axleNoController.text),
                              );

                              if (widget.vehicle == null) {
                                widget.ctx
                                    .read<VehicleCubit>()
                                    .addVehicle(newVehicle);
                              } else {
                                widget.ctx
                                    .read<VehicleCubit>()
                                    .updateVehicle(newVehicle);
                              }
                              Navigator.pop(context);
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
