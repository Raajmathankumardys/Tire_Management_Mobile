import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/Expense_Tracker/Income/presentation/screen/income_screen.dart';

import '../helpers/components/shimmer.dart';
import 'Expense/cubit/expense_cubit.dart';
import 'Expense/cubit/expense_state.dart';
import 'Expense/presentation/screen/expense_screen.dart';
import 'Expense/repository/expense_repository.dart';
import 'Expense/service/expense_service.dart';
import 'Income/cubit/income_cubit.dart';
import 'Income/cubit/income_state.dart';
import 'Income/repository/income_repository.dart';
import 'Income/service/income_service.dart';
import 'Trips/cubit/trips_state.dart';

class TransactionScreen extends StatefulWidget {
  final int tripId;
  final int vehicleid;
  final Trip trip;
  final bool isadd;
  const TransactionScreen(
      {super.key,
      required this.tripId,
      required this.trip,
      required this.vehicleid,
      this.isadd = false});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  List<Income> incomelist = [];
  List<Expense> expenselist = [];
  double expenseamount = 0.0;
  double incomeamount = 0.0;
  bool isload = true;
  void addpopup() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Center(
          child: Text("Add Transaction"),
        ),
        content: const Text("What type of transaction would you like to add?"),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
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
                              return IncomeCubit(repo)
                                ..fetchIncome(widget.tripId);
                            },
                          ),
                        ],
                        child: IncomeScreen(
                          tripId: widget.tripId,
                          trip: widget.trip,
                          vehicleid: widget.vehicleid,
                          isadd: true,
                        )),
                  ));
            },
            child: const Text(
              "Income",
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.blueAccent),
            onPressed: () {
              Navigator.pop(context); // Close the dialog
              // Navigate or open expense form
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                        providers: [
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
                        ],
                        child: ExpenseScreen(
                          tripId: widget.tripId,
                          trip: widget.trip,
                          vehicleid: widget.vehicleid,
                          isadd: true,
                        )),
                  ));
            },
            child: const Text(
              "Expense",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void _waitForIncome() async {
    setState(() {
      isload = true;
    });
    while (true) {
      final state = context.read<IncomeCubit>().state;
      if (state is IncomeLoaded) {
        setState(() {
          incomelist = state.income;
          var a = 0.0;
          incomelist.forEach((i) => a += i.amount);
          incomeamount = a;
        });
        break;
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
    _waitForExpense();
    setState(() {
      isload = false;
    });
  }

  void _waitForExpense() async {
    while (true) {
      final state = context.read<ExpenseCubit>().state;
      if (state is ExpenseLoaded) {
        setState(() {
          expenselist = state.expense;
          var a = 0.0;
          expenselist.forEach((i) => a += i.amount);
          expenseamount = a;
        });
        break;
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _waitForIncome();
  }

  String _formatDate(DateTime date) {
    final formatter = DateFormat('dd MMM yyyy');
    return formatter.format(date).toUpperCase();
  }

  StatelessWidget geticon(String cat) {
    if (cat == "FUEL") {
      return FaIcon(
        FontAwesomeIcons.gasPump,
        color: Colors.white,
      );
    } else if (cat == "TOLL") {
      return FaIcon(
        FontAwesomeIcons.road,
        color: Colors.white,
      );
    } else if (cat == "DRIVER_ALLOWANCE") {
      return FaIcon(
        FontAwesomeIcons.idCard,
        color: Colors.white,
      );
    } else if (cat == "MAINTENANCE") {
      return FaIcon(
        FontAwesomeIcons.tools,
        color: Colors.white,
      );
    } else {
      return FaIcon(
        FontAwesomeIcons.sackDollar,
        color: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text(
      //     "Transaction",
      //     style: TextStyle(color: Colors.white),
      //   ),
      //   centerTitle: true,
      //   backgroundColor: Colors.blueAccent,
      // ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
          onPressed: addpopup,
          backgroundColor: Colors.blueAccent,
          child: Icon(
            Icons.add_circle,
            color: Colors.white,
          ),
        ),
      ),
      body: RefreshIndicator(
        child: isload
            ? shimmer()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _indicatorCard(Icons.arrow_upward, "Expense",
                              expenseamount.toString(), Colors.red),
                          _indicatorCard(Icons.arrow_downward, "Income",
                              incomeamount.toString(), Colors.green),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Balance Display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 6, horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                            ((incomeamount - expenseamount) < 0
                                    ? "Loss"
                                    : "Profit") +
                                ": \₹${incomeamount - expenseamount}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 20),

                      // Recent Transactions Title
                      Text("Transactions",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 10),

                      (incomelist.isEmpty && expenselist.isEmpty)
                          ? const Center(
                              child: Text(
                                'No Transactions Yet',
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            )
                          : Column(
                              children: [
                                // Income transactions
                                Column(
                                  children: incomelist
                                      .map((i) => _transactionTile(
                                          amount: i.amount.toString(),
                                          isdark: isdark,
                                          date: _formatDate(i.incomeDate),
                                          description: i.description,
                                          isIncome: true,
                                          income: i))
                                      .toList(),
                                ),

                                const SizedBox(height: 8),

                                // Expense transactions
                                Column(
                                  children: expenselist
                                      .map((i) => _transactionTile(
                                          amount: i.amount.toString(),
                                          isdark: isdark,
                                          date: _formatDate(i.expenseDate),
                                          description: i.description,
                                          type: i.category
                                              .toString()
                                              .split('.')
                                              .last,
                                          isIncome: false,
                                          expense: i))
                                      .toList(),
                                ),
                              ],
                            ),

                      const SizedBox(height: 30),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text("Stats",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isdark ? Colors.grey.shade900 : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _statRow(
                                "Number of transactions",
                                (incomelist.length + expenselist.length)
                                    .toString()),
                            const SizedBox(height: 16),
                            const Text("Average Expense",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            // _statSubRow("Per day", "₹8.8"),
                            // _statSubRow("Per week", "₹100.0"),
                            // _statSubRow("Per month", "₹110.0"),
                            // _statSubRow("Per year", "₹110.0"),
                            _statSubRow(
                                "Per transaction",
                                (expenseamount / expenselist.length)
                                    .toStringAsFixed(2)),
                            const SizedBox(height: 16),
                            const Text("Average income",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            // const SizedBox(height: 6),
                            // _statSubRow("Per day", "₹4.0"),
                            // _statSubRow(
                            //     "Per week", (incomeamount / 7).toStringAsFixed(2)),
                            // _statSubRow("Per month", "₹110.0"),
                            // _statSubRow(
                            //     "Per year", (incomeamount / 12).toStringAsFixed(2)),
                            _statSubRow(
                                "Per transaction",
                                (incomeamount / incomelist.length)
                                    .toStringAsFixed(2)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40.h,
                      )
                    ],
                  ),
                ),
              ),
        onRefresh: () async => {
          setState(() {
            isload = true;
          }),
          _waitForIncome(),
          setState(() {
            isload = false;
          })
        },
        color: Colors.blueAccent,
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        Text(value,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _statSubRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _indicatorCard(
      IconData icon, String label, String amount, Color color) {
    return GestureDetector(
      onTap: () => {
        if (label == "Expense")
          {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                      providers: [
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
                      ],
                      child: ExpenseScreen(
                        tripId: widget.tripId,
                        trip: widget.trip,
                        vehicleid: widget.vehicleid,
                      )),
                ))
          }
        else
          {
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
                            return IncomeCubit(repo)
                              ..fetchIncome(widget.tripId);
                          },
                        ),
                      ],
                      child: IncomeScreen(
                        tripId: widget.tripId,
                        trip: widget.trip,
                        vehicleid: widget.vehicleid,
                      )),
                ))
          }
      },
      child: Container(
        width: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 14)),
                Text('\₹$amount',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _transactionTile(
      {required String amount,
      required bool isdark,
      required String date,
      required String description,
      String? type,
      required bool isIncome,
      Expense? expense,
      Income? income}) {
    return GestureDetector(
      onTap: () {
        if (isIncome) {
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
                    ],
                    child: IncomeScreen(
                      tripId: widget.tripId,
                      trip: widget.trip,
                      vehicleid: widget.vehicleid,
                      isedit: true,
                      income: income,
                    )),
              ));
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                    providers: [
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
                    ],
                    child: ExpenseScreen(
                      tripId: widget.tripId,
                      trip: widget.trip,
                      vehicleid: widget.vehicleid,
                      isedit: true,
                      expense: expense,
                    )),
              ));
        }
      },
      child: Padding(
        padding: EdgeInsets.all(4.h),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isdark ? Colors.grey.shade900 : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                blurRadius: 2,
                color:
                    isIncome ? Colors.green.withOpacity(0.8) : Colors.black12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 25.r,
                child: isIncome
                    ? Icon(Icons.currency_exchange, color: Colors.white)
                    : geticon(type!),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('\₹$amount',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Visibility(
                      child: Text(type ?? "",
                          style: TextStyle(color: Colors.grey)),
                      visible: !isIncome,
                    ),
                    Text(description, style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(date, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 4),
                  const Icon(Icons.money_rounded, color: Colors.green),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
