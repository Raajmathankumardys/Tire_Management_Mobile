import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../../commonScreen/expensescreen.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../Income/cubit/income_cubit.dart';
import '../../../Income/repository/income_repository.dart';
import '../../../Income/service/income_service.dart';
import '../../../Trip-Profit-Summary/cubit/trip_profit_summary_cubit.dart';
import '../../../Trip-Profit-Summary/repository/trip_profit_summary_repository.dart';
import '../../../Trip-Profit-Summary/service/trip_profit_summary_service.dart';
import '../../../Trips/cubit/trips_state.dart';
import '../../cubit/expense_cubit.dart';
import '../../cubit/expense_state.dart';
import '../../repository/expense_repository.dart';
import '../../service/expense_service.dart';
import '../widget/build_info_card.dart';
import 'add_edit_expense.dart';
import 'package:intl/intl.dart';

class ExpenseScreen extends StatefulWidget {
  final int tripId;
  final Trip trip;
  final int vehicleid;
  final bool isadd;
  final bool isedit;
  final Expense? expense;
  const ExpenseScreen(
      {super.key,
      required this.tripId,
      required this.trip,
      required this.vehicleid,
      this.isadd = false,
      this.isedit = false,
      this.expense});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  DateTime selectedDate = DateTime.now();
  String selectedView = 'All';
  String selectedExpenseType = 'All';
  DateTime? customStartDate;
  DateTime? customEndDate;
  bool isbar = true;

  List<Expense> _filterExpenses(List<Expense> expenses) {
    final filteredByType = selectedExpenseType == 'All'
        ? expenses
        : expenses
            .where((e) =>
                e.category.toString().split('.').last == selectedExpenseType)
            .toList();

    DateTime startDate;
    DateTime endDate;

    switch (selectedView) {
      case 'Week':
        final weekday = selectedDate.weekday;
        startDate = selectedDate.subtract(Duration(days: weekday - 1));
        endDate = startDate.add(Duration(days: 6));
        break;
      case 'Month':
        startDate = DateTime(selectedDate.year, selectedDate.month, 1);
        endDate = DateTime(selectedDate.year, selectedDate.month + 1, 0);
        break;
      case 'Year':
        startDate = DateTime(selectedDate.year, 1, 1);
        endDate = DateTime(selectedDate.year, 12, 31);
        break;
      case 'Custom':
        if (customStartDate != null && customEndDate != null) {
          startDate = customStartDate!;
          endDate = customEndDate!;
        } else {
          return []; // if no range is selected yet
        }
        break;
      case 'All':
      default:
        return filteredByType;
    }

    return filteredByType
        .where((e) =>
            e.expenseDate.isAfter(startDate.subtract(Duration(days: 1))) &&
            e.expenseDate.isBefore(endDate.add(Duration(days: 1))))
        .toList();
  }

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
        return Colors.deepPurple;
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

  List<Expense> catf(List<Expense> expenses) {
    final filteredByType = selectedExpenseType == 'All'
        ? expenses
        : expenses
            .where((e) =>
                e.category.toString().split('.').last == selectedExpenseType)
            .toList();
    return filteredByType;
  }

  String formatWeekRange(DateTime selectedDate) {
    // Assuming week starts on Monday
    int weekday = selectedDate.weekday; // 1 (Mon) - 7 (Sun)

    DateTime startOfWeek = selectedDate.subtract(Duration(days: weekday - 1));
    DateTime endOfWeek = startOfWeek.add(Duration(days: 6));

    final formatter = DateFormat('dd MMM');

    return "${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}";
  }

  @override
  void initState() {
    super.initState();
    if (widget.isadd) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddEditModal(context);
      });
    }
    if (widget.isedit) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAddEditModal(context, widget.expense);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Expense",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () => {_showAddEditModal(context)},
              icon: Icon(
                Icons.add_circle,
                color: Colors.white,
              ))
        ],
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      Provider<IncomeService>(
                        create: (_) => IncomeService(),
                      ),
                      BlocProvider<IncomeCubit>(
                        create: (context) {
                          final service = context.read<IncomeService>();
                          final repo = IncomeRepository(service);
                          return IncomeCubit(repo)..fetchIncome(widget.tripId);
                        },
                      ),
                      Provider<ExpenseService>(
                        create: (_) => ExpenseService(),
                      ),
                      BlocProvider<ExpenseCubit>(
                        create: (context) {
                          final service = context.read<ExpenseService>();
                          final repo = ExpenseRepository(service);
                          return ExpenseCubit(repo)
                            ..fetchExpense(widget.tripId);
                        },
                      ),
                      Provider<TripProfitSummaryService>(
                        create: (_) => TripProfitSummaryService(),
                      ),
                      BlocProvider<TripProfitSummaryCubit>(
                        create: (context) {
                          final service =
                              context.read<TripProfitSummaryService>();
                          final repo = TripProfitSummaryRepository(service);
                          return TripProfitSummaryCubit(repo)
                            ..fetchTripProfitSummary(widget.tripId);
                        },
                      ),
                    ],
                    child: TripViewPage(
                        tripId: widget.tripId,
                        trip: widget.trip,
                        vehicleId: widget.vehicleid),
                  ),
                ),
              );
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
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
              // Filter bar UI
              final uniqueCategories = [
                'All',
                ...{
                  for (var e in state.expense)
                    e.category.toString().split('.').last
                }
              ];
              final filteredExpense = _filterExpenses(state.expense);
              final filteredExpenses = catf(filteredExpense);
              return Column(
                children: [
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Left arrow
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () {
                              setState(() {
                                if (selectedView == 'Week') {
                                  selectedDate =
                                      selectedDate.subtract(Duration(days: 7));
                                } else if (selectedView == 'Month') {
                                  selectedDate = DateTime(selectedDate.year,
                                      selectedDate.month - 1);
                                } else if (selectedView == 'Year') {
                                  selectedDate =
                                      DateTime(selectedDate.year - 1);
                                }
                              });
                            },
                          ),
                          Text(
                            selectedView == 'Week'
                                ? formatWeekRange(selectedDate)
                                : selectedView == 'Month'
                                    ? DateFormat('MMMM yyyy')
                                        .format(selectedDate)
                                    : selectedDate.year.toString(),
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () {
                              setState(() {
                                if (selectedView == 'Week') {
                                  selectedDate =
                                      selectedDate.add(Duration(days: 7));
                                } else if (selectedView == 'Month') {
                                  selectedDate = DateTime(selectedDate.year,
                                      selectedDate.month + 1);
                                } else if (selectedView == 'Year') {
                                  selectedDate =
                                      DateTime(selectedDate.year + 1);
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    visible: !isbar,
                  ),

                  // View type toggle
                  Row(
                    children:
                        ['All', 'Week', 'Month', 'Year', 'Custom'].map((view) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: TextButton(
                            onPressed: () async {
                              if (view == 'Custom' || view == "All") {
                                setState(() {
                                  isbar = true;
                                });
                              } else {
                                setState(() {
                                  isbar = false;
                                });
                              }
                              if (view == 'Custom') {
                                final picked = await showDateRangePicker(
                                  context: context,
                                  firstDate: DateTime(2000),
                                  lastDate: DateTime.now(),
                                  initialDateRange: customStartDate != null &&
                                          customEndDate != null
                                      ? DateTimeRange(
                                          start: customStartDate!,
                                          end: customEndDate!)
                                      : null,
                                );
                                if (picked != null) {
                                  setState(() {
                                    customStartDate = picked.start;
                                    customEndDate = picked.end;
                                    selectedView = 'Custom';
                                  });
                                }
                              } else {
                                setState(() {
                                  selectedView = view;
                                });
                              }
                            },
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  selectedView == view ? Colors.blue : null,
                              foregroundColor:
                                  selectedView == view ? Colors.white : null,
                            ),
                            child: Text(
                              view,
                              style: TextStyle(
                                  color: isdark ? Colors.white : Colors.black),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  // Expense Type Filter
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedExpenseType,
                      items: uniqueCategories
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (val) =>
                          {setState(() => selectedExpenseType = val!)},
                    ),
                  ),

                  // Expense List
                  Expanded(
                    child: filteredExpenses.isEmpty
                        ? Center(child: Text("No expenses found"))
                        : ListView.builder(
                            itemCount: filteredExpenses.length,
                            itemBuilder: (context, index) {
                              final expense = filteredExpenses[index];

                              return SingleChildScrollView(
                                scrollDirection: Axis.vertical,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 2.h, horizontal: 2.w),
                                  child: CustomCard(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: _getCategoryColor(expense
                                                .category
                                                .toString()
                                                .toUpperCase()), // Optional: Make dynamic if needed
                                            width: 8.w,
                                          ),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(5.r),
                                      ),
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
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          6.r),
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
                                                    value: _formatDate(
                                                        expense.expenseDate),
                                                    iconcolor: Colors.pink,
                                                  ),
                                                  if (expense
                                                      .description.isNotEmpty)
                                                    InfoCard(
                                                      icon: Icons.description,
                                                      value:
                                                          expense.description,
                                                      iconcolor:
                                                          Colors.indigoAccent,
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
                                                      _showAddEditModal(
                                                          context, expense),
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
                                                            .read<
                                                                ExpenseCubit>()
                                                            .deleteExpense(
                                                                expense,
                                                                expense.id!);
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
                          ),
                  )
                ],
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
