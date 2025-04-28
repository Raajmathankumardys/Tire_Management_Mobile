import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/trips_cubit.dart';
import '../../cubit/trips_state.dart';

class AddEditTrip extends StatefulWidget {
  final BuildContext ctx;
  final Trip? trip;
  final int vehicleId;
  const AddEditTrip(
      {super.key, required this.ctx, this.trip, required this.vehicleId});

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
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.trip != null) {
      sourceController.text = widget.trip!.source;
      destinationController.text = widget.trip!.destination;
      startdateController.text = _formatDate(widget.trip!.startDate);
      enddateController.text = _formatDate(widget.trip!.endDate);
      _startdate = widget.trip!.startDate;
      _enddate = widget.trip!.endDate;
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
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
                  title: widget.trip == null
                      ? tripconstants.addtrip
                      : tripconstants.edittrip),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.textfield,
                      label: tripconstants.source,
                      hint: tripconstants.sourcehint,
                      controller: sourceController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: tripconstants.destination,
                      hint: tripconstants.destinationhint,
                      controller: destinationController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: tripconstants.startDate,
                      isDatePicker: true,
                      controller:
                          startdateController, // Ensure this is initialized
                      onDateSelected: (date) {
                        setState(() {
                          _startdate = date!;
                          startdateController.text = _formatDate(
                              date); // Update field with formatted date
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: tripconstants.endDate,
                      isDatePicker: true,
                      controller:
                          enddateController, // Ensure this is initialized
                      onDateSelected: (date) {
                        setState(() {
                          _enddate = date!;
                          enddateController.text = _formatDate(
                              date); // Update field with formatted date
                        });
                      },
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
                              final newtrip = Trip(
                                  id: widget.trip?.id,
                                  source: sourceController.text,
                                  destination: destinationController.text,
                                  startDate: _startdate,
                                  endDate: _enddate,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now());

                              if (widget.trip == null) {
                                widget.ctx
                                    .read<TripCubit>()
                                    .addTrip(newtrip, widget.vehicleId);
                              } else {
                                widget.ctx
                                    .read<TripCubit>()
                                    .updateTrip(newtrip, widget.vehicleId);
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
