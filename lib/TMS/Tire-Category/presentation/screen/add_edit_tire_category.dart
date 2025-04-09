import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../helpers/constants.dart';
import '../../cubit/tire_category_cubit.dart';
import '../../cubit/tire_category_state.dart';

class AddEditTireCategoryModal extends StatefulWidget {
  final TireCategory? tireCategory;
  final BuildContext ctx;
  const AddEditTireCategoryModal(
      {super.key, this.tireCategory, required this.ctx});

  @override
  State<AddEditTireCategoryModal> createState() =>
      _AddEditTireCategoryModalState();
}

class _AddEditTireCategoryModalState extends State<AddEditTireCategoryModal> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController categoryController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    categoryController =
        TextEditingController(text: widget.tireCategory?.category ?? '');
    descriptionController =
        TextEditingController(text: widget.tireCategory?.description ?? '');
  }

  @override
  void dispose() {
    categoryController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              add_edit_modal_top(
                  title: widget.tireCategory == null
                      ? tirecategoryconstants.addtirecategory
                      : tirecategoryconstants.edittirecategory),

              // Form Inputs
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                      controller: descriptionController,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return constants.required;
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10.h),
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
                                  id: widget.tireCategory?.id,
                                  category: categoryController.text,
                                  description: descriptionController.text);

                              if (widget.tireCategory == null) {
                                widget.ctx
                                    .read<TireCategoryCubit>()
                                    .addTireCategory(newtirecategory);
                              } else {
                                widget.ctx
                                    .read<TireCategoryCubit>()
                                    .updateTireCategory(newtirecategory);
                              }
                              Navigator.pop(context);
                            }
                          },
                          title: widget.tireCategory == null
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
  }
}
