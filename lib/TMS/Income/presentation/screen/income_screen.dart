import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Income/presentation/screen/add_edit_income.dart';
import '../../../helpers/components/shimmer.dart';
import '../../../helpers/components/widgets/Card/customcard.dart';
import '../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../helpers/components/widgets/button/action_button.dart';
import '../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../helpers/components/widgets/deleteDialog.dart';
import '../../cubit/income_cubit.dart';
import '../../cubit/income_state.dart';

class IncomeScreen extends StatefulWidget {
  final int tripId;
  const IncomeScreen({super.key, required this.tripId});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  void _showAddEditModal(BuildContext ctx, [Income? income]) {
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEditIncome(
          ctx: ctx,
          income: income,
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
            title: "Add Income"),
      ),
      body: RefreshIndicator(
        child: BlocConsumer<IncomeCubit, IncomeState>(
          listener: (context, state) {
            if (state is AddedIncomeState ||
                state is UpdatedIncomeState ||
                state is DeletedIncomeState) {
              final message = (state as dynamic).message;
              String updatedMessage = message.toString();
              ToastHelper.showCustomToast(
                  context,
                  updatedMessage,
                  Colors.green,
                  (state is AddedIncomeState)
                      ? Icons.add
                      : (state is UpdatedIncomeState)
                          ? Icons.edit
                          : Icons.delete);
            } else if (state is IncomeError) {
              String updatedMessage = state.message.toString();
              ToastHelper.showCustomToast(
                  context, updatedMessage, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is IncomeLoading) {
              return shimmer(
                count: 7,
              );
            } else if (state is IncomeError) {
              String updatedMessage = state.message.toString();
              return Center(child: Text(updatedMessage));
            } else if (state is IncomeLoaded) {
              return ListView.builder(
                itemCount: state.income.length,
                itemBuilder: (context, index) {
                  final income = state.income[index];
                  return SingleChildScrollView(
                      child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 3.h, horizontal: 6.w),
                    child: CustomCard(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Colors
                                  .green, // Optional: Make dynamic if needed
                              width: 5.w,
                            ),
                          ),
                          borderRadius: BorderRadius.circular(5.r),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(12.h),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              /// Income Details
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Amount",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(income.amount.toString())
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Income Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(width: 5.w),
                                        Text(_formatDate(income.incomeDate))
                                      ],
                                    ),
                                    if (income.description.trim().isNotEmpty)
                                      Row(
                                        children: [
                                          Text(
                                            "Description",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          SizedBox(width: 5.w),
                                          Text(income.description.toString())
                                        ],
                                      )
                                  ],
                                ),
                              ),
                              Row(
                                children: [
                                  ActionButton(
                                    icon: Icons.edit,
                                    color: Colors.green,
                                    onPressed: () =>
                                        _showAddEditModal(context, income),
                                  ),
                                  SizedBox(width: 4.w),
                                  ActionButton(
                                    icon: Icons.delete_outline,
                                    color: Colors.red,
                                    onPressed: () async {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content:
                                            "Are you sure you want to delete this income?",
                                        onConfirm: () {
                                          context
                                              .read<IncomeCubit>()
                                              .deleteIncome(income, income.id!);
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
                  ));
                },
              );
            }
            return Center(child: Text("No Income Found"));
          },
        ),
        onRefresh: () async =>
            {context.read<IncomeCubit>().fetchIncome(widget.tripId)},
        color: Colors.blueAccent,
      ),
    );
  }
}
