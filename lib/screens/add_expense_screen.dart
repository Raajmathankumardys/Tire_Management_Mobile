import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/models/expense.dart';
import 'package:yaantrac_app/screens/expense_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

import 'expense_screen.dart';

class AddExpenseScreen extends StatefulWidget {
  final ExpenseModel? expense;
  final int? trid;
  const AddExpenseScreen({super.key, this.expense, required this.trid});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final int tripId = 1;
  ExpenseCategory selectedExpenseType = ExpenseCategory.MISCELLANEOUS;
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String description = "";

  late double _amount;
  late ExpenseCategory _category;
  late DateTime _expenseDate;
  late int _tripId;
  late String _description;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  late String cat;

  @override
  void initState() {
    super.initState();
    print(widget.expense?.toJson());
    print(widget.trid);
    gettrip();
    _amount = widget.expense?.amount ?? 0.0;
    _category = widget.expense?.category ?? ExpenseCategory.FUEL;
    _expenseDate = widget.expense?.expenseDate ?? DateTime.now();
    _dateController.text = _formatDate(_expenseDate);
    _tripId = widget.expense?.tripId ?? 0;
    _description = widget.expense?.description ?? " ";
    selectedExpenseType = widget.expense?.category ?? ExpenseCategory.FUEL;
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
  }

  Map<String, dynamic>? trip;
  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> gettrip() async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips/${widget.trid}",
          DioMethod.get,
          contentType: "application/json");
      if (response.statusCode == 200) {
        trip = response.data;
        print("Get");
        print(trip);
      } else {
        print(response.statusMessage);
      }
    } catch (e) {
      print(e);
    }
  }

  void _submitExpense() async {
    var eid = (widget.expense == null) ? null : widget.expense!.expenseId;
    if (_formKey.currentState!.validate()) {
      var expense;
      if (widget.expense != null) {
        expense = {
          "expenseId": eid,
          "trip": {
            "id": widget.trid,
          },
          "amount": _amount,
          "category": selectedExpenseType.toString().split('.')[1],
          "expenseDate": _expenseDate.toIso8601String(),
          "description": _description,
          "attachmentUrl": "",
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String()
        };
      } else {
        expense = {
          "expenseId": eid,
          "tripId": widget.trid,
          "amount": _amount,
          "category": selectedExpenseType.toString().split('.')[1],
          "expenseDate": _expenseDate.toIso8601String(),
          "description": _description,
          "attachmentUrl": "",
          "createdAt": DateTime.now().toIso8601String(),
          "updatedAt": DateTime.now().toIso8601String()
        };
      }
      print("Submitted Expense Data: ${expense}");

      try {
        final response = await APIService.instance.request(
            widget.expense == null
                ? "https://yaantrac-backend.onrender.com/api/expenses/${widget.trid}"
                : "https://yaantrac-backend.onrender.com/api/expenses/${eid}",
            widget.expense == null ? DioMethod.post : DioMethod.put,
            formData: expense,
            contentType: "application/json");
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text((widget.expense == null)
                  ? "Expense Added Sucessfully"
                  : "Expense Updated Sucessfully")));
          _formKey.currentState?.reset();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) =>
                      ExpensesListScreen(tripId: widget.trid!.toInt())),
              (route) => false);
        } else {
          print(response.statusMessage);
        }
      } catch (e) {
        throw Exception("Error Posting Income: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense",
          style: TextStyle(fontSize: 20),
        ),
        actions: const [Icon(Icons.search)],
        leading: Builder(builder: (BuildContext context) {
          return IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          );
        }),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Add a new expense",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                const SizedBox(height: 10),
                AppInputField(
                  label: "Trip Id",
                  hint: "Enter Trip Id",
                  defaultValue: widget.trid.toString() ?? "null",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  disabled: true,
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Expense Type",
                  isDropdown: true, hint: cat,
                  defaultValue:
                      selectedExpenseType.toString(), // Correct default value
                  dropdownItems: const [
                    DropdownMenuItem(value: "FUEL", child: Text("Fuel Costs")),
                    DropdownMenuItem(
                        value: "DRIVER_ALLOWANCE",
                        child: Text("Driver Allowances")),
                    DropdownMenuItem(
                        value: "TOLL", child: Text("Toll Charges")),
                    DropdownMenuItem(
                        value: "MAINTENANCE", child: Text("Maintenance")),
                    DropdownMenuItem(
                        value: "MISCELLANEOUS", child: Text("Miscellaneous")),
                  ],
                  onDropdownChanged: (value) {
                    print(value);
                    setState(() {
                      selectedExpenseType = ExpenseCategory.values.firstWhere(
                        (e) => e.name == value,
                        orElse: () => ExpenseCategory.MISCELLANEOUS,
                      );
                      print("Selected Expense Type: $selectedExpenseType");
                    });
                  },
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Amount",
                  hint: "Enter Amount",
                  defaultValue: _amount.toString(),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
                Row(
                  children: [
                    Expanded(
                        child: AppPrimaryButton(
                            onPressed: () {}, title: "Attach Receipt")),
                    const SizedBox(width: 10),
                    Expanded(
                        child: AppPrimaryButton(
                            onPressed: _submitExpense, title: "Submit")),
                  ],
                ),
                const SizedBox(height: 15),
                const Text(
                  "Summary",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                const SizedBox(height: 10),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total Income",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    Text("1000",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text("Total Expenses",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    Text("500",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                    SizedBox(height: 10),
                    Text("Remaining Balance",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500)),
                    Text("500",
                        style: TextStyle(fontSize: 16, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
