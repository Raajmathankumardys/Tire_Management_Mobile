import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/models/income.dart'; // Replace with the actual income model
import 'package:yaantrac_app/screens/expense_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

import 'expense_screen.dart';

class AddIncomeScreen extends StatefulWidget {
  final IncomeModel? income;
  const AddIncomeScreen({super.key, this.income});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final int tripId = 1;
  String selectedIncomeType = "";
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String description = "";
  late double _amount;
  late DateTime _incomeDate;
  late int _tripId;
  late String _description;
  final TextEditingController _dateController = TextEditingController();

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _amount = widget.income?.amount ?? 0.0;
    _incomeDate = widget.income?.incomeDate ?? DateTime.now();
    _dateController.text =
        "$_incomeDate.toLocal()}".split(' ')[0]; // Format the date
    _tripId = widget.income?.tripId ?? 0;
    _description = widget.income?.description ?? "";
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  final _formKey = GlobalKey<FormState>();

  void _submitIncome() async {
    var iid = (widget.income == null) ? null : widget.income!.incomeId;
    if (_formKey.currentState!.validate()) {
      IncomeModel income = IncomeModel(
        incomeId: iid,
        amount: _amount,
        incomeDate: _incomeDate,
        tripId: tripId,
        description: _description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      print(income.toJson());
      try {
        final response = await APIService.instance.request(
          widget.income == null
              ? "https://yaantrac-backend.onrender.com/api/income/${income.tripId}"
              : "https://yaantrac-backend.onrender.com/api/income/${income.incomeId}",
          widget.income == null ? DioMethod.post : DioMethod.put,
          formData: income.toJson(),
          contentType: "application/json",
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(widget.income == null
                    ? "Income added successfully!"
                    : "Income updated successfully!")),
          );
          _formKey.currentState?.reset();
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => ExpensesListScreen(tripId: tripId)),
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
          "Income",
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
                  "Add a new income",
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 25),
                ),
                const SizedBox(height: 10),
                AppInputField(
                  label: "Trip Id",
                  hint: "Enter Trip Id",
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  disabled: true,
                  defaultValue: _tripId.toString(),
                ),
                const SizedBox(height: 5),
                AppInputField(
                  label: "Amount",
                  hint: "Enter Amount",
                  keyboardType: TextInputType.number,
                  defaultValue: _amount.toString(),
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
                Row(
                  children: [
                    Expanded(
                        child: AppPrimaryButton(
                            onPressed: () {}, title: "Attach Receipt")),
                    const SizedBox(width: 10),
                    Expanded(
                        child: AppPrimaryButton(
                            onPressed: _submitIncome,
                            title: widget.income?.incomeId == null
                                ? "Submit"
                                : "Update")),
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
