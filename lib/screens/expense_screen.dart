import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
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
import '../trash/expense_list_screen.dart';

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

  void _showAddEditExpenseModal({ExpenseModel? expense}) {
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
        return DraggableScrollableSheet(
            initialChildSize: 0.3.h, // Starts at of screen height
            minChildSize: 0.2.h, // Minimum height
            maxChildSize: 0.40.h,
            expand: false,
            builder: (context, scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(35.r)),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 12.h,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors
                                    .secondaryColor, // Adjust color as needed
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.r)),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  Container(
                                    width: 80.w,
                                    height: 5.h,
                                    padding: EdgeInsets.all(12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.h),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    expense == null
                                        ? "Add Expense"
                                        : "Edit Expense",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 20.h,
                                      left: 16.h,
                                      right: 16.h,
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          16.h,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        AppInputField(
                                          label: "Expense Type",
                                          isDropdown: true, hint: cat,
                                          defaultValue: selectedExpenseType
                                              .toString(), // Correct default value
                                          dropdownItems: const [
                                            DropdownMenuItem(
                                                value: "FUEL",
                                                child: Text("Fuel Costs")),
                                            DropdownMenuItem(
                                                value: "DRIVER_ALLOWANCE",
                                                child:
                                                    Text("Driver Allowances")),
                                            DropdownMenuItem(
                                                value: "TOLL",
                                                child: Text("Toll Charges")),
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
                                                  ExpenseCategory.values
                                                      .firstWhere(
                                                (e) => e.name == value,
                                                orElse: () => ExpenseCategory
                                                    .MISCELLANEOUS,
                                              );
                                              print(
                                                  "Selected Expense Type: $selectedExpenseType");
                                            });
                                          },
                                        ),
                                        AppInputField(
                                          label: "Amount",
                                          hint: "Enter Amount",
                                          defaultValue: _amount.toString(),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onInputChanged: (value) {
                                            setState(() {
                                              _amount = double.parse(value!);
                                            });
                                          },
                                        ),
                                        AppInputField(
                                          label: "Date",
                                          isDatePicker: true,
                                          controller:
                                              _dateController, // Show only date
                                          onDateSelected: (date) {
                                            setState(() {
                                              _expenseDate = date;
                                              _dateController.text = _formatDate(
                                                  date); // Update text in field
                                            });
                                          },
                                        ),
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
                                        _isLoading
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Row(
                                                children: [
                                                  Expanded(
                                                      child: AppPrimaryButton(
                                                          onPressed: () {},
                                                          title:
                                                              "Attach Receipt")),
                                                  const SizedBox(width: 10),
                                                  Expanded(
                                                      child: AppPrimaryButton(
                                                          onPressed: () async {
                                                            if (_formKey
                                                                .currentState!
                                                                .validate()) {
                                                              //print("Submitted Expense Data: ${expense}");
                                                              setState(() {
                                                                _isLoading =
                                                                    true; // Disable button & show loader
                                                              });
                                                              var f = {
                                                                "id":
                                                                    expense?.id,
                                                                "tripId": widget
                                                                    .tripId,
                                                                "amount":
                                                                    _amount,
                                                                "category":
                                                                    selectedExpenseType
                                                                        .toString()
                                                                        .split(
                                                                            '.')[1],
                                                                "expenseDate":
                                                                    _expenseDate
                                                                        .toIso8601String(),
                                                                "description":
                                                                    _description,
                                                                "attachmentUrl":
                                                                    "",
                                                                "createdAt": DateTime
                                                                        .now()
                                                                    .toIso8601String(),
                                                                "updatedAt": DateTime
                                                                        .now()
                                                                    .toIso8601String()
                                                              };
                                                              try {
                                                                final response = await APIService.instance.request(
                                                                    expense ==
                                                                            null
                                                                        ? "https://yaantrac-backend.onrender.com/api/expenses/${widget.tripId}"
                                                                        : "https://yaantrac-backend.onrender.com/api/expenses/${expense.id}",
                                                                    expense ==
                                                                            null
                                                                        ? DioMethod
                                                                            .post
                                                                        : DioMethod
                                                                            .put,
                                                                    formData: f,
                                                                    contentType:
                                                                        "application/json");
                                                                if (response
                                                                        .statusCode ==
                                                                    200) {
                                                                  ToastHelper.showCustomToast(
                                                                      context,
                                                                      (expense ==
                                                                              null)
                                                                          ? "Expense Added Sucessfully"
                                                                          : "Expense Updated Sucessfully",
                                                                      Colors
                                                                          .green,
                                                                      expense ==
                                                                              null
                                                                          ? Icons
                                                                              .add
                                                                          : Icons
                                                                              .edit);

                                                                  _formKey
                                                                      .currentState
                                                                      ?.reset();
                                                                  Navigator.of(
                                                                          context)
                                                                      .pushAndRemoveUntil(
                                                                          MaterialPageRoute(
                                                                              builder: (context) =>
                                                                                  TripViewPage(
                                                                                    tripId: widget.tripId,
                                                                                    trip: widget.trip,
                                                                                    index: 1,
                                                                                    vehicleId: widget.vehicleId,
                                                                                  )),
                                                                          (route) =>
                                                                              false);
                                                                } else {
                                                                  print(response
                                                                      .statusMessage);
                                                                }
                                                              } catch (e) {
                                                                throw Exception(
                                                                    "Error Posting Income: $e");
                                                              } finally {
                                                                ToastHelper.showCustomToast(
                                                                    context,
                                                                    "Network error! Please try again.",
                                                                    Colors.red,
                                                                    Icons
                                                                        .error);
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
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
      },
    );
  }

  void _showAddEditIncomeModal({IncomeModel? income}) {
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
        return DraggableScrollableSheet(
            initialChildSize: 0.3.h, // Starts at of screen height
            minChildSize: 0.2.h, // Minimum height
            maxChildSize: 0.4.h,
            expand: false,
            builder: (context, scrollController) {
              return StatefulBuilder(
                builder: (context, setState) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(35.r)),
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Padding(
                        padding: EdgeInsets.only(
                          bottom:
                              MediaQuery.of(context).viewInsets.bottom + 12.h,
                        ),
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 50.h,
                              decoration: BoxDecoration(
                                color: AppColors
                                    .secondaryColor, // Adjust color as needed
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15.r)),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 5.h),
                                  Container(
                                    width: 80.w,
                                    height: 5.h,
                                    padding: EdgeInsets.all(12.h),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20.h),
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    income == null
                                        ? "Add Income"
                                        : "Edit Income",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.h,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.only(
                                        top: 18.h,
                                        left: 12.h,
                                        right: 12.h,
                                        bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            12.h,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          AppInputField(
                                            label: "Amount",
                                            hint: "Enter Amount",
                                            keyboardType: TextInputType.number,
                                            defaultValue: _amount.toString(),
                                            inputFormatters: [
                                              FilteringTextInputFormatter
                                                  .digitsOnly
                                            ],
                                            onInputChanged: (value) {
                                              setState(() {
                                                _amount = double.parse(value!);
                                              });
                                            },
                                          ),
                                          SizedBox(height: 5.h),
                                          AppInputField(
                                            label: "Date",
                                            isDatePicker: true,
                                            controller:
                                                _dateController, // Use the controller instead of defaultValue
                                            onDateSelected: (date) {
                                              setState(() {
                                                _incomeDate = date;
                                                _dateController.text = _formatDate(
                                                    date); // Update text in field
                                              });
                                            },
                                          ),
                                          SizedBox(height: 5.h),
                                          AppInputField(
                                            label: "Description",
                                            hint: "Enter Description",
                                            keyboardType:
                                                TextInputType.multiline,
                                            defaultValue:
                                                _description.toString(),
                                            onInputChanged: (value) {
                                              setState(() {
                                                _description = value!;
                                              });
                                            },
                                          ),
                                          SizedBox(height: 5.h),
                                          isLoading
                                              ? const Center(
                                                  child:
                                                      CircularProgressIndicator())
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                        child: AppPrimaryButton(
                                                            onPressed: () {},
                                                            title:
                                                                "Attach Receipt")),
                                                    SizedBox(width: 10.h),
                                                    Expanded(
                                                        child: AppPrimaryButton(
                                                            onPressed:
                                                                () async {
                                                              if (_formKey
                                                                  .currentState!
                                                                  .validate()) {
                                                                setState(() {
                                                                  isLoading =
                                                                      true; // Disable button & show loader
                                                                });
                                                                IncomeModel
                                                                    inc =
                                                                    IncomeModel(
                                                                  id: income
                                                                      ?.id,
                                                                  amount:
                                                                      _amount,
                                                                  incomeDate:
                                                                      _incomeDate,
                                                                  tripId: widget
                                                                      .tripId,
                                                                  description:
                                                                      _description,
                                                                  createdAt:
                                                                      DateTime
                                                                          .now(),
                                                                  updatedAt:
                                                                      DateTime
                                                                          .now(),
                                                                );
                                                                print(inc
                                                                    .toJson());
                                                                try {
                                                                  final response =
                                                                      await APIService
                                                                          .instance
                                                                          .request(
                                                                    income ==
                                                                            null
                                                                        ? "https://yaantrac-backend.onrender.com/api/income/${widget.tripId}"
                                                                        : "https://yaantrac-backend.onrender.com/api/income/${income.id}",
                                                                    income ==
                                                                            null
                                                                        ? DioMethod
                                                                            .post
                                                                        : DioMethod
                                                                            .put,
                                                                    formData: inc
                                                                        .toJson(),
                                                                    contentType:
                                                                        "application/json",
                                                                  );
                                                                  if (response
                                                                          .statusCode ==
                                                                      200) {
                                                                    ToastHelper.showCustomToast(
                                                                        context,
                                                                        income ==
                                                                                null
                                                                            ? "Income added successfully!"
                                                                            : "Income updated successfully!",
                                                                        Colors
                                                                            .green,
                                                                        income ==
                                                                                null
                                                                            ? Icons.add
                                                                            : Icons.edit);
                                                                    _formKey
                                                                        .currentState
                                                                        ?.reset();
                                                                    Navigator.of(context).pushAndRemoveUntil(
                                                                        MaterialPageRoute(
                                                                            builder: (context) => TripViewPage(
                                                                                  tripId: widget.tripId,
                                                                                  trip: widget.trip,
                                                                                  index: 2,
                                                                                  vehicleId: widget.vehicleId,
                                                                                )),
                                                                        (route) => false);
                                                                  } else {
                                                                    print(response
                                                                        .statusMessage);
                                                                  }
                                                                } catch (e) {
                                                                  throw Exception(
                                                                      "Error Posting Income: $e");
                                                                } finally {
                                                                  ToastHelper.showCustomToast(
                                                                      context,
                                                                      "Network error! Please try again.",
                                                                      Colors
                                                                          .red,
                                                                      Icons
                                                                          .error);
                                                                  setState(() {
                                                                    isLoading =
                                                                        false; // Re-enable button after request
                                                                  });
                                                                }
                                                              }
                                                            },
                                                            title: income?.id ==
                                                                    null
                                                                ? "Add"
                                                                : "Update")),
                                                  ],
                                                ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            });
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
        child: SafeArea(
            child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text("Trip Overview"),
            ),
            backgroundColor: AppColors.secondaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
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
              labelColor: Colors.black,
              indicatorColor: Colors.white,
              dividerColor: Colors.white,
              unselectedLabelColor: Colors.white,
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
        )));
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
                    borderRadius: BorderRadius.circular(10.h),
                  ),
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  elevation: 2.h, // Adds a subtle shadow for depth
                  margin: EdgeInsets.fromLTRB(18.h, 10.h, 18.h, 8.h),
                  child: Padding(
                    padding: EdgeInsets.all(8.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Trip Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.h,
                              color: theme.brightness == Brightness.dark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        Divider(thickness: 1.h, height: 20.h),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.blueAccent),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'Source: ${trip.source}',
                                style: TextStyle(fontSize: 12.h),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            const Icon(Icons.flag, color: Colors.redAccent),
                            SizedBox(width: 8.h),
                            Expanded(
                              child: Text(
                                'Destination: ${trip.destination}',
                                style: TextStyle(fontSize: 12.h),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            const Icon(Icons.calendar_today,
                                color: Colors.green),
                            SizedBox(width: 8.h),
                            Expanded(
                              child: Text(
                                'Start Date: ${_formatDate(trip.startDate)}',
                                style: TextStyle(fontSize: 12.h),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          children: [
                            const Icon(Icons.event, color: Colors.orange),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                'End Date: ${_formatDate(trip.endDate)}',
                                style: TextStyle(fontSize: 12.h),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
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
                Card(
                  margin: EdgeInsets.fromLTRB(18.h, 10.h, 18.h, 10.h),
                  elevation: 2.h,
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  child: Padding(
                      padding: EdgeInsets.all(8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              "Expense Breakdown",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          ExpenseTable(breakDown: tripProfitSummary.breakDown),
                        ],
                      )),
                ),
                Card(
                  margin: EdgeInsets.fromLTRB(18.h, 2.h, 18.h, 2.h),
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[900]
                      : Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 15.h),
                      Text(
                        "Expense Distribution",
                        style: TextStyle(
                            fontSize: 18.h, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: EdgeInsets.all(6.h),
                        padding: EdgeInsets.all(2.h),
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
                  padding: EdgeInsets.all(12.h),
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
            padding: EdgeInsets.all(12.h),
            child: AppPrimaryButton(
                onPressed: _showAddEditExpenseModal, title: "Add Expense")),
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
        AppPrimaryButton(
            onPressed: _showAddEditIncomeModal, title: "Add Income"),
        SizedBox(
          height: 10.h,
        )
      ],
    );
  }

  Widget _buildExpenseListItem({required ExpenseModel expense}) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(6.h),
        child: Row(
          children: [
            Icon(Icons.receipt_long, size: 40.h, color: Colors.blueGrey),
            SizedBox(width: 10.h),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category.toString().split('.').last,
                    style: TextStyle(
                      fontSize: 10.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Amount: ₹${expense.amount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 10.h,
                    ),
                  ),
                  Text(
                    'Date: ${_formatDate(expense.expenseDate)}',
                    style: TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 10.h,
                    ),
                  ),
                  Text(
                    'Description: ${expense.description}',
                    style: TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 10.h,
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
                      _showAddEditExpenseModal(expense: expense);
                    }),
                SizedBox(width: 8.h),
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
      elevation: 2.h,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      margin: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    'Amount: ₹${amount.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 10.h, color: Colors.green[700]),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Date: ${_formatDate(income.incomeDate)}',
                    style: TextStyle(fontSize: 10.h, color: Colors.grey),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Description: $description',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 10.sp),
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
                      _showAddEditIncomeModal(income: income);
                    }),
                SizedBox(width: 8.w),
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
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28.sp),
                  SizedBox(width: 8.w),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10.h),
                        Text("Deleting Trip... Please wait",
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this expense? This action cannot be undone.",
                      style: TextStyle(fontSize: 14.sp)),
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
                              borderRadius: BorderRadius.circular(8.r)),
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
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28.sp),
                  SizedBox(width: 8.w),
                  Text("Confirm Delete",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10.h),
                        Text("Deleting Trip... Please wait",
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey)),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this income? This action cannot be undone.",
                      style: TextStyle(fontSize: 14.sp)),
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
                              borderRadius: BorderRadius.circular(8.r)),
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
        borderRadius:
            BorderRadius.circular(10.r), // Increased for a softer look
      ),
      color:
          theme.brightness == Brightness.dark ? Colors.grey[850] : Colors.white,
      elevation: 2.h, // Adds a shadow for depth
      shadowColor: Colors.black26, // Softer shadow effect
      child: Container(
        padding: EdgeInsets.all(12.h),
        height: 80.h, // Slightly increased for better spacing
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 10.h, // Increased for better readability
                fontWeight: FontWeight.bold, // Stronger emphasis
                color: theme.brightness == Brightness.dark
                    ? Colors.white
                    : Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Text(
              amount,
              style: TextStyle(
                fontSize: 12.h, // Slightly larger for better visibility
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

    return Center(
      child: DataTable(
        columnSpacing: 20.0.h,
        columns: [
          DataColumn(
              label: Text('Category',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Amount',
                  style: TextStyle(fontWeight: FontWeight.bold))),
          DataColumn(
              label: Text('Percentage',
                  style: TextStyle(fontWeight: FontWeight.bold))),
        ],
        rows: [
          ...breakDown.entries.map((entry) {
            double percentage = total > 0 ? (entry.value / total) * 100 : 0;
            return DataRow(cells: [
              DataCell(
                  Text(entry.key.replaceAll('_', ' '))), // Formatting names
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
      ),
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
          width: 140.w, // Adjust width for responsiveness
          height: 190.h,
          padding: EdgeInsets.all(12.h),
          child: PieChart(
            PieChartData(
              sections: breakdown.entries.map((entry) {
                return PieChartSectionData(
                  value: entry.value,
                  color: _getColor(entry.key),
                  radius: 40.r, // Adjusts segment size
                  showTitle: false, // Removes text inside pie chart
                );
              }).toList(),
              sectionsSpace: 2.r,
              centerSpaceRadius: 30.r,
            ),
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: breakdown.entries.map((entry) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 4.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12.w,
                    height: 12.h,
                    decoration: BoxDecoration(
                      color: _getColor(entry.key),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    entry.key.toUpperCase(),
                    style:
                        TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 8.w),
                  CustomPaint(
                    painter: ArrowPainter(),
                    child: SizedBox(width: 13.w),
                  ),
                  Text(
                    entry.value.toInt().toString(), // Displays value
                    style:
                        TextStyle(fontSize: 8.sp, fontWeight: FontWeight.bold),
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
