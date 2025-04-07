import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/helpers/components/shimmer.dart';

import '../../../models/tire_expense.dart';
import '../../../screens/Homepage.dart';
import '../../../services/api_service.dart';
import '../../cubit/base_cubit.dart';
import '../../cubit/base_state.dart';
import '../../helpers/components/themes/app_colors.dart';
import '../../helpers/components/widgets/Toast/Toast.dart';
import '../../helpers/components/widgets/button/action_button.dart';
import '../../helpers/components/widgets/button/app_primary_button.dart';
import '../../helpers/components/widgets/input/app_input_field.dart';

class tire_expense_screen extends StatefulWidget {
  const tire_expense_screen({super.key});

  @override
  State<tire_expense_screen> createState() => _tireexpensescreenState();
}

class _tireexpensescreenState extends State<tire_expense_screen> {
  Future<void> _showAddModal(BuildContext ctx, {Tireexpense? tire}) async {
    final _formKey = GlobalKey<FormState>();
    DateTime? expensedate = DateTime.now();
    int tireId = tire?.tireId ?? 0;
    TextEditingController expensetype = TextEditingController();
    TextEditingController notes = TextEditingController();
    TextEditingController cost = TextEditingController();
    TextEditingController _expensedate = TextEditingController();
    if (tire != null) {
      tireId = tire.tireId;
      expensetype.text = tire.expenseType;
      notes.text = tire.notes;
      cost.text = tire.cost.toString();
      _expensedate.text = _formatDate(tire.expenseDate);
      expensedate = tire.expenseDate;
    }

    late List<dynamic> tires = [];

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
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (
          context,
        ) {
          return StatefulBuilder(builder: (context, setState) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                ),
                child: SingleChildScrollView(
                  scrollDirection:
                      Axis.vertical, // Attach the scroll controller
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 40.h,
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
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              SizedBox(height: 5.h),
                              Text(
                                tire == null
                                    ? "Add Tire Expense"
                                    : "Edit Tire Expense",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12.h,
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
                              bottom: MediaQuery.of(context).viewInsets.bottom +
                                  12.h,
                              top: 12.h,
                            ),
                            child: Column(
                              children: [
                                AppInputField(
                                  name: 'text_field',
                                  label: "Tire",
                                  isDropdown: true,
                                  hint: tires
                                          .firstWhere(
                                            (t) => t["id"] == tireId,
                                            orElse: () => {'serialNo': ''},
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
                                      child: Text(t["serialNo"]?.toString() ??
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
                                  name: 'number_field',
                                  label: "Cost",
                                  hint: "Enter cost",
                                  keyboardType: TextInputType.number,
                                  controller: cost,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                AppInputField(
                                  name: 'text_field',
                                  label: "Expense Type",
                                  hint: "Enter expense type",
                                  controller: expensetype,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                AppInputField(
                                    name: 'date_field',
                                    label: "Expense Date",
                                    isDatePicker: true,
                                    controller: _expensedate,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'This field is required';
                                      }
                                      return null;
                                    },
                                    onDateSelected: (date) {
                                      setState(() {
                                        expensedate = date!;
                                        _expensedate.text = _formatDate(
                                            date); // Update text in field
                                      });
                                    }),
                                AppInputField(
                                  name: 'text_field',
                                  label: "Notes",
                                  hint: "Enter notes",
                                  controller: notes,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'This field is required';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 8.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Expanded(
                                        child: AppPrimaryButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            title: "Cancel")),
                                    SizedBox(
                                      width: 4.h,
                                    ),
                                    Expanded(
                                        child: AppPrimaryButton(
                                            width: 130.h,
                                            onPressed: () async {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                final tirep = Tireexpense(
                                                    id: tire?.id,
                                                    maintenanceId: null,
                                                    cost:
                                                        double.parse(cost.text),
                                                    expenseDate: expensedate!,
                                                    expenseType:
                                                        expensetype.text,
                                                    notes: notes.text,
                                                    tireId: tireId);
                                                tire == null
                                                    ? ctx
                                                        .read<
                                                            BaseCubit<
                                                                Tireexpense>>()
                                                        .addItem(tirep)
                                                    : ctx
                                                        .read<
                                                            BaseCubit<
                                                                Tireexpense>>()
                                                        .updateItem(
                                                            tirep, tirep.id!);
                                                Navigator.pop(context);
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
            );
          });
        });
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> _confirmDelete(BuildContext ctx, int expenseId) async {
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
              content: Text(
                "Are you sure you want to delete this tire expense? This action cannot be undone.",
                style: TextStyle(
                  fontSize: 15.sp,
                ),
              ),
              actions: [
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
                    ctx.read<BaseCubit<Tireexpense>>().deleteItem(expenseId);
                    Navigator.pop(context);
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
                        _showAddModal(context);
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
            body: BlocConsumer<BaseCubit<Tireexpense>, BaseState<Tireexpense>>(
                listener: (context, state) {
              if (state is AddedState ||
                  state is UpdatedState ||
                  state is DeletedState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context,
                    message,
                    Colors.green,
                    (state is AddedState)
                        ? Icons.add
                        : (state is UpdatedState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is ApiErrorState<Tireexpense>) {
                ToastHelper.showCustomToast(
                    context, state.message, Colors.red, Icons.error);
              }
            }, builder: (context, state) {
              if (state is LoadingState<Tireexpense>) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
                  child: shimmer(),
                );
              } else if (state is ErrorState<Tireexpense>) {
                return Center(child: Text(state.message));
              } else if (state is LoadedState<Tireexpense>) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.h),
                  itemCount: state.items.length,
                  itemBuilder: (context, index) {
                    final tire = state.items[index];
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
                          tire.expenseType.toString(),
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
                                    color: Colors.grey[400], fontSize: 10.sp)),
                            Text("Cost: ${tire.cost}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.sp)),
                            Text("Notes: ${tire.notes}",
                                style: TextStyle(
                                    color: Colors.grey[400], fontSize: 10.sp)),
                          ],
                        ),
                        trailing: Wrap(
                          spacing: 5.h,
                          children: [
                            ActionButton(
                                icon: Icons.edit,
                                color: Colors.green,
                                onPressed: () =>
                                    {_showAddModal(context, tire: tire)}),
                            ActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () =>
                                    {_confirmDelete(context, tire.id!)})
                            //_confirmDelete(tire.id!.toInt())),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
              return Center(child: Text("No Tires Expense available"));
            })));
  }
}
