import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../commonScreen/Homepage.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/themes/app_colors.dart';
import '../../../../helpers/components/widgets/Card/customcard.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/action_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/tire_category_cubit.dart';
import '../../cubit/tire_category_state.dart';
import 'add_edit_tire_category.dart';

class Tire_Category_Screen extends StatefulWidget {
  const Tire_Category_Screen({super.key});
  @override
  State<Tire_Category_Screen> createState() => _Tire_Category_Screen_State();
}

class _Tire_Category_Screen_State extends State<Tire_Category_Screen> {
  Future<void> _showAddEditModalTireCategory(BuildContext ctx,
      {TireCategory? tirecategory}) async {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return AddEditTireCategoryModal(tireCategory: tirecategory, ctx: ctx);
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
    return Scaffold(
        backgroundColor: isdark ? Colors.grey.shade900 : Colors.white,
        appBar: AppBar(
          title: const Center(
              child: Text(tirecategoryconstants.appbar,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white))),
          backgroundColor:
              isdark ? Colors.grey.shade900 : AppColors.lightappbar,
          leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HomeScreen(
                            currentIndex: 1,
                          )));
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          ),
          actions: [
            IconButton(
                onPressed: () => {
                      _showAddEditModalTireCategory(context)
                      //_showAddEditModal(context)
                    },
                icon: Icon(Icons.add_circle, color: Colors.white))
          ],
        ),
        body: RefreshIndicator(
          child: BlocConsumer<TireCategoryCubit, TireCategoryState>(
              listener: (context, state) {
            print(state);
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
                child: const shimmer(),
              );
            } else if (state is TireCategoryError) {
              return Center(child: Text(state.message));
            } else if (state is TireCategoryLoaded) {
              return ListView.builder(
                itemCount: state.tirecategory.length,
                itemBuilder: (context, index) {
                  final tire = state.tirecategory[index];
                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                    child: CustomCard(
                      color: isdark ? Colors.black54 : Colors.grey.shade100,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.h, horizontal: 12.w),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10.h),
                              decoration: BoxDecoration(
                                color: (isdark
                                        ? AppColors.darkaddbtn
                                        : AppColors.lightaddbtn)
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                Icons.category_outlined,
                                size: 24.h,
                                color: isdark
                                    ? AppColors.darkaddbtn
                                    : AppColors.lightaddbtn,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    tire.category.toString(),
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "${tirecategoryconstants.decsription}: ${tire.description}",
                                    style: TextStyle(
                                      fontSize: 10.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Wrap(
                              spacing: 6.w,
                              children: [
                                ActionButton(
                                    icon: Icons.edit,
                                    color: Colors.green,
                                    onPressed: () {
                                      _showAddEditModalTireCategory(context,
                                          tirecategory: tire);
                                    }),
                                ActionButton(
                                  icon: Icons.delete_outline,
                                  color: Colors.red,
                                  onPressed: () async {
                                    await showDeleteConfirmationDialog(
                                      context: context,
                                      content:
                                          tirecategoryconstants.modaldelete,
                                      onConfirm: () {
                                        context
                                            .read<TireCategoryCubit>()
                                            .deleteTireCategory(tire, tire.id!);
                                      },
                                    );
                                  },
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return const Center(
                child: Text(tirecategoryconstants.nottirecategory));
          }),
          onRefresh: () async =>
              {context.read<TireCategoryCubit>().fetchTireCategory()},
          color: Colors.blueAccent,
        ));
  }
}
