import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/TMS/presentation/screen/tire_performance.dart';
import 'package:yaantrac_app/TMS/presentation/screen/tireexpense_screen.dart';
import 'package:yaantrac_app/TMS/presentation/widget/shimmer.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/models/tire_expense.dart';
import 'package:yaantrac_app/models/tire_performance.dart';
import 'package:yaantrac_app/screens/tiremapping.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:yaantrac_app/common/widgets/button/action_button.dart';

import '../../../common/widgets/input/app_input_field.dart';

import '../../cubit/base_cubit.dart';
import '../../cubit/base_state.dart';
import 'package:intl/intl.dart';

import '../../repository/base_repository.dart';
import '../../service/base_service.dart';

class tirelistscreen extends StatefulWidget {
  const tirelistscreen({super.key});

  @override
  State<tirelistscreen> createState() => _TiresListScreenState();
}

class _TiresListScreenState extends State<tirelistscreen> {
  TireModel? tire;

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  Future<void> _showAddEditModal(BuildContext ctx, {TireModel? tire}) async {
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
                    color: Colors.white,
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
                                    color: Colors.white,
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
                                                    TireModel t1 = TireModel(
                                                        id: tire?.id,
                                                        serialNo: serialNo.text,
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
                                                        categoryId: int.parse(
                                                            category.text),
                                                        location: location.text,
                                                        brand: brand.text,
                                                        model: model.text,
                                                        size: size.text);
                                                    print(t1.toJson());

                                                    tire == null
                                                        ? ctx
                                                            .read<
                                                                BaseCubit<
                                                                    TireModel>>()
                                                            .addItem(t1)
                                                        : ctx
                                                            .read<
                                                                BaseCubit<
                                                                    TireModel>>()
                                                            .updateItem(
                                                                t1, t1.id!);
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

  Future<void> _confirmDelete(BuildContext ctx, int tireId) async {
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
                "Are you sure you want to delete this tire? This action cannot be undone.",
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
                    ctx.read<BaseCubit<TireModel>>().deleteItem(tireId);

                    Navigator.pop(context);
                  },
                  child: Text(
                    "Delete",
                    style: TextStyle(color: Colors.grey),
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tires",
              style: TextStyle(fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.arrow_back_ios,
              )),
          elevation: 2.w,
          actions: [
            IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => BaseCubit<Tireexpense>(
                          BaseRepository<Tireexpense>(
                            BaseService<Tireexpense>(
                              baseUrl: "/tire-expenses",
                              fromJson: Tireexpense.fromJson,
                              toJson: (tireexpense) => tireexpense.toJson(),
                            ),
                          ),
                        )..fetchItems(),
                        child: tire_expense_screen(),
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.currency_exchange,
                  size: 25.h,
                  color: Colors.black,
                )),
            IconButton(
                alignment: Alignment.topRight,
                onPressed: () {
                  _showAddEditModal(context);
                },
                icon: Icon(
                  Icons.add_circle,
                  size: 25.h,
                  color: Colors.black,
                )),
          ],
          backgroundColor: AppColors.secondaryColor,
        ),
        body: BlocConsumer<BaseCubit<TireModel>, BaseState<TireModel>>(
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
          } else if (state is ApiErrorState<TireModel>) {
            ToastHelper.showCustomToast(
                context, state.message, Colors.red, Icons.error);
          }
        }, builder: (context, state) {
          if (state is LoadingState<TireModel>) {
            return shimmer();
          } else if (state is ErrorState<TireModel>) {
            return Center(child: Text(state.message));
          } else if (state is LoadedState<TireModel>) {
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
                  child: GestureDetector(
                    onTap: () {
                      if (tire.id != null) {
                        print("Navigating to tire ID: ${tire.id}");
                        var t = tire.id!;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlocProvider(
                              create: (context) =>
                                  BaseCubit<TirePerformanceModel>(
                                BaseRepository<TirePerformanceModel>(
                                  BaseService<TirePerformanceModel>(
                                    baseUrl: "",
                                    fromJson: TirePerformanceModel.fromJson,
                                    toJson: (tire) => tire.toJson(),
                                  ),
                                ),
                              )..fetchPerformance('/tires/$t/performances'),
                              child: TirePerformanceScreen(tire: tire),
                            ),
                          ),
                        );
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
                      ),
                      title: Text(
                        tire.brand,
                        style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
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
                              onPressed: () =>
                                  _confirmDelete(context, tire.id!.toInt())),
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
