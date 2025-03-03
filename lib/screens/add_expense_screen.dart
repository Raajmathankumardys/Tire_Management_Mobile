import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/models/expense.dart';
import 'package:yaantrac_app/services/api_service.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final int tripId = 2;
  ExpenseCategory selectedExpenseType = ExpenseCategory.MISCELLANEOUS;
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String description = "";

  final _formKey = GlobalKey<FormState>();

  void _submitExpense() async {
    if (_formKey.currentState!.validate()) {
      ExpenseModel expense = ExpenseModel(
        amount: amount,
        category: selectedExpenseType,
        expenseDate: selectedDate,
        tripId: tripId,
        description: description,
        attachmentUrl: "",
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      print("Submitted Expense Data: ${expense.toJson()}");

      try {
        final response = await APIService.instance.request(
            "/expenses/$tripId", DioMethod.post,
            formData: expense.toJson(), contentType: "application/json");
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Added data")));
          _formKey.currentState?.reset();
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
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  disabled: true,
                  defaultValue: tripId.toString(),
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Expense Type",
                  isDropdown: true,
                  dropdownItems: const [
                    DropdownMenuItem(value: "FUEL", child: Text("Fuel Costs")),
                    DropdownMenuItem(
                        value: "DRIVER", child: Text("Driver Allowances")),
                    DropdownMenuItem(
                        value: "TOLL", child: Text("Toll Charges")),
                    DropdownMenuItem(
                        value: "MAINTENANCE", child: Text("Maintenance")),
                  ],
                  onDropdownChanged: (value) {
                    selectedExpenseType = ExpenseCategory.values.firstWhere(
                      (e) => e.toString().split(".").last == value,
                      orElse: () => ExpenseCategory.MISCELLANEOUS,
                    );
                  },
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Amount",
                  hint: "Enter Amount",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onInputChanged: (value) {
                    setState(() {
                      amount = double.parse(value!);
                    });
                  },
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Date",
                  isDatePicker: true,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Description",
                  hint: "Enter Description",
                  keyboardType: TextInputType.multiline,
                  onInputChanged: (value) {
                    setState(() {
                      description = value!;
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
