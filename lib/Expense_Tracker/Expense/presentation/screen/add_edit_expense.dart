import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/expense_cubit.dart';
import '../../cubit/expense_state.dart';

class AddEditExpense extends StatefulWidget {
  final BuildContext ctx;
  final Expense? expense;
  final int tripId;
  const AddEditExpense(
      {super.key, required this.ctx, this.expense, required this.tripId});

  @override
  State<AddEditExpense> createState() => _AddEditExpenseState();
}

class _AddEditExpenseState extends State<AddEditExpense> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  DateTime _date = DateTime.now();
  String? selectedExpenseType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.expense != null) {
      amountController.text = widget.expense!.amount.toString();
      dateController.text = _formatDate(widget.expense!.expenseDate);
      descriptionController.text = widget.expense!.description;
      _date = widget.expense!.expenseDate;
      selectedExpenseType = widget.expense!.category.toString().split('.').last;
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
                  title: widget.expense == null
                      ? expenseconstants.addexpense
                      : expenseconstants.editexpense),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.dropdownfield,
                      label: expenseconstants.expensetype,
                      isDropdown: true,
                      defaultValue: selectedExpenseType,
                      dropdownItems: const [
                        DropdownMenuItem(
                            value: expenseconstants.fuelcostsvalue,
                            child: Text(expenseconstants.fuelcosts)),
                        DropdownMenuItem(
                            value: expenseconstants.driverallowancesvalue,
                            child: Text(expenseconstants.driverallowances)),
                        DropdownMenuItem(
                            value: expenseconstants.tollchargesvalue,
                            child: Text(expenseconstants.tollcharges)),
                        DropdownMenuItem(
                            value: expenseconstants.maintenancevalue,
                            child: Text(expenseconstants.maintenance)),
                        DropdownMenuItem(
                            value: expenseconstants.miscellaneousvalue,
                            child: Text(expenseconstants.miscellaneous)),
                      ],
                      onDropdownChanged: (value) {
                        setState(() {
                          selectedExpenseType = value;
                          print(selectedExpenseType);
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.numberfield,
                      label: expenseconstants.amount,
                      hint: expenseconstants.amounthint,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      controller: amountController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
                      },
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: expenseconstants.expensedate,
                      isDatePicker: true,
                      controller: dateController, // Ensure this is initialized
                      onDateSelected: (date) {
                        setState(() {
                          _date = date!;
                          dateController.text = _formatDate(
                              date); // Update field with formatted date
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: expenseconstants.description,
                      hint: expenseconstants.descriptionhint,
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
                              final newexpense = Expense(
                                description: descriptionController.text,
                                amount: double.parse(amountController.text),
                                category: ExpenseCategory.values.firstWhere(
                                  (e) => e.name == selectedExpenseType,
                                  orElse: () => ExpenseCategory
                                      .MISCELLANEOUS, // default fallback
                                ),
                                expenseDate: _date,
                                tripId: widget.tripId,
                                id: widget.expense?.id,
                                updatedAt: DateTime.now(),
                                createdAt: DateTime.now(),
                              );
                              if (widget.expense == null) {
                                widget.ctx
                                    .read<ExpenseCubit>()
                                    .addExpense(newexpense);
                              } else {
                                widget.ctx
                                    .read<ExpenseCubit>()
                                    .updateExpense(newexpense);
                              }
                              Navigator.pop(context);
                            }
                          },
                          title: widget.expense == null
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
