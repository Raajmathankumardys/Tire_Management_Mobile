import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Category/cubit/tire_category_state.dart';
import 'package:yaantrac_app/TMS/presentation/deleteDialog.dart';
import 'package:yaantrac_app/screens/Homepage.dart';
import '../../../../common/widgets/Toast/Toast.dart';
import '../../../../common/widgets/button/action_button.dart';
import '../../../../common/widgets/button/app_primary_button.dart';
import '../../../../common/widgets/input/app_input_field.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../presentation/constants.dart';
import '../../../presentation/widget/shimmer.dart';
import '../../cubit/tire_category_cubit.dart';

class Tire_Category_Screen extends StatefulWidget {
  const Tire_Category_Screen({super.key});
  @override
  State<Tire_Category_Screen> createState() => _Tire_Category_Screen_State();
}

class _Tire_Category_Screen_State extends State<Tire_Category_Screen> {
  Future<void> _showAddEditModal(BuildContext ctx,
      {TireCategory? tirecategory}) async {
    final _formKey = GlobalKey<FormState>();
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
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
      backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
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
                                ? tirecategoryconstants.addtirecategory
                                : tirecategoryconstants.edittirecategory,
                            style: TextStyle(
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
                            name: constants.textfield,
                            label: tirecategoryconstants.category,
                            hint: tirecategoryconstants.categoryhint,
                            controller: categoryController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: tirecategoryconstants.decsription,
                            hint: tirecategoryconstants.descriptionhint,
                            controller: descriptionontroller,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
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
                                title: constants.cancel,
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
                                title: tirecategory == null
                                    ? constants.save
                                    : constants.update,
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

  Future<void> showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback onConfirm,
    required content,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => DeleteConfirmationDialog(
        onConfirm: onConfirm,
        content: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Center(
                  child: Text(tirecategoryconstants.appbar,
                      style: TextStyle(fontWeight: FontWeight.bold))),
              backgroundColor:
                  isdark ? AppColors.darkappbar : AppColors.lightappbar,
              leading: IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomeScreen(
                                currentIndex: 1,
                              )));
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                ),
              ),
              actions: [
                IconButton(
                    onPressed: () => {_showAddEditModal(context)},
                    icon: Icon(
                      Icons.add_circle,
                      color:
                          isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
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
                  padding: EdgeInsets.fromLTRB(0, 20.h, 0, 20.h),
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
                      elevation: 2.w,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r)),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(10.h),
                        leading: Icon(
                          Icons.currency_exchange,
                          size: 30.h,
                          color: isdark
                              ? AppColors.darkaddbtn
                              : AppColors.lightaddbtn,
                        ),
                        title: Text(
                          tire.category.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "${tirecategoryconstants.decsription} : ${tire.description}",
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
                                onPressed: () async => {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content:
                                            tirecategoryconstants.modaldelete,
                                        onConfirm: () {
                                          context
                                              .read<TireCategoryCubit>()
                                              .deleteTireCategory(tire.id!);
                                        },
                                      )
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
