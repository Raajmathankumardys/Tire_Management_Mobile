import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Expense/cubit/tire_expense_state.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import 'package:intl/intl.dart';
import '../../cubit/tire_expense_cubit.dart';

class add_edit_modal_tire_expense extends StatefulWidget {
  final TireExpense? tire;
  final BuildContext ctx;
  const add_edit_modal_tire_expense({super.key, this.tire, required this.ctx});

  @override
  State<add_edit_modal_tire_expense> createState() =>
      _add_edit_modal_tire_expenseState();
}

class _add_edit_modal_tire_expenseState
    extends State<add_edit_modal_tire_expense> {
  final _formKey = GlobalKey<FormState>();
  DateTime? expensedate;
  int? tireId;
  TextEditingController expensetype = TextEditingController();
  TextEditingController notes = TextEditingController();
  TextEditingController cost = TextEditingController();
  TextEditingController _expensedate = TextEditingController();
  List<TireInventory> tires = [];
  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  @override
  void initState() {
    // TODO: implement initState
    final tireState = context.read<TireInventoryCubit>().state;
    if (tireState is TireInventoryLoaded) {
      tires = tireState.tireinventory;
    }
    if (widget.tire != null) {
      _expensedate.text = _formatDate(widget.tire!.expenseDate);
      expensetype.text = widget.tire!.expenseType.toString();
      cost.text = widget.tire!.cost.toString();
      notes.text = widget.tire!.notes.toString();
    }
    expensedate = widget.tire?.expenseDate ?? DateTime.now();
    tireId = widget.tire?.tireId ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              add_edit_modal_top(
                  title: widget.tire == null
                      ? tireexpenseconstants.addtireexpense
                      : tireexpenseconstants.edittireexpense),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                child: Column(
                  children: [
                    AppInputField(
                      name: constants.dropdownfield,
                      label: tireexpenseconstants.tire,
                      isDropdown: true,
                      hint: 'Select Tire',
                      defaultValue:
                          tireId != 0 && tires.any((t) => t.id == tireId)
                              ? tireId.toString()
                              : null,
                      dropdownItems: tires.map((t) {
                        return DropdownMenuItem<String>(
                          value: t.id.toString(),
                          child: Text(t.serialNumber),
                        );
                      }).toList(),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
                      },
                      onDropdownChanged: (value) {
                        setState(() {
                          tireId = int.tryParse(value ?? '') ?? 0;
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.numberfield,
                      label: tireexpenseconstants.cost,
                      hint: tireexpenseconstants.costhint,
                      keyboardType: TextInputType.number,
                      controller: cost,
                      validator: (value) =>
                          value!.isEmpty ? constants.required : null,
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: tireexpenseconstants.expensetype,
                      hint: tireexpenseconstants.expensetypehint,
                      controller: expensetype,
                      validator: (value) =>
                          value!.isEmpty ? constants.required : null,
                    ),
                    AppInputField(
                      name: constants.datefield,
                      label: tireexpenseconstants.expensedate,
                      isDatePicker: true,
                      controller: _expensedate,
                      validator: (value) =>
                          value!.isEmpty ? constants.required : null,
                      onDateSelected: (date) {
                        setState(() {
                          expensedate = date!;
                          _expensedate.text = _formatDate(date);
                        });
                      },
                    ),
                    AppInputField(
                      name: constants.textfield,
                      label: tireexpenseconstants.notes,
                      hint: tireexpenseconstants.noteshint,
                      controller: notes,
                      validator: (value) =>
                          value!.isEmpty ? constants.required : null,
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: AppPrimaryButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            title: constants.cancel,
                          ),
                        ),
                        SizedBox(width: 4.h),
                        Expanded(
                          child: AppPrimaryButton(
                            width: 130.h,
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                final tireExpense = TireExpense(
                                  id: widget.tire?.id,
                                  maintenanceId: null,
                                  cost: double.parse(cost.text),
                                  expenseDate: expensedate!,
                                  expenseType: expensetype.text,
                                  notes: notes.text,
                                  tireId: tireId!,
                                );
                                widget.tire == null
                                    ? widget.ctx
                                        .read<TireExpenseCubit>()
                                        .addTireExpense(tireExpense)
                                    : widget.ctx
                                        .read<TireExpenseCubit>()
                                        .updateTireExpense(tireExpense);
                                Navigator.pop(context);
                              }
                            },
                            title: widget.tire == null
                                ? constants.save
                                : constants.update,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
