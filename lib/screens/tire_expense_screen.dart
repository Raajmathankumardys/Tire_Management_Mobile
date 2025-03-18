import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yaantrac_app/screens/Homepage.dart';

import '../common/widgets/Toast/Toast.dart';
import '../common/widgets/button/action_button.dart';
import '../common/widgets/button/app_primary_button.dart';
import '../common/widgets/input/app_input_field.dart';
import '../config/themes/app_colors.dart';
import '../models/tire_expense.dart';
import '../services/api_service.dart';

class tireexpensescreen extends StatefulWidget {
  const tireexpensescreen({super.key});

  @override
  State<tireexpensescreen> createState() => _tireexpensescreenState();
}

class _tireexpensescreenState extends State<tireexpensescreen> {
  late Future<List<Tireexpense>> futureTires;
  @override
  void initState() {
    // TODO: implement initState
    futureTires = getTireexpense();
    super.initState();
  }

  Future<void> _showAddModal({Tireexpense? tire}) async {
    final _formKey = GlobalKey<FormState>();
    double cost = tire?.cost ?? 0.0;
    String notes = tire?.notes ?? "";
    String expensetype = tire?.expenseType ?? '';
    DateTime expensedate = tire?.expenseDate ?? DateTime.now();
    int tireId = tire?.tireId ?? 0;
    TextEditingController _expensedate = new TextEditingController();
    _expensedate.text = _formatDate(expensedate);
    bool isLoading = false;
    late List<dynamic> tires = [];
    setState(() {
      isLoading = true;
    });
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tires",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        setState(() {
          if (response.data is Map<String, dynamic> &&
              response.data.containsKey("data")) {
            tires = response.data["data"];
            print(tires);
            setState(() {
              tires = response.data["data"];
            });
          } else if (response.data is List) {
            tires = response.data;
          } else {
            throw Exception("Unexpected response format");
          }
        });
      } else {
        throw Exception("API Error: ${response.statusMessage}");
      }
    } catch (e) {
      debugPrint("Network Error: $e");
    }

    setState(() {
      isLoading = false;
    });

    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (
          context,
        ) {
          return DraggableScrollableSheet(
            initialChildSize: 0.40.h, // Starts at of screen height
            minChildSize: 0.3.h, // Minimum height
            maxChildSize: 0.50.h, // Maximum height
            expand: false,
            builder: (context, scrollController) {
              return StatefulBuilder(builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35.r)),
                  ),
                  child: Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                      ),
                      child: SingleChildScrollView(
                        controller:
                            scrollController, // Attach the scroll controller
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
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
                                        borderRadius:
                                            BorderRadius.circular(20.h),
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      tire == null
                                          ? "Add Tire Expense"
                                          : "Edit Tire Expense",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.only(
                                    left: 12.w,
                                    right: 12.w,
                                    bottom: MediaQuery.of(context)
                                            .viewInsets
                                            .bottom +
                                        12.h,
                                    top: 12.h,
                                  ),
                                  child: Column(
                                    children: [
                                      AppInputField(
                                        label: "Tire",
                                        isDropdown: true,
                                        hint: tires
                                                .firstWhere(
                                                  (t) => t["id"] == tireId,
                                                  orElse: () =>
                                                      {'serialNo': ''},
                                                )["serialNo"]
                                                ?.toString() ??
                                            '',

                                        defaultValue: tires
                                            .firstWhere(
                                              (t) => t["id"] == tireId,
                                              orElse: () =>
                                                  {'id': '', 'serialNo': ''},
                                            )["id"]
                                            .toString(), // Ensure defaultValue matches the dropdown value format

                                        dropdownItems: tires.map((t) {
                                          return DropdownMenuItem<String>(
                                            value: t["id"]
                                                .toString(), // Ensure value is String
                                            child: Text(
                                                t["serialNo"]?.toString() ??
                                                    ''), // Null safety
                                          );
                                        }).toList(),

                                        onDropdownChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              tireId = int.tryParse(value) ??
                                                  0; // Ensure proper type conversion
                                            });
                                          }
                                        },
                                      ),
                                      AppInputField(
                                        label: "Cost",
                                        hint: "Enter cost",
                                        keyboardType: TextInputType.number,
                                        defaultValue: cost.toString(),
                                        onInputChanged: (value) =>
                                            cost = double.parse(value!),
                                      ),
                                      AppInputField(
                                        label: "Expense Type",
                                        hint: "Enter expense type",
                                        defaultValue: expensetype.toString(),
                                        onInputChanged: (value) =>
                                            expensetype = value ?? '',
                                      ),
                                      AppInputField(
                                          label: "Expense Date",
                                          isDatePicker: true,
                                          controller: _expensedate,
                                          onDateSelected: (date) {
                                            setState(() {
                                              expensedate = date;
                                              _expensedate.text = _formatDate(
                                                  date); // Update text in field
                                            });
                                          }),
                                      AppInputField(
                                        label: "Notes",
                                        hint: "Enter notes",
                                        defaultValue: notes.toString(),
                                        onInputChanged: (value) =>
                                            notes = value ?? '',
                                      ),
                                      isLoading
                                          ? const CircularProgressIndicator()
                                          : Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Expanded(
                                                    child: AppPrimaryButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        title: "Cancel")),
                                                SizedBox(
                                                  width: 10.h,
                                                ),
                                                Expanded(
                                                    child: AppPrimaryButton(
                                                        width: 130.h,
                                                        onPressed: () async {
                                                          if (_formKey
                                                              .currentState!
                                                              .validate()) {
                                                            setState(() =>
                                                                isLoading =
                                                                    true);
                                                            final tirep = Tireexpense(
                                                                id: null,
                                                                maintenanceId:
                                                                    null,
                                                                cost: cost,
                                                                expenseDate:
                                                                    expensedate,
                                                                expenseType:
                                                                    expensetype,
                                                                notes: notes,
                                                                tireId: tireId);
                                                            print(
                                                                tirep.toJson());
                                                            try {
                                                              final response =
                                                                  await APIService
                                                                      .instance
                                                                      .request(
                                                                tire == null
                                                                    ? "https://yaantrac-backend.onrender.com/api/tire-expenses"
                                                                    : "https://yaantrac-backend.onrender.com/api/tire-expenses/${tire.id}",
                                                                tire == null
                                                                    ? DioMethod
                                                                        .post
                                                                    : DioMethod
                                                                        .put,
                                                                formData: tirep
                                                                    .toJson(),
                                                                contentType:
                                                                    "application/json",
                                                              );
                                                              if (response
                                                                      .statusCode ==
                                                                  200) {
                                                                ToastHelper.showCustomToast(
                                                                    context,
                                                                    "Tire Expense added successfully",
                                                                    Colors
                                                                        .green,
                                                                    Icons.add);

                                                                Navigator.of(context).pushAndRemoveUntil(
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                tireexpensescreen()),
                                                                    (route) =>
                                                                        false);
                                                              } else {
                                                                ToastHelper.showCustomToast(
                                                                    context,
                                                                    "Failed to process request",
                                                                    Colors
                                                                        .green,
                                                                    Icons.add);
                                                              }
                                                            } catch (err) {
                                                              ToastHelper
                                                                  .showCustomToast(
                                                                      context,
                                                                      "Error: $err",
                                                                      Colors
                                                                          .red,
                                                                      Icons
                                                                          .error);
                                                            } finally {
                                                              ToastHelper
                                                                  .showCustomToast(
                                                                      context,
                                                                      "Network error Please try again.",
                                                                      Colors
                                                                          .red,
                                                                      Icons
                                                                          .error);
                                                              if (mounted)
                                                                setState(() =>
                                                                    isLoading =
                                                                        false);
                                                            }
                                                          }
                                                        },
                                                        title: tire == null
                                                            ? "Add"
                                                            : "Update"))
                                              ],
                                            ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            },
          );
        });
  }

  Future<List<Tireexpense>> getTireexpense() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tire-expenses",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> tireList = response.data['data'];
        print(tireList);
        return tireList.map((json) => Tireexpense.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> _confirmDelete(int expenseId) async {
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
              ), // Dark background for contrast
              title: Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 28.sp),
                  SizedBox(width: 8.sp),
                  Text(
                    "Confirm Delete",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: isDeleting
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 10.h),
                        Text(
                          "Deleting Tire... Please wait",
                          style: TextStyle(
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    )
                  : Text(
                      "Are you sure you want to delete this tire expense? This action cannot be undone.",
                      style: TextStyle(
                        fontSize: 15.sp,
                      ),
                    ),
              actions: isDeleting
                  ? []
                  : [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Cancel",
                            style: TextStyle(color: Colors.grey),
                          )),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r)),
                        ),
                        onPressed: () async {
                          setState(() => isDeleting = true);
                          await _onDelete(expenseId);
                          if (context.mounted) Navigator.pop(context);
                        },
                        child: Text(
                          "Delete",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  Future<void> _onDelete(int expenseId) async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/tire-expenses/$expenseId",
          DioMethod.delete,
          contentType: "application/json");
      if (response.statusCode == 200) {
        setState(() {
          futureTires = getTireexpense();
        });

        ToastHelper.showCustomToast(context,
            "Tire Expense Deleted Successfully", Colors.red, Icons.delete);
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text("Tire Expense",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                currentIndex: 1,
                              )),
                    );
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                  )),
              elevation: 2.w,
              actions: [
                Container(
                  padding: EdgeInsets.all(4.w),
                  alignment: Alignment.center,
                  child: IconButton(
                      alignment: Alignment.topRight,
                      onPressed: () {
                        _showAddModal();
                      },
                      icon: Icon(
                        Icons.add_circle,
                        size: 25.h,
                        color: Colors.black,
                      )),
                ),
              ],
              backgroundColor: AppColors.secondaryColor,
            ),
            body: FutureBuilder<List<Tireexpense>>(
              future: futureTires,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                      child:
                          CircularProgressIndicator(color: Colors.blueAccent));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text("Error: ${snapshot.error}",
                          style: TextStyle(color: Colors.grey[900])));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text("No tires available",
                          style: TextStyle(color: Colors.grey[900])));
                } else {
                  List<Tireexpense> tires = snapshot.data!;
                  return ListView.builder(
                    padding: EdgeInsets.all(10.h),
                    itemCount: tires.length,
                    itemBuilder: (context, index) {
                      final tire = tires[index];
                      return Card(
                        color: Colors.white,
                        elevation: 2.w,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.r)),
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.h),
                          leading: Icon(
                            Icons.currency_exchange,
                            size: 30.h,
                          ),
                          title: Text(
                            tire.maintenanceId.toString(),
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  "Expense Date: ${_formatDate(tire.expenseDate)}",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10.sp)),
                              Text("Expense Type: ${tire.expenseType}",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10.sp)),
                              Text("Cost: ${tire.cost}",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10.sp)),
                              Text("Notes: ${tire.notes}",
                                  style: TextStyle(
                                      color: Colors.grey[400],
                                      fontSize: 10.sp)),
                            ],
                          ),
                          trailing: Wrap(
                            spacing: 5.h,
                            children: [
                              ActionButton(
                                  icon: Icons.edit,
                                  color: Colors.green,
                                  onPressed: () => {_showAddModal(tire: tire)}),
                              ActionButton(
                                  icon: Icons.delete,
                                  color: Colors.red,
                                  onPressed: () => {_confirmDelete(tire.id!)})
                              //_confirmDelete(tire.id!.toInt())),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            )));
  }
}
