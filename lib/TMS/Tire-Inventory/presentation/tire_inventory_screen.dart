import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Category/presentation/screen/tire_category_screen.dart';
import 'package:yaantrac_app/TMS/Tire-Expense/presentation/screen/tire_expense_screen.dart';
import 'package:yaantrac_app/TMS/Tire-Performance/presentation/screen/tire_performance_screen.dart';
import 'package:yaantrac_app/TMS/presentation/constants.dart';
import 'package:yaantrac_app/TMS/presentation/screen/tire_performance.dart';
import 'package:yaantrac_app/TMS/presentation/widget/shimmer.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:yaantrac_app/common/widgets/button/action_button.dart';
import '../../../common/widgets/input/app_input_field.dart';
import 'package:intl/intl.dart';
import '../../Tire-Category/cubit/tire_category_cubit.dart';
import '../../Tire-Category/repository/tire_category_repository.dart';
import '../../Tire-Category/service/tire_category_service.dart';
import '../../Tire-Expense/cubit/tire_expense_cubit.dart';
import '../../Tire-Expense/repository/tire_expense_repository.dart';
import '../../Tire-Expense/service/tire_expense_service.dart';
import '../../Tire-Performance/cubit/tire_performance_cubit.dart';
import '../../Tire-Performance/cubit/tire_performance_state.dart';
import '../../Tire-Performance/repository/tire_performance_repository.dart';
import '../../Tire-Performance/service/tire_performance_service.dart';
import '../../cubit/base_cubit.dart';
import '../../presentation/deleteDialog.dart';
import '../../repository/base_repository.dart';
import '../../service/base_service.dart';
import '../cubit/tire_inventory_cubit.dart';
import '../cubit/tire_inventory_state.dart';

class TireInventoryScreen extends StatefulWidget {
  const TireInventoryScreen({super.key});

  @override
  State<TireInventoryScreen> createState() => _TireInventoryScreenState();
}

class _TireInventoryScreenState extends State<TireInventoryScreen> {
  TireModel? tire;

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _showAddEditModal(BuildContext ctx,
      {TireInventory? tire}) async {
    final _formKey = GlobalKey<FormState>();
    TextEditingController serialNo = TextEditingController();
    TextEditingController brand = TextEditingController();
    TextEditingController model = TextEditingController();
    TextEditingController size = TextEditingController();
    TextEditingController location = TextEditingController();
    TextEditingController category = TextEditingController();
    TextEditingController psi = TextEditingController();
    TextEditingController dist = TextEditingController();
    TextEditingController temp = TextEditingController();
    TextEditingController purchasecost = TextEditingController();
    TextEditingController warrantyperiod = TextEditingController();
    TextEditingController purchaseDate = TextEditingController();
    TextEditingController warrantyExpiry = TextEditingController();
    DateTime? _purchaseDate = DateTime.now();
    DateTime? _warrantyExpiry = DateTime.now();
    final bool isdark = Theme.of(context).brightness == Brightness.dark;
    if (tire != null) {
      serialNo.text = tire.serialNo;
      brand.text = tire.brand;
      model.text = tire.model;
      size.text = tire.size;
      location.text = tire.location;
      category.text = tire.categoryId.toString();
      temp.text = tire.temp.toString();
      psi.text = tire.psi.toString();
      dist.text = tire.dist.toString();
      purchaseDate.text = _formatDate(tire.purchaseDate!);
      purchasecost.text = tire.purchaseCost.toString();
      warrantyExpiry.text = _formatDate(tire.warrantyExpiry!);
      _purchaseDate = tire.purchaseDate;
      _warrantyExpiry = tire.warrantyExpiry;
      warrantyperiod.text = tire.warrantyPeriod.toString();
      print(purchaseDate.text);
      print(warrantyExpiry.text);
    }
    late List<dynamic> categories = [];
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tire-categories",
        DioMethod.get,
        contentType: "application/json",
      );

      if (response.statusCode == 200) {
        setState(() {
          if (response.data is Map<String, dynamic> &&
              response.data.containsKey("data")) {
            categories = response.data["data"];
            setState(() {
              categories = response.data["data"];
              print(categories);
            });
          } else if (response.data is List) {
            categories = response.data;
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
      backgroundColor: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4.h, // Starts at of screen height
          minChildSize: 0.4.h, // Minimum height
          maxChildSize: 0.6.h,
          expand: false,
          builder: (context, scrollController) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  decoration: BoxDecoration(
                    color:
                        !isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(35.r)),
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                      ),
                      child: Column(
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
                                    borderRadius: BorderRadius.circular(20.h),
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  tire == null ? "Add Tire" : "Edit Tire",
                                  style: TextStyle(
                                    color: isdark
                                        ? AppColors.darkaddbtn
                                        : AppColors.lightaddbtn,
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                    padding: EdgeInsets.only(
                                      top: 20,
                                      left: 16,
                                      right: 16,
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom +
                                          16,
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        AppInputField(
                                          name: 'text_field',
                                          label: "Serial No",
                                          hint: "Enter serial number",
                                          controller: serialNo,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'text_field',
                                          label: "Brand",
                                          hint: "Enter brand",
                                          controller: brand,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'text_field',
                                          label: "Model",
                                          hint: "Enter tire model",
                                          controller: model,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'text_field',
                                          label: "Size",
                                          hint: "Enter size",
                                          controller: size,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'text_field',
                                          label: "Location",
                                          hint: "Enter location",
                                          controller: location,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'dropdown_field',
                                          label: "Category",
                                          isDropdown: true,
                                          controller: category,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                          hint: categories
                                              .firstWhere(
                                                (cat) =>
                                                    cat["id"].toString() ==
                                                    category
                                                        .text, // ✅ Use correct comparison
                                                orElse: () => {"category": ''},
                                              )["category"]
                                              .toString(),

                                          defaultValue: categories.any((cat) =>
                                                  cat["id"].toString() ==
                                                  category.text)
                                              ? category
                                                  .text // ✅ Ensure it exists in the dropdown
                                              : null, // ✅ Prevents null errors

                                          dropdownItems: categories.map((cat) {
                                            return DropdownMenuItem<String>(
                                              value: cat["id"].toString(),
                                              child: Text(cat[
                                                  "category"]), // ✅ Display category name
                                            );
                                          }).toList(),

                                          onDropdownChanged: (value) {
                                            if (value != null) {
                                              setState(() {
                                                category.text =
                                                    value; // ✅ Corrected value assignment
                                                print(value);
                                              });
                                            }
                                          },
                                        ),
                                        AppInputField(
                                          name: 'number_field',
                                          label: "Temperature",
                                          hint: "Enter temperature",
                                          controller: temp,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                        ),
                                        AppInputField(
                                          name: 'number_field',
                                          label: "PSI",
                                          hint: "Enter PSI value",
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          controller: psi,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'number_field',
                                          label: "Distance Traveled",
                                          hint: "Enter distance",
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          controller: dist,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'number_field',
                                          label: "Purchase Cost",
                                          hint: "Enter purchase cost",
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          controller: purchasecost,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                        ),
                                        AppInputField(
                                          name: 'date_field',
                                          label: "Purchase Date",
                                          isDatePicker: true,
                                          controller:
                                              purchaseDate, // Ensure this is initialized
                                          onDateSelected: (date) {
                                            setState(() {
                                              _purchaseDate = date;
                                              purchaseDate.text = _formatDate(
                                                  date!); // Update field with formatted date
                                            });
                                          },
                                        ),
                                        AppInputField(
                                          name: 'number_field',
                                          label: "Warranty Period (months)",
                                          hint: "Enter warranty period",
                                          controller: warrantyperiod,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'This field is required';
                                            }
                                            return null;
                                          },
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onInputChanged: (value) => warrantyperiod
                                                  .text =
                                              '${int.tryParse(value ?? '0') ?? 0}',
                                        ),
                                        AppInputField(
                                            name: 'date_field',
                                            label: "Warranty Expiry Date",
                                            isDatePicker: true,
                                            controller: warrantyExpiry,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'This field is required';
                                              }
                                              return null;
                                            },
                                            onDateSelected: (date) => {
                                                  setState(() {
                                                    _warrantyExpiry = date!;
                                                    warrantyExpiry.text =
                                                        _formatDate(
                                                            date); // Update text in field
                                                  }),
                                                }),
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Expanded(
                                                  child: AppPrimaryButton(
                                                      onPressed: () => {
                                                            Navigator.pop(
                                                                context)
                                                          },
                                                      title: "Cancel")),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Expanded(
                                                  child: AppPrimaryButton(
                                                width: 150,
                                                onPressed: () {
                                                  if (_formKey.currentState!
                                                      .validate()) {
                                                    TireInventory t1 =
                                                        TireInventory(
                                                            id: tire?.id,
                                                            serialNo:
                                                                serialNo.text,
                                                            purchaseDate:
                                                                _purchaseDate, // Convert String to DateTime
                                                            warrantyExpiry:
                                                                _warrantyExpiry,
                                                            temp: double.parse(
                                                                temp.text),
                                                            psi: double.parse(
                                                                psi.text),
                                                            dist: double.parse(
                                                                dist.text),
                                                            purchaseCost:
                                                                double.parse(
                                                                    purchasecost
                                                                        .text),
                                                            warrantyPeriod:
                                                                int.parse(
                                                                    warrantyperiod
                                                                        .text),
                                                            categoryId:
                                                                int.parse(
                                                                    category
                                                                        .text),
                                                            location:
                                                                location.text,
                                                            brand: brand.text,
                                                            model: model.text,
                                                            size: size.text);
                                                    print(t1.toJson());

                                                    tire == null
                                                        ? ctx
                                                            .read<
                                                                TireInventoryCubit>()
                                                            .addTireInventory(
                                                                t1)
                                                        : ctx
                                                            .read<
                                                                TireInventoryCubit>()
                                                            .updateTireInventory(
                                                                t1);
                                                    Navigator.pop(context);
                                                  }
                                                },
                                                title: tire == null
                                                    ? "Add"
                                                    : "Update",
                                              ))
                                            ])
                                      ],
                                    ))
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
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
        appBar: AppBar(
          title: Text(tireinventoryconstants.appbar,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              )),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
                color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
              )),
          elevation: 2.w,
          actions: [
            IconButton(
                alignment: Alignment.topRight,
                color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => TireCategoryCubit(
                          TireCategoryRepository(
                            TireCategoryService(),
                          ),
                        )..fetchTireCategory(),
                        child: Tire_Category_Screen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.category,
                  size: 25.h,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                )),
            IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => TireExpenseCubit(
                          TireExpenseRepository(
                            TireExpenseService(),
                          ),
                        )..fetchTireExpense(),
                        child: Tire_Expense_Screen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.currency_exchange,
                  size: 25.h,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                )),
            IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  _showAddEditModal(context);
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 25.h,
                  color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
                )),
          ],
          backgroundColor:
              isdark ? AppColors.darkappbar : AppColors.lightappbar,
        ),
        body: BlocConsumer<TireInventoryCubit, TireInventoryState>(
            listener: (context, state) {
          if (state is AddedTireInventoryState ||
              state is UpdatedTireInventoryState ||
              state is DeletedTireInventoryState) {
            final message = (state as dynamic).message;
            ToastHelper.showCustomToast(
                context,
                message,
                Colors.green,
                (state is AddedTireInventoryState)
                    ? Icons.add
                    : (state is UpdatedTireInventoryState)
                        ? Icons.edit
                        : Icons.delete);
          } else if (state is TireInventoryError) {
            ToastHelper.showCustomToast(
                context, state.message, Colors.red, Icons.error);
          }
        }, builder: (context, state) {
          if (state is TireInventoryLoading) {
            return shimmer();
          } else if (state is TireInventoryError) {
            return Center(child: Text(state.message));
          } else if (state is TireInventoryLoaded) {
            return ListView.builder(
              padding: EdgeInsets.all(10.h),
              itemCount: state.tireinventory.length,
              itemBuilder: (context, index) {
                final tire = state.tireinventory[index];
                return Card(
                  elevation: 2.w,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25.r)),
                  child: GestureDetector(
                    onTap: () {
                      if (tire.id != null) {
                        print("Navigating to tire ID: ${tire.id}");
                        var t = tire.id!;

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                  create: (context) => TirePerformanceCubit(
                                        TirePerformanceRepository(
                                          TirePerformanceService(),
                                        ),
                                      )..fetchTirePerformance(t),
                                  child: Tire_Performance_Screen(tire: tire)),
                            ));
                        /*Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TirePerformanceScreen(tire: tire)));
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider.value(
                              value: context.read<
                                  BaseCubit<
                                      TirePerformanceModel>>(), // Reuse existing Cubit
                              child: TirePerformanceScreen(tire: tire),
                            ),
                          ),
                        );*/
                      } else {
                        ToastHelper.showCustomToast(context, "Tire not found",
                            Colors.yellow, Icons.warning_amber);
                      }
                    },
                    child: ListTile(
                      contentPadding: EdgeInsets.all(10.h),
                      leading: SvgPicture.asset(
                        "assets/vectors/tire.svg",
                        height: 35.h,
                        color: isdark
                            ? AppColors.darkaddbtn
                            : AppColors.lightaddbtn,
                      ),
                      title: Text(
                        tire.brand,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Model: ${tire.model}",
                              style: TextStyle(
                                  color: Colors.grey[400], fontSize: 10.sp)),
                          Text("Size: ${tire.size}",
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
                                  {_showAddEditModal(context, tire: tire)}),
                          ActionButton(
                              icon: Icons.delete,
                              color: Colors.red,
                              onPressed: () async => {
                                    await showDeleteConfirmationDialog(
                                      context: context,
                                      content:
                                          "Are you sure you want to delete this tire inventory?",
                                      onConfirm: () {
                                        context
                                            .read<TireInventoryCubit>()
                                            .deleteTireInventory(tire.id!);
                                      },
                                    )
                                  }),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return Center(child: Text("No Tires available"));
        }));
  }
}
