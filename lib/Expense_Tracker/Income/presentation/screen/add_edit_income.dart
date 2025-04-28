import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/income_cubit.dart';
import '../../cubit/income_state.dart';

class AddEditIncome extends StatefulWidget {
  final BuildContext ctx;
  final int tripId;
  final Income? income;
  const AddEditIncome(
      {super.key, required this.ctx, required this.tripId, this.income});

  @override
  State<AddEditIncome> createState() => _AddEditIncomeState();
}

class _AddEditIncomeState extends State<AddEditIncome> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController incomedateController = TextEditingController();
  DateTime _incomedate = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.income != null) {
      amountController.text = widget.income!.amount.toString();
      descriptionController.text = widget.income!.description;
      incomedateController.text = _formatDate(widget.income!.incomeDate);
      _incomedate = widget.income!.incomeDate;
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
                  title: widget.income == null ? "Add Income" : "Edit Income"),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.numberfield,
                      label: "Amount",
                      hint: "Enter amount",
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        } else if (double.parse(value) < 10) {
                          return "less than 10";
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: "Income Date",
                      isDatePicker: true,
                      controller:
                          incomedateController, // Ensure this is initialized
                      onDateSelected: (date) {
                        setState(() {
                          _incomedate = date!;
                          incomedateController.text = _formatDate(
                              date); // Update field with formatted date
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: "Description",
                      hint: "Enter description",
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
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
                              final newincome = Income(
                                  id: widget.income?.id,
                                  tripId: widget.tripId,
                                  amount: double.parse(amountController.text),
                                  incomeDate: _incomedate,
                                  description: descriptionController.text,
                                  createdAt: DateTime.now(),
                                  updatedAt: DateTime.now());

                              if (widget.income == null) {
                                widget.ctx
                                    .read<IncomeCubit>()
                                    .addIncome(newincome);
                              } else {
                                widget.ctx
                                    .read<IncomeCubit>()
                                    .updateIncome(newincome);
                              }
                              Navigator.pop(context);
                            }
                          },
                          title: widget.income == null
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
