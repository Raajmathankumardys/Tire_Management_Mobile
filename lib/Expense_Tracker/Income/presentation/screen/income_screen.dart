import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../../../Trip-Profit-Summary/presentation/screen/trip_overview_screen.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../Expense/cubit/expense_cubit.dart';
import '../../../Expense/repository/expense_repository.dart';
import '../../../Expense/service/expense_service.dart';
import '../../../Trip-Profit-Summary/cubit/trip_profit_summary_cubit.dart';
import '../../../Trip-Profit-Summary/repository/trip_profit_summary_repository.dart';
import '../../../Trip-Profit-Summary/service/trip_profit_summary_service.dart';
import '../../../Trips/cubit/trips_state.dart';
import '../../cubit/income_cubit.dart';
import '../../cubit/income_state.dart';
import '../../repository/income_repository.dart';
import '../../service/income_service.dart';
import 'add_edit_income.dart';
import 'package:intl/intl.dart';

enum ViewType { All, Week, Month, Year, Custom }

class IncomeScreen extends StatefulWidget {
  final int tripId;
  final int vehicleid;
  final Trip trip;
  final bool isadd;
  final bool isedit;
  final Income? income;
  const IncomeScreen(
      {super.key,
      required this.tripId,
      required this.trip,
      required this.vehicleid,
      this.isadd = false,
      this.isedit = false,
      this.income});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  List<Income> _allIncome = [];
  List<Income> _filteredIncome = [];
  ViewType _currentView = ViewType.All;
  DateTime _selectedDate = DateTime.now();
  DateTimeRange? _customRange;

  void _applyFilter(ViewType view) {
    DateTime now = _selectedDate;
    List<Income> filtered = [];

    switch (view) {
      case ViewType.Week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        filtered = _allIncome
            .where((e) =>
                e.incomeDate.isAfter(startOfWeek.subtract(Duration(days: 1))) &&
                e.incomeDate.isBefore(endOfWeek.add(Duration(days: 1))))
            .toList();
        break;
      case ViewType.Month:
        filtered = _allIncome
            .where((e) =>
                e.incomeDate.month == now.month &&
                e.incomeDate.year == now.year)
            .toList();
        break;
      case ViewType.Year:
        filtered =
            _allIncome.where((e) => e.incomeDate.year == now.year).toList();
        break;
      case ViewType.Custom:
        if (_customRange != null) {
          filtered = _allIncome
              .where((e) =>
                  e.incomeDate.isAfter(
                      _customRange!.start.subtract(Duration(days: 1))) &&
                  e.incomeDate
                      .isBefore(_customRange!.end.add(Duration(days: 1))))
              .toList();
        }
        break;
      case ViewType.All:
        filtered = List.from(_allIncome);
        break;
    }

    setState(() {
      _filteredIncome = filtered;
      _currentView = view;
    });
  }

  void _changePeriod(bool forward) {
    setState(() {
      switch (_currentView) {
        case ViewType.Week:
          _selectedDate = _selectedDate.add(Duration(days: forward ? 7 : -7));
          break;
        case ViewType.Month:
          _selectedDate = DateTime(
              _selectedDate.year, _selectedDate.month + (forward ? 1 : -1));
          break;
        case ViewType.Year:
          _selectedDate = DateTime(_selectedDate.year + (forward ? 1 : -1));
          break;
        default:
          break;
      }
    });
    _applyFilter(_currentView);
  }

  String _displaySelectedPeriod() {
    switch (_currentView) {
      case ViewType.Week:
        final startOfWeek =
            _selectedDate.subtract(Duration(days: _selectedDate.weekday - 1));
        final endOfWeek = startOfWeek.add(Duration(days: 6));
        final formatter =
            DateFormat("dd MMM"); // accidentally shows month name!
        return "${formatter.format(startOfWeek)} - ${formatter.format(endOfWeek)}";

      case ViewType.Month:
        final formatter =
            DateFormat("MMMM yyyy"); // oops again, full month name
        return formatter.format(_selectedDate);

      case ViewType.Year:
        return "${_selectedDate.year}";

      default:
        return '';
    }
  }

// This should be placed somewhere in your class or globally if you're brave

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> _selectCustomRange() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
    );
    if (range != null) {
      setState(() {
        _customRange = range;
        _currentView = ViewType.Custom;
      });
      _applyFilter(ViewType.Custom);
    }
  }

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
        _showAddEditModal(context, widget.income);
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
          incomeconstants.appbar,
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
        color: Colors.blueAccent,
        onRefresh: () async =>
            context.read<IncomeCubit>().fetchIncome(widget.tripId),
        child: BlocConsumer<IncomeCubit, IncomeState>(
          listener: (context, state) {
            if (state is AddedIncomeState ||
                state is UpdatedIncomeState ||
                state is DeletedIncomeState) {
              ToastHelper.showCustomToast(
                  context,
                  (state as dynamic).message,
                  Colors.green,
                  state is AddedIncomeState
                      ? Icons.add
                      : state is UpdatedIncomeState
                          ? Icons.edit
                          : Icons.delete);
            } else if (state is IncomeError) {
              ToastHelper.showCustomToast(
                  context, state.message, Colors.red, Icons.error);
            }
          },
          builder: (context, state) {
            if (state is IncomeLoading) {
              return shimmer(count: 7);
            } else if (state is IncomeLoaded) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_allIncome != state.income) {
                  _allIncome = state.income;
                  _applyFilter(_currentView);
                }
              });

              return Column(
                children: [
                  SizedBox(height: 8.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                color: Colors
                                    .blueAccent), // totally invisible border!
                          ),
                          onPressed: () => _applyFilter(ViewType.All),
                          child: Text(
                            incomeconstants.all,
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                color: Colors
                                    .blueAccent), // totally invisible border!
                          ),
                          onPressed: () => _applyFilter(ViewType.Week),
                          child: Text(
                            incomeconstants.week,
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                color: Colors
                                    .blueAccent), // totally invisible border!
                          ),
                          onPressed: () => _applyFilter(ViewType.Month),
                          child: Text(
                            incomeconstants.month,
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(color: Colors.blueAccent),
                          ),
                          onPressed: () => _applyFilter(ViewType.Year),
                          child: Text(
                            incomeconstants.year,
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            side: BorderSide(
                                color: Colors
                                    .blueAccent), // totally invisible border!
                          ),
                          onPressed: _selectCustomRange,
                          child: Text(
                            incomeconstants.custom,
                            style: TextStyle(
                                color: isdark ? Colors.white : Colors.black),
                          )),
                    ],
                  ),
                  if (_currentView != ViewType.All &&
                      _currentView != ViewType.Custom)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_left),
                            onPressed: () => _changePeriod(false),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              _displaySelectedPeriod(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.arrow_right),
                            onPressed: () => _changePeriod(true),
                          ),
                        ],
                      ),
                    ),
                  Expanded(
                    child: _filteredIncome.isEmpty
                        ? Center(child: Text(incomeconstants.noincome))
                        : ListView.builder(
                            itemCount: _filteredIncome.length,
                            itemBuilder: (context, index) {
                              final income = _filteredIncome[index];
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 3.h, horizontal: 6.w),
                                child: CustomCard(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r)),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border(
                                          left: BorderSide(
                                              color: Colors.green, width: 5.w)),
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(12.h),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(children: [
                                                  Text(incomeconstants.rupees,
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  SizedBox(width: 5.w),
                                                  Text(income.amount.toString())
                                                ]),
                                                // Row(children: [
                                                //   Text("Income Date",
                                                //       style: TextStyle(
                                                //           fontWeight:
                                                //               FontWeight.bold)),
                                                //   SizedBox(width: 5.w),
                                                //   Text(_formatDate(
                                                //       income.incomeDate))
                                                // ]),
                                                if (income.description
                                                    .trim()
                                                    .isNotEmpty)
                                                  Row(children: [
                                                    Icon(
                                                      Icons.file_copy,
                                                      size: 12.h,
                                                    ),
                                                    SizedBox(
                                                      width: 5.w,
                                                    ),
                                                    Text(income.description)
                                                  ]),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.date_range,
                                                size: 12.h,
                                              ),
                                              SizedBox(
                                                width: 5.w,
                                              ),
                                              Text(
                                                  _formatDate(
                                                      income.incomeDate),
                                                  style: const TextStyle(
                                                      color: Colors.grey)),
                                              SizedBox(width: 5.w)
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              ActionButton(
                                                  icon: Icons.edit,
                                                  color: Colors.green,
                                                  onPressed: () =>
                                                      _showAddEditModal(
                                                          context, income)),
                                              SizedBox(width: 4.w),
                                              ActionButton(
                                                icon: Icons.delete_outline,
                                                color: Colors.red,
                                                onPressed: () async {
                                                  await showDeleteConfirmationDialog(
                                                    context: context,
                                                    content: incomeconstants
                                                        .deletemodal,
                                                    onConfirm: () => context
                                                        .read<IncomeCubit>()
                                                        .deleteIncome(
                                                            income, income.id!),
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
                              );
                            },
                          ),
                  ),
                ],
              );
            }
            return Center(child: Text(incomeconstants.noincome));
          },
        ),
      ),
    );
  }
}
