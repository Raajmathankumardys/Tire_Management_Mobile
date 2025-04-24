import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Expense/presentation/screen/add_edit_modal_tire_expense.dart';
import 'package:yaantrac_app/TMS/helpers/constants.dart';
import '../../../presentation/screen/Homepage.dart';
import '../../../helpers/components/themes/app_colors.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/button/action_button.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';

import '../../cubit/tire_expense_cubit.dart';
import '../../cubit/tire_expense_state.dart';
import 'package:intl/intl.dart';

class Tire_Expense_Screen extends StatefulWidget {
  const Tire_Expense_Screen({super.key});

  @override
  State<Tire_Expense_Screen> createState() => _Tire_Expense_ScreenState();
}

class _Tire_Expense_ScreenState extends State<Tire_Expense_Screen> {
  Future<void> _showAddModal(BuildContext ctx, {TireExpense? tire}) async {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) {
        return add_edit_modal_tire_expense(ctx: ctx, tire: tire);
      },
    );
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

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
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
                return state.tireexpense.isEmpty
                    ? Center(
                        child: Text(tireexpenseconstants.notireexpense),
                      )
                    : ListView.builder(
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
                                          color: Colors.grey[400],
                                          fontSize: 10.sp)),
                                  Text(
                                      "${tireexpenseconstants.cost}: ${tire.cost}",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 10.sp)),
                                  Text(
                                      "${tireexpenseconstants.notes}: ${tire.notes}",
                                      style: TextStyle(
                                          color: Colors.grey[400],
                                          fontSize: 10.sp)),
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
                                              content: tireexpenseconstants
                                                  .modaldelete,
                                              onConfirm: () {
                                                context
                                                    .read<TireExpenseCubit>()
                                                    .deleteTireExpense(
                                                        tire, tire.id!);
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
              return Center(
                  child: Text(
                tireexpenseconstants.notireexpense,
              ));
            })));
  }
}
