import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../helpers/constants.dart';
import '../cubit/driver_cubit.dart';
import '../cubit/driver_state.dart';

class add_edit_driver extends StatefulWidget {
  final BuildContext ctx;
  final Driver? driver;
  const add_edit_driver({super.key, required this.ctx, this.driver});

  @override
  State<add_edit_driver> createState() => _add_edit_driverState();
}

class _add_edit_driverState extends State<add_edit_driver> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnamecontroller = TextEditingController();
  TextEditingController lastnamecontroller = TextEditingController();
  TextEditingController licensenumbercontroller = TextEditingController();
  TextEditingController licenseexpirycontroller = TextEditingController();
  TextEditingController contactnumbercontroller = TextEditingController();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController addresscontroller = TextEditingController();
  String? status;

  String _formatDate(DateTime date) {
    return "${date.year}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.driver != null) {
      firstnamecontroller.text = widget.driver!.firstName;
      lastnamecontroller.text = widget.driver!.lastName;
      licensenumbercontroller.text = widget.driver!.licenseNumber;
      contactnumbercontroller.text = widget.driver!.contactNumber ?? " ";
      emailcontroller.text = widget.driver!.email;
      addresscontroller.text = widget.driver!.address ?? " ";
      licenseexpirycontroller.text = widget.driver!.licenseExpiry ?? " ";
      status = widget.driver!.status.toString().split('.').last;
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
                  title: widget.driver == null ? "Add Driver" : "Edit"),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.dropdownfield,
                      label: "Status",
                      isDropdown: true,
                      defaultValue: status,
                      dropdownItems: const [
                        DropdownMenuItem(
                            value: "INACTIVE", child: Text("Inactive")),
                        DropdownMenuItem(
                            value: "ACTIVE", child: Text("Active")),
                        DropdownMenuItem(
                            value: "ON_LEAVE", child: Text("On Leave")),
                        DropdownMenuItem(
                            value: "ON_TRIP", child: Text("On Trip")),
                        DropdownMenuItem(
                            value: "SUSPENDED", child: Text("Suspended")),
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
                      label: "First Name",
                      hint: "enter first name",
                      controller: firstnamecontroller,
                      required: true,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "Last Name",
                      hint: "enter last name",
                      controller: lastnamecontroller,
                      required: true,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "Contact Number",
                      hint: "enter contact number",
                      controller: contactnumbercontroller,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "Email",
                      hint: "enter email",
                      controller: emailcontroller,
                      required: true,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "Address",
                      hint: "enter address",
                      controller: addresscontroller,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "License Number",
                      hint: "enter license number",
                      controller: licensenumbercontroller,
                      required: true,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "License Expiry",
                      hint: "enter in YYYY-MM-DD format",
                      controller: licenseexpirycontroller,
                    ),
                    SizedBox(height: 10.h),
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
                              final newdriver = Driver(
                                id: widget.driver?.id,
                                firstName: firstnamecontroller.text,
                                lastName: lastnamecontroller.text,
                                licenseNumber: licensenumbercontroller.text,
                                email: emailcontroller.text,
                                address: addresscontroller.text,
                                contactNumber: contactnumbercontroller.text,
                                licenseExpiry: licenseexpirycontroller.text,
                                active: true,
                                isActive: true,
                                status: DriverStatus.values.firstWhere(
                                  (e) => e.name == status,
                                  orElse: () =>
                                      DriverStatus.INACTIVE, // default fallback
                                ),
                              );

                              if (widget.driver == null) {
                                widget.ctx
                                    .read<DriverCubit>()
                                    .addDriver(newdriver);
                              } else {
                                widget.ctx.read<DriverCubit>().updateDriver(
                                    newdriver, widget.driver!.id!);
                              }
                              Navigator.pop(context);
                            }
                          },
                          title: widget.driver == null
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
