import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/presentation/constants.dart';
import '../../../../common/widgets/Toast/Toast.dart';
import '../../../../common/widgets/button/action_button.dart';
import '../../../../common/widgets/button/app_primary_button.dart';
import '../../../../common/widgets/input/app_input_field.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../screens/Homepage.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../../presentation/customcard.dart';
import '../../../presentation/deleteDialog.dart';
import '../../../presentation/widget/shimmer.dart';
import '../../cubit/tire_expense_cubit.dart';
import '../../cubit/tire_expense_state.dart';

class Tire_Expense_Screen extends StatefulWidget {
  const Tire_Expense_Screen({super.key});

  @override
  State<Tire_Expense_Screen> createState() => _Tire_Expense_ScreenState();
}

class _Tire_Expense_ScreenState extends State<Tire_Expense_Screen> {
  Future<void> _showAddModal(BuildContext ctx, {TireExpense? tire}) async {
    final _formKey = GlobalKey<FormState>();
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    DateTime? expensedate = tire?.expenseDate ?? DateTime.now();
    int tireId = tire?.tireId ?? 0;
    TextEditingController expensetype = TextEditingController();
    TextEditingController notes = TextEditingController();
    TextEditingController cost = TextEditingController();
    TextEditingController _expensedate = TextEditingController();
    if (tire != null) {
      _expensedate.text = _formatDate(tire.expenseDate);
      expensetype.text = tire.expenseType.toString();
      cost.text = tire.cost.toString();
      notes.text = tire.notes.toString();
    }
    final tireState = context.read<TireInventoryCubit>().state;

    List<TireInventory> tires = [];
    if (tireState is TireInventoryLoaded) {
      tires = tireState.tireinventory;
    }
    // Ensure tireId is a valid ID present in the list, otherwise null
    // if (!tires.any((t) => t.id == tireId)) {
    //   tireId = tires.isNotEmpty ? tires.first.id ?? 0 : 0;
    // }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            decoration: BoxDecoration(
              color: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
              borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ... Modal Header
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 12.h),
                        child: Column(
                          children: [
                            AppInputField(
                              name: constants.dropdownfield,
                              label: tireexpenseconstants.tire,
                              isDropdown: true,
                              hint: 'Select Tire',
                              defaultValue: tireId != 0 &&
                                      tires.any((t) => t.id == tireId)
                                  ? tireId.toString()
                                  : null,
                              dropdownItems: tires.map((t) {
                                return DropdownMenuItem<String>(
                                  value: t.id.toString(),
                                  child: Text(t.serialNo),
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
                                          id: tire?.id,
                                          maintenanceId: null,
                                          cost: double.parse(cost.text),
                                          expenseDate: expensedate!,
                                          expenseType: expensetype.text,
                                          notes: notes.text,
                                          tireId: tireId,
                                        );
                                        tire == null
                                            ? ctx
                                                .read<TireExpenseCubit>()
                                                .addTireExpense(tireExpense)
                                            : ctx
                                                .read<TireExpenseCubit>()
                                                .updateTireExpense(tireExpense);
                                        Navigator.pop(context);
                                      }
                                    },
                                    title: tire == null
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
            ),
          );
        });
      },
    );
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    required content,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteConfirmationDialog(
        onConfirm: onConfirm,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text(tireexpenseconstants.appbar,
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                currentIndex: 1,
                              )),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color:
                        isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                  )),
              elevation: 2.w,
              actions: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  alignment: Alignment.center,
                  child: IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        _showAddModal(context);
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 25.h,
                        color: isdark
                            ? AppColors.darkaddbtn
                            : AppColors.lightaddbtn,
                      )),
                ),
              ],
              backgroundColor:
                  isdark ? AppColors.darkappbar : AppColors.lightappbar,
            ),
            body: BlocConsumer<TireExpenseCubit, TireExpenseState>(
                listener: (context, state) {
              if (state is AddedTireExpenseState ||
                  state is UpdatedTireExpenseState ||
                  state is DeletedTireExpenseState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context,
                    message,
                    Colors.green,
                    (state is AddedTireExpenseState)
                        ? Icons.add
                        : (state is UpdatedTireExpenseState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is TireExpenseError) {
                ToastHelper.showCustomToast(
                    context, state.message, Colors.red, Icons.error);
              }
            }, builder: (context, state) {
              if (state is TireExpenseLoading) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
                  child: shimmer(),
                );
              } else if (state is TireExpenseError) {
                return Center(child: Text(state.message));
              } else if (state is TireExpenseLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.h),
                  itemCount: state.tireexpense.length,
                  itemBuilder: (context, index) {
                    final tire = state.tireexpense[index];
                    return CustomCard(
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.h),
                        leading: Icon(
                          Icons.currency_exchange,
                          size: 30.h,
                        ),
                        title: Text(
                          tire.expenseType.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${tireexpenseconstants.expensedate}: ${_formatDate(tire.expenseDate)}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.sp)),
                            Text("${tireexpenseconstants.cost}: ${tire.cost}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.sp)),
                            Text("${tireexpenseconstants.notes}: ${tire.notes}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.sp)),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 5.h,
                          children: [
                            ActionButton(
                                icon: Icons.edit,
                                color: Colors.green,
                                onPressed: () =>
                                    {_showAddModal(context, tire: tire)}),
                            ActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () async => {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content:
                                            tireexpenseconstants.modaldelete,
                                        onConfirm: () {
                                          context
                                              .read<TireExpenseCubit>()
                                              .deleteTireExpense(tire.id!);
                                        },
                                      )
                                    })
                            //_confirmDelete(tire.id!.toInt())),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: Text(tireexpenseconstants.notireexpense));
            })));
  }
}
