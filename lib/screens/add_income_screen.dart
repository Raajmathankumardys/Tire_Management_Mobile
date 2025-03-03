import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/common/widgets/input/app_input_field.dart';
import 'package:yaantrac_app/models/income.dart'; // Replace with the actual income model
import 'package:yaantrac_app/services/api_service.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final int tripId = 1;
  String selectedIncomeType = "";
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String description = "";
  final _formKey = GlobalKey<FormState>();

  void _submitIncome() async {
    if (_formKey.currentState!.validate()) {
      IncomeModel income = IncomeModel(
        amount: amount,
        incomeDate: selectedDate,
        tripId: tripId,
        description: description,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      try {
        final response = await APIService.instance.request(
          "/income/$tripId",
          DioMethod.post,
          formData: income.toJson(),
          contentType: "application/json",
        );
        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Income added successfully!")),
          );
          _formKey.currentState?.reset();
          Navigator.pop(context);
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
                  defaultValue: tripId.toString(),
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
                    print(date);
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
                            onPressed: _submitIncome, title: "Submit")),
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
