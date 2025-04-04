import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:yaantrac_app/TMS/Tire-Category/cubit/tire_category_state.dart';
import 'package:yaantrac_app/screens/Homepage.dart';

import '../../../../common/widgets/Toast/Toast.dart';
import '../../../../common/widgets/button/action_button.dart';
import '../../../../common/widgets/button/app_primary_button.dart';
import '../../../../common/widgets/input/app_input_field.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../presentation/widget/shimmer.dart';
import '../../cubit/tire_category_cubit.dart';

class Tire_Category_Screen extends StatefulWidget {
  const Tire_Category_Screen({super.key});
  @override
  State<Tire_Category_Screen> createState() => _Tire_Category_Screen_State();
}

class _Tire_Category_Screen_State extends State<Tire_Category_Screen> {
  void _showAddEditModal(BuildContext ctx, {TireCategory? tirecategory}) {
    final _formKey = GlobalKey<FormState>();

    // Initialize controllers
    TextEditingController categoryController = TextEditingController();
    TextEditingController descriptionontroller = TextEditingController();

    // Prefill values if editing an existing vehicle
    if (tirecategory != null) {
      categoryController.text = tirecategory.category;
      descriptionontroller.text = tirecategory.description;
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 12,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15.r)),
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: 5.h),
                          Container(
                            width: 80,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            tirecategory == null
                                ? "Add Tire Category"
                                : "Edit Tire Category",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.h,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Form Inputs
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 12.h),
                      child: Column(
                        children: [
                          AppInputField(
                            name: 'text_field',
                            label: "Category",
                            hint: "Enter category",
                            controller: categoryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              if (value.length < 3) {
                                return "Name must have 3 atleast characters";
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: 'text_field',
                            label: "Description",
                            hint: "Enter description",
                            controller: descriptionontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'This field is required';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              AppPrimaryButton(
                                width: 130,
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                title: "Cancel",
                              ),
                              AppPrimaryButton(
                                width: 130,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    final newtirecategory = TireCategory(
                                        id: tirecategory?.id,
                                        category: categoryController.text,
                                        description: descriptionontroller.text);

                                    if (tirecategory == null) {
                                      ctx
                                          .read<TireCategoryCubit>()
                                          .addTireCategory(newtirecategory);
                                    } else {
                                      ctx
                                          .read<TireCategoryCubit>()
                                          .updateTireCategory(newtirecategory);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                title: tirecategory == null ? "Save" : "Update",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
      },
    );
  }

  Future<void> _confirmDeleteTireCategory(
      BuildContext ctx, int tirecategoryId) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: const [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 25),
              SizedBox(width: 8),
              Text("Confirm Delete",
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          content: const Text(
            "Are you sure you want to delete this vehicle? This action cannot be undone.",
            style: TextStyle(fontSize: 14),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                ctx
                    .read<TireCategoryCubit>()
                    .deleteTireCategory(tirecategoryId);
                Navigator.pop(context);
              },
              child:
                  const Text("Delete", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text("Tire Category",
                      style: TextStyle(fontWeight: FontWeight.bold))),
              backgroundColor: AppColors.secondaryColor,
              leading: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => HomeScreen(
                                  currentIndex: 1,
                                )));
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              actions: [
                IconButton(
                    onPressed: () => {_showAddEditModal(context)},
                    icon: Icon(
                      Icons.add_circle,
                      color: Colors.black,
                    ))
              ],
            ),
            body: BlocConsumer<TireCategoryCubit, TireCategoryState>(
                listener: (context, state) {
              if (state is AddedTireCategoryState ||
                  state is UpdatedTireCategoryState ||
                  state is DeletedTireCategoryState) {
                final message = (state as dynamic).message;
                ToastHelper.showCustomToast(
                    context,
                    message,
                    Colors.green,
                    (state is AddedTireCategoryState)
                        ? Icons.add
                        : (state is UpdatedTireCategoryState)
                            ? Icons.edit
                            : Icons.delete);
              } else if (state is TireCategoryError) {
                ToastHelper.showCustomToast(
                    context, state.message, Colors.red, Icons.error);
              }
            }, builder: (context, state) {
              if (state is TireCategoryLoading) {
                return Container(
                  padding: EdgeInsets.fromLTRB(0, 25.h, 0, 25.h),
                  child: shimmer(),
                );
              } else if (state is TireCategoryError) {
                return Center(child: Text(state.message));
              } else if (state is TireCategoryLoaded) {
                return ListView.builder(
                  padding: EdgeInsets.all(10.h),
                  itemCount: state.tirecategory.length,
                  itemBuilder: (context, index) {
                    final tire = state.tirecategory[index];
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
                          tire.category.toString(),
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Expense Date: ${tire.description}",
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
                                onPressed: () => {
                                      _showAddEditModal(context,
                                          tirecategory: tire)
                                    }),
                            ActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () => {
                                      _confirmDeleteTireCategory(
                                          context, tire.id!)
                                    })
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
