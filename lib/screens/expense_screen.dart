import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yaantrac_app/models/expense.dart';
import 'package:yaantrac_app/models/income.dart';
import 'package:yaantrac_app/trash/add_expense_screen.dart';
import 'package:yaantrac_app/trash/add_income_screen.dart';
import 'package:yaantrac_app/screens/trip_list_page.dart';
import 'package:yaantrac_app/services/api_service.dart';

import '../common/widgets/Toast/Toast.dart';
import '../common/widgets/button/action_button.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../models/trip.dart';
import '../models/trip_summary.dart';
import 'expense_list_screen.dart';

class TripViewPage extends StatefulWidget {
  final int tripId;
  final Trip trip;
  final int? index;
  final int vehicleId;
  const TripViewPage(
      {super.key,
      required this.tripId,
      required this.trip,
      this.index,
      required this.vehicleId});

  @override
  State<TripViewPage> createState() => _TripViewPageState();
}

class _TripViewPageState extends State<TripViewPage> {
  late Future<List<ExpenseModel>> futureExpenses;
  late Future<List<IncomeModel>> futureIncomes;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    getTripProfit();
    print(widget.tripId);
    futureExpenses = getExpenses();
    futureIncomes = getIncomes();
  }

  void _showAddEditExpenseModal({ExpenseModel? expense, required Trip trip}) {
    final _formKey = GlobalKey<FormState>();
    ExpenseCategory selectedExpenseType = ExpenseCategory.MISCELLANEOUS;

    late double _amount;
    late ExpenseCategory _category;
    late DateTime _expenseDate;
    late String _description;
    final TextEditingController _dateController = TextEditingController();
    late String cat;
    bool _isLoading = false;
    _amount = expense?.amount ?? 0.0;
    _category = expense?.category ?? ExpenseCategory.FUEL;
    _expenseDate = expense?.expenseDate ?? DateTime.now();
    _dateController.text = _formatDate(_expenseDate);
    _description = expense?.description ?? " ";
    selectedExpenseType = expense?.category ?? ExpenseCategory.FUEL;
    switch (_category.toString().split(".")[1]) {
      case "FUEL":
        cat = "Fuel Costs";
        break;
      case "DRIVER_ALLOWANCE":
        cat = "Driver Allowances";
        break;
      case "TOLL":
        cat = "Toll Charges";
        break;
      case "MAINTENANCE":
        cat = "Maintenance";
        break;
      default:
        cat = "Miscellaneous";
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add a new expense",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 25),
                          ),
                          const SizedBox(height: 10),
                          AppInputField(
                            label: "Expense Type",
                            isDropdown: true, hint: cat,
                            defaultValue: selectedExpenseType
                                .toString(), // Correct default value
                            dropdownItems: const [
                              DropdownMenuItem(
                                  value: "FUEL", child: Text("Fuel Costs")),
                              DropdownMenuItem(
                                  value: "DRIVER_ALLOWANCE",
                                  child: Text("Driver Allowances")),
                              DropdownMenuItem(
                                  value: "TOLL", child: Text("Toll Charges")),
                              DropdownMenuItem(
                                  value: "MAINTENANCE",
                                  child: Text("Maintenance")),
                              DropdownMenuItem(
                                  value: "MISCELLANEOUS",
                                  child: Text("Miscellaneous")),
                            ],
                            onDropdownChanged: (value) {
                              //print(value);
                              setState(() {
                                selectedExpenseType =
                                    ExpenseCategory.values.firstWhere(
                                  (e) => e.name == value,
                                  orElse: () => ExpenseCategory.MISCELLANEOUS,
                                );
                                print(
                                    "Selected Expense Type: $selectedExpenseType");
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Amount",
                            hint: "Enter Amount",
                            defaultValue: _amount.toString(),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onInputChanged: (value) {
                              setState(() {
                                _amount = double.parse(value!);
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Date",
                            isDatePicker: true,
                            controller: _dateController, // Show only date
                            onDateSelected: (date) {
                              setState(() {
                                _expenseDate = date;
                                _dateController.text =
                                    _formatDate(date); // Update text in field
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Description",
                            hint: "Enter Description",
                            defaultValue: _description,
                            keyboardType: TextInputType.multiline,
                            onInputChanged: (value) {
                              setState(() {
                                _description = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  children: [
                                    Expanded(
                                        child: AppPrimaryButton(
                                            onPressed: () {},
                                            title: "Attach Receipt")),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: AppPrimaryButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                //print("Submitted Expense Data: ${expense}");
                                                setState(() {
                                                  _isLoading =
                                                      true; // Disable button & show loader
                                                });
                                                var f = {
                                                  "id": expense?.id,
                                                  "tripId": widget.tripId,
                                                  "amount": _amount,
                                                  "category":
                                                      selectedExpenseType
                                                          .toString()
                                                          .split('.')[1],
                                                  "expenseDate": _expenseDate
                                                      .toIso8601String(),
                                                  "description": _description,
                                                  "attachmentUrl": "",
                                                  "createdAt": DateTime.now()
                                                      .toIso8601String(),
                                                  "updatedAt": DateTime.now()
                                                      .toIso8601String()
                                                };
                                                try {
                                                  final response = await APIService
                                                      .instance
                                                      .request(
                                                          expense == null
                                                              ? "https://yaantrac-backend.onrender.com/api/expenses/${widget.tripId}"
                                                              : "https://yaantrac-backend.onrender.com/api/expenses/${expense.id}",
                                                          expense == null
                                                              ? DioMethod.post
                                                              : DioMethod.put,
                                                          formData: f,
                                                          contentType:
                                                              "application/json");
                                                  if (response.statusCode ==
                                                      200) {
                                                    ToastHelper.showCustomToast(
                                                        context,
                                                        (expense == null)
                                                            ? "Expense Added Sucessfully"
                                                            : "Expense Updated Sucessfully",
                                                        Colors.green,
                                                        expense == null
                                                            ? Icons.add
                                                            : Icons.edit);

                                                    _formKey.currentState
                                                        ?.reset();
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TripViewPage(
                                                                          tripId:
                                                                              widget.tripId,
                                                                          trip:
                                                                              trip,
                                                                          index:
                                                                              1,
                                                                          vehicleId:
                                                                              widget.vehicleId,
                                                                        )),
                                                            (route) => false);
                                                  } else {
                                                    print(
                                                        response.statusMessage);
                                                  }
                                                } catch (e) {
                                                  throw Exception(
                                                      "Error Posting Income: $e");
                                                } finally {
                                                  ToastHelper.showCustomToast(
                                                      context,
                                                      "Network error! Please try again.",
                                                      Colors.red,
                                                      Icons.error);
                                                  setState(() {
                                                    _isLoading =
                                                        false; // Re-enable button after request
                                                  });
                                                }
                                              }
                                            },
                                            title: expense == null
                                                ? "Add"
                                                : "Update")),
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
      },
    );
  }

  void _showAddEditIncomeModal({
    IncomeModel? income,
  }) {
    final _formKey = GlobalKey<FormState>();
    bool isLoading = false;
    late double _amount;
    late DateTime _incomeDate;
    late String _description;
    final TextEditingController _dateController = TextEditingController();
    _amount = income?.amount ?? 0.0;
    _incomeDate = income?.incomeDate ?? DateTime.now();
    _dateController.text =
        "$_incomeDate.toLocal()}".split(' ')[0]; // Format the date
    _description = income?.description ?? "";
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 16,
                right: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Add a new income",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 25),
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Amount",
                            hint: "Enter Amount",
                            keyboardType: TextInputType.number,
                            defaultValue: _amount.toString(),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            onInputChanged: (value) {
                              setState(() {
                                _amount = double.parse(value!);
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Date",
                            isDatePicker: true,
                            controller:
                                _dateController, // Use the controller instead of defaultValue
                            onDateSelected: (date) {
                              setState(() {
                                _incomeDate = date;
                                _dateController.text =
                                    _formatDate(date); // Update text in field
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          AppInputField(
                            label: "Description",
                            hint: "Enter Description",
                            keyboardType: TextInputType.multiline,
                            defaultValue: _description.toString(),
                            onInputChanged: (value) {
                              setState(() {
                                _description = value!;
                              });
                            },
                          ),
                          const SizedBox(height: 5),
                          isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Row(
                                  children: [
                                    Expanded(
                                        child: AppPrimaryButton(
                                            onPressed: () {},
                                            title: "Attach Receipt")),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: AppPrimaryButton(
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                setState(() {
                                                  isLoading =
                                                      true; // Disable button & show loader
                                                });
                                                IncomeModel inc = IncomeModel(
                                                  id: income?.id,
                                                  amount: _amount,
                                                  incomeDate: _incomeDate,
                                                  tripId: widget.tripId,
                                                  description: _description,
                                                  createdAt: DateTime.now(),
                                                  updatedAt: DateTime.now(),
                                                );
                                                print(inc.toJson());
                                                try {
                                                  final response =
                                                      await APIService.instance
                                                          .request(
                                                    income == null
                                                        ? "https://yaantrac-backend.onrender.com/api/income/${widget.tripId}"
                                                        : "https://yaantrac-backend.onrender.com/api/income/${income.id}",
                                                    income == null
                                                        ? DioMethod.post
                                                        : DioMethod.put,
                                                    formData: inc.toJson(),
                                                    contentType:
                                                        "application/json",
                                                  );
                                                  if (response.statusCode ==
                                                      200) {
                                                    ToastHelper.showCustomToast(
                                                        context,
                                                        income == null
                                                            ? "Income added successfully!"
                                                            : "Income updated successfully!",
                                                        Colors.green,
                                                        income == null
                                                            ? Icons.add
                                                            : Icons.edit);
                                                    _formKey.currentState
                                                        ?.reset();
                                                    Navigator.of(context)
                                                        .pushAndRemoveUntil(
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        TripViewPage(
                                                                          tripId:
                                                                              widget.tripId,
                                                                          trip:
                                                                              widget.trip,
                                                                          index:
                                                                              2,
                                                                          vehicleId:
                                                                              widget.vehicleId,
                                                                        )),
                                                            (route) => false);
                                                  } else {
                                                    print(
                                                        response.statusMessage);
                                                  }
                                                } catch (e) {
                                                  throw Exception(
                                                      "Error Posting Income: $e");
                                                } finally {
                                                  ToastHelper.showCustomToast(
                                                      context,
                                                      "Network error! Please try again.",
                                                      Colors.red,
                                                      Icons.error);
                                                  setState(() {
                                                    isLoading =
                                                        false; // Re-enable button after request
                                                  });
                                                }
                                              }
                                            },
                                            title: income?.id == null
                                                ? "Add"
                                                : "Update")),
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
      },
    );
  }

  Future<List<ExpenseModel>> getExpenses() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/expenses/trip/${widget.tripId}",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> expenseList = response.data['data'];
        return expenseList.map((json) => ExpenseModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching expenses: $e");
    }
  }

  Future<List<IncomeModel>> getIncomes() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/income/?tripId=${widget.tripId}",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> incomeList = response.data['data'];
        return incomeList.map((json) => IncomeModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching incomes: $e");
    }
  }

  Future<TripProfitSummaryModel> getTripProfit() async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips/summary?tripId=${widget.tripId}",
          DioMethod.get,
          contentType: "application/json");
      if (response.statusCode == 200) {
        Map<String, dynamic> tripProfit = response.data['data'];
        return TripProfitSummaryModel.fromJson(tripProfit);
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (err) {
      throw Exception("Error fetching summary: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: widget.index ?? 0,
      length: 3, // Three sections: Trip Details, Expenses, Income
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Trip Overview"),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TripListScreen(
                          vehicleid: widget.vehicleId ??
                              0))); // Go back to the previous page
            },
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Trip View"),
              Tab(text: "Expenses"),
              Tab(text: "Income"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTripDetails(
                context, widget.trip), // First tab for trip details
            _buildExpenseTab(), // Second tab for expenses
            _buildIncomeTab(), // Third tab for income
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Column(
      children: List.generate(7, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.white,
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(10)),
            ),
          ),
        );
      }),
    );
  }

  // Trip Details Section
  Widget _buildTripDetails(BuildContext context, Trip trip) {
    final theme = Theme.of(context);
    Future<TripProfitSummaryModel> tripProfitSummary = getTripProfit();

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: FutureBuilder<TripProfitSummaryModel>(
        future: tripProfitSummary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerEffect();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No report available"));
          } else {
            final tripProfitSummary = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  elevation: 4, // Adds a subtle shadow for depth
                  margin: const EdgeInsets.all(20),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Trip Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const Divider(thickness: 1, height: 20),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.blueAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Source: ${trip.source}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.redAccent),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Destination: ${trip.destination}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.green),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Start Date: ${_formatDate(trip.startDate)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            const Icon(Icons.event, color: Colors.orange),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'End Date: ${_formatDate(trip.endDate)}',
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SummaryCard(
                        title: 'TOTAL EXPENSES',
                        amount: '\$${tripProfitSummary.totalExpenses}',
                        theme: theme),
                    SummaryCard(
                        title: 'TOTAL INCOME',
                        amount: '\$${tripProfitSummary.totalIncome}',
                        theme: theme),
                    SummaryCard(
                        title: 'PROFIT',
                        amount: '\$${tripProfitSummary.profit}',
                        theme: theme),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 4,
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Expense Breakdown",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          ExpenseTable(breakDown: tripProfitSummary.breakDown),
                        ],
                      )),
                ),
                const SizedBox(height: 30),
                Card(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Expense Distribution",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.all(4),
                        child: BreakdownDonutChart(breakdown: {
                          "FUEL":
                              tripProfitSummary.breakDown["FUEL"]?.toDouble() ??
                                  0.0,
                          "DRIVER_ALLOWANCE": tripProfitSummary
                                  .breakDown["DRIVER_ALLOWANCE"]
                                  ?.toDouble() ??
                              0.0,
                          "TOLL":
                              tripProfitSummary.breakDown["TOLL"]?.toDouble() ??
                                  0.0,
                          "MAINTENANCE": tripProfitSummary
                                  .breakDown["MAINTENANCE"]
                                  ?.toDouble() ??
                              0.0,
                          "MISCELLANEOUS": tripProfitSummary
                                  .breakDown["MISCELLANEOUS"]
                                  ?.toDouble() ??
                              0.0,
                        }),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 30),
              ],
            );
          }
        },
      ),
    );
  }

  // Expenses Section
  Widget _buildExpenseTab() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<ExpenseModel>>(
            future: futureExpenses,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No expenses available"));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child:
                          _buildExpenseListItem(expense: snapshot.data![index]),
                    );
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              _showAddEditExpenseModal(trip: widget.trip);
            },
            child: const Text("Add Expense"),
          ),
        ),
      ],
    );
  }

  // Income Section
  Widget _buildIncomeTab() {
    return Column(
      children: [
        Expanded(
          child: FutureBuilder<List<IncomeModel>>(
            future: futureIncomes,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text("Error: ${snapshot.error}"));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text("No incomes available"));
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      child:
                          _buildIncomeListItem(income: snapshot.data![index]),
                    );
                  },
                );
              }
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () {
              _showAddEditIncomeModal();
            },
            child: const Text("Add Income"),
          ),
        ),
      ],
    );
  }

  Widget _buildExpenseListItem({required ExpenseModel expense}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.receipt_long, size: 48, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category.toString().split('.').last,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Amount: ₹${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Date: ${_formatDate(expense.expenseDate)}',
                    style: const TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Description: ${expense.description}',
                    style: const TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                ActionButton(
                    icon: Icons.edit,
                    color: Colors.green,
                    onPressed: () {
                      _showAddEditExpenseModal(
                          expense: expense, trip: widget.trip);
                    }),
                SizedBox(width: 10),
                ActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      _confirmDeleteexpense(expense.id!.toInt());
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeListItem({required IncomeModel income}) {
    return _buildListItem(
      income: income,
      title: "Income",
      amount: income.amount,
      date: income.incomeDate,
      description: income.description,
    );
  }

  Widget _buildListItem(
      {required IncomeModel income,
      required String title,
      required double amount,
      required DateTime date,
      required String description}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Amount: ₹${amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 14, color: Colors.green[700]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Date: ${_formatDate(income.incomeDate)}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Description: $description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Row(
              children: [
                ActionButton(
                    icon: Icons.edit,
                    color: Colors.green,
                    onPressed: () {
                      _showAddEditIncomeModal(income: income);
                    }),
                const SizedBox(width: 8),
                ActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      _confirmDeleteincome(income.id!.toInt());
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDeleteexpense(int expenseId) async {
    bool isDeleting = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Deleting Trip... Please wait",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this expense? This action cannot be undone.",
                      style: TextStyle(fontSize: 15)),
              actions: isDeleting
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDeleteexpense(expenseId);
                        },
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<void> _onDeleteexpense(int expenseId) async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/expenses/$expenseId",
        DioMethod.delete,
        contentType: "application/json",
      );
      if (response.statusCode == 204) {
        setState(() {
          futureExpenses = getExpenses();
        });
        ToastHelper.showCustomToast(
            context, "Expense deleted successfully!", Colors.red, Icons.delete);

        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => TripViewPage(
                      tripId: widget.tripId,
                      trip: widget.trip,
                      vehicleId: widget.vehicleId,
                    )),
            (route) => false);
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> _confirmDeleteincome(int incomeId) async {
    bool isDeleting = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28),
                  SizedBox(width: 8),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10),
                        Text("Deleting Trip... Please wait",
                            style: TextStyle(fontSize: 14, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this income? This action cannot be undone.",
                      style: TextStyle(fontSize: 15)),
              actions: isDeleting
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Cancel",
                            style: TextStyle(color: Colors.grey)),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDeleteincome(incomeId);
                        },
                        child: Text("Delete",
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<void> _onDeleteincome(int incomeId) async {
    try {
      print("Deleting income with ID: $incomeId");

      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/income/$incomeId",
        DioMethod.delete,
        contentType: "application/json",
      );

      print("Response Status Code: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Refresh incomes list

        setState(() {
          futureIncomes = getIncomes();
        });
        ToastHelper.showCustomToast(
            context, "Income deleted successfully!", Colors.red, Icons.delete);

        // Navigate to TripViewPage and replace the current screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TripViewPage(
              tripId: widget.tripId,
              trip: widget.trip,
              vehicleId: widget.vehicleId,
            ),
          ),
        );
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final ThemeData theme;

  const SummaryCard(
      {super.key,
      required this.title,
      required this.amount,
      required this.theme});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Increased for a softer look
      ),
      color:
          theme.brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
      elevation: 5, // Adds a shadow for depth
      shadowColor: Colors.black26, // Softer shadow effect
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        height: 90, // Slightly increased for better spacing
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14, // Increased for better readability
                fontWeight: FontWeight.bold, // Stronger emphasis
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              amount,
              style: TextStyle(
                fontSize: 14, // Slightly larger for better visibility
                fontWeight: FontWeight.w600,
                color: theme.brightness == Brightness.dark
                    ? Colors.blueAccent
                    : Colors.deepPurple, // A pop of color
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ExpenseTable extends StatelessWidget {
  final Map<String, dynamic> breakDown;

  ExpenseTable({required this.breakDown});

  @override
  Widget build(BuildContext context) {
    double total = breakDown.values.fold(0, (sum, value) => sum + value);

    return DataTable(
      columnSpacing: 20.0,
      columns: [
        DataColumn(
            label: Text('Category',
                style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label:
                Text('Amount', style: TextStyle(fontWeight: FontWeight.bold))),
        DataColumn(
            label: Text('Percentage',
                style: TextStyle(fontWeight: FontWeight.bold))),
      ],
      rows: [
        ...breakDown.entries.map((entry) {
          double percentage = total > 0 ? (entry.value / total) * 100 : 0;
          return DataRow(cells: [
            DataCell(Text(entry.key.replaceAll('_', ' '))), // Formatting names
            DataCell(Text('\$${entry.value.toStringAsFixed(2)}')),
            DataCell(Text('${percentage.toStringAsFixed(2)}%')),
          ]);
        }).toList(),
        // Adding the Total row
        DataRow(
          cells: [
            DataCell(Text(
              'TOTAL',
            )),
            DataCell(Text('\$${total.toStringAsFixed(2)}')),
            DataCell(Text(
              '100%',
            )),
          ], // Optional: Background color for the total row
        ),
      ],
    );
  }
}

class BreakdownDonutChart extends StatelessWidget {
  final Map<String, double> breakdown;

  const BreakdownDonutChart({super.key, required this.breakdown});

  Color _getColor(String category) {
    final colors = {
      "FUEL": Colors.blueAccent,
      "DRIVER_ALLOWANCE": Colors.green,
      "TOLL": Colors.orange,
      "MAINTENANCE": Colors.redAccent,
      "MISCELLANEOUS": Colors.purple,
    };
    return colors[category] ?? Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 175, // Adjust width for responsiveness
          height: 200,
          padding: EdgeInsets.all(16),
          child: PieChart(
            PieChartData(
              sections: breakdown.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  color: _getColor(entry.key),
                  radius: 45, // Adjusts segment size
                  showTitle: false, // Removes text inside pie chart
                );
              }).toList(),
              sectionsSpace: 2,
              centerSpaceRadius: 30,
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: breakdown.entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: _getColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    entry.key.toUpperCase(),
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  CustomPaint(
                    painter: ArrowPainter(),
                    child: const SizedBox(width: 13),
                  ),
                  Text(
                    entry.value.toInt().toString(), // Displays value
                    style: const TextStyle(
                        fontSize: 8, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// 🎯 Custom Painter for Drawing Arrows
class ArrowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(0, size.height / 2);
    path.lineTo(size.width - 5, size.height / 2);
    path.lineTo(size.width - 8, size.height / 2 - 3);
    path.moveTo(size.width - 5, size.height / 2);
    path.lineTo(size.width - 8, size.height / 2 + 3);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
