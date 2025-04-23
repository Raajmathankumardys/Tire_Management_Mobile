import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/button/action_button.dart';
import '../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';
import '../../cubit/expense_cubit.dart';
import '../../cubit/expense_state.dart';
import '../widget/build_info_card.dart';
import 'add_edit_expense.dart';

class ExpenseScreen extends StatefulWidget {
  final int tripId;
  const ExpenseScreen({super.key, required this.tripId});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  void _showAddEditModal(BuildContext ctx, [Expense? expense]) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEditExpense(
          ctx: ctx,
          expense: expense,
          tripId: widget.tripId,
        );
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
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Color _getCategoryColor(String category) {
    switch (category.split(".")[1]) {
      case 'FUEL':
        return Colors.yellowAccent;
      case 'DRIVER_ALLOWANCE':
        return Colors.orangeAccent;
      case 'TOLL':
        return Colors.cyanAccent;
      case 'MAINTENANCE':
        return Colors.lightGreenAccent;
      default:
        return Colors.tealAccent; // Default color if category not found
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdark ? Colors.grey.shade900 : Colors.white70,
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(16),
        child: AppPrimaryButton(
            onPressed: () {
              _showAddEditModal(context);
            },
            title: "Add Expense"),
      ),
      body: RefreshIndicator(
        child: BlocConsumer<ExpenseCubit, ExpenseState>(
          listener: (context, state) {
            if (state is AddedExpenseState ||
                state is UpdatedExpenseState ||
                state is DeletedExpenseState) {
              final message = (state as dynamic).message;
              String updatedMessage = message.toString();
              ToastHelper.showCustomToast(
                  context,
                  updatedMessage,
                  Colors.green,
                  (state is AddedExpenseState)
                      ? Icons.add
                      : (state is UpdatedExpenseState)
                          ? Icons.edit
                          : Icons.delete);
            } else if (state is ExpenseError) {
              String updatedMessage = state.message.toString();
              ToastHelper.showCustomToast(
                  context, updatedMessage, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is ExpenseLoading) {
              return shimmer(
                count: 7,
              );
            } else if (state is ExpenseError) {
              String updatedMessage = state.message.toString();
              return Center(child: Text(updatedMessage));
            } else if (state is ExpenseLoaded) {
              return ListView.builder(
                itemCount: state.expense.length,
                itemBuilder: (context, index) {
                  final expense = state.expense[index];

                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
                      child: CustomCard(
                        color: _getCategoryColor(
                            expense.category.toString().toUpperCase()),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Container(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 1.h, horizontal: 8.w),
                            child: Row(
                              children: [
                                /// Leading Icon
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      12.h, 16.h, 12.h, 16.h),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6.r),
                                      color: Colors.grey.shade500),
                                  child: Icon(
                                    Icons.receipt_long,
                                    size: 24.h,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(width: 8.w),

                                /// Expense Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InfoCard(
                                        icon: Icons.category,
                                        value: expense.category
                                            .toString()
                                            .split('.')
                                            .last,
                                        iconcolor: Colors.blue,
                                      ),
                                      InfoCard(
                                        icon: Icons.attach_money,
                                        value:
                                            '₹${expense.amount.toStringAsFixed(2)}',
                                        iconcolor: Colors.redAccent,
                                      ),
                                      InfoCard(
                                        icon: Icons.calendar_today,
                                        value: _formatDate(expense.expenseDate),
                                        iconcolor: Colors.pink,
                                      ),
                                      if (expense.description.isNotEmpty)
                                        InfoCard(
                                          icon: Icons.description,
                                          value: expense.description,
                                          iconcolor: Colors.indigoAccent,
                                        ),
                                    ],
                                  ),
                                ),

                                /// Action Buttons (Smaller)
                                Row(
                                  children: [
                                    ActionButton(
                                      icon: Icons.edit,
                                      color: Colors.green,
                                      onPressed: () =>
                                          _showAddEditModal(context, expense),
                                    ),
                                    ActionButton(
                                      icon: Icons.delete_outline,
                                      color: Colors.red,
                                      onPressed: () async {
                                        await showDeleteConfirmationDialog(
                                          context: context,
                                          content:
                                              "Are you sure you want to delete this expense?",
                                          onConfirm: () {
                                            context
                                                .read<ExpenseCubit>()
                                                .deleteExpense(
                                                    expense, expense.id!);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return Center(child: Text("No Income Found"));
          },
        ),
        onRefresh: () async =>
            {context.read<ExpenseCubit>().fetchExpense(widget.tripId)},
        color: Colors.blueAccent,
      ),
    );
  }
}
