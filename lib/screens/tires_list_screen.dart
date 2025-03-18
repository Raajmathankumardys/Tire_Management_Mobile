import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/config/themes/app_colors.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/trash/add_tire_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:yaantrac_app/common/widgets/button/action_button.dart';

import '../common/widgets/input/app_input_field.dart';
import 'Homepage.dart';

class TiresListScreen extends StatefulWidget {
  const TiresListScreen({super.key});

  @override
  State<TiresListScreen> createState() => _TiresListScreenState();
}

class _TiresListScreenState extends State<TiresListScreen> {
  late Future<List<TireModel>> futureTires;
  late TextEditingController brand;
  late TextEditingController model;
  late TextEditingController size;
  late TextEditingController stock;
  TireModel? tire;
  @override
  void initState() {
    futureTires = getTires();
    super.initState();
  }

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> _showAddEditModal({TireModel? tire}) async {
    final _formKey = GlobalKey<FormState>();
    String serialNo = tire?.serialNo ?? '';
    double temp = tire?.temp ?? 0;
    double psi = tire?.psi ?? 0.0;
    double dist = tire?.dist ?? 0.0;
    late DateTime purchaseDate = tire?.purchaseDate ?? DateTime.now();
    double purchaseCost = tire?.purchaseCost ?? 0.0;
    int warrantyPeriod = tire?.warrantyPeriod ?? 0;
    late DateTime warrantyExpiry = tire?.warrantyExpiry ?? DateTime.now();
    int categoryId = tire?.categoryId ?? 0;
    String location = tire?.location ?? '';
    String brand = tire?.brand ?? '';
    String model = tire?.model ?? '';
    String size = tire?.size ?? '';
    bool isLoading = false;
    final TextEditingController _purchaseDate = TextEditingController();
    _purchaseDate.text = _formatDate(purchaseDate);
    final TextEditingController _warrantyExpiry = TextEditingController();
    _warrantyExpiry.text = _formatDate(warrantyExpiry);
    late List<dynamic> categories = [];
    setState(() {
      isLoading = true;
    });
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

    setState(() {
      isLoading = false;
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5.h, // Starts at of screen height
          minChildSize: 0.4.h, // Minimum height
          maxChildSize: 0.60.h,
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
                                          label: "Serial No",
                                          hint: "Enter serial number",
                                          defaultValue: serialNo,
                                          onInputChanged: (value) =>
                                              serialNo = value ?? '',
                                        ),
                                        AppInputField(
                                          label: "Brand",
                                          hint: "Enter brand",
                                          defaultValue: brand,
                                          onInputChanged: (value) =>
                                              brand = value ?? '',
                                        ),
                                        AppInputField(
                                          label: "Model",
                                          hint: "Enter tire model",
                                          defaultValue: model,
                                          onInputChanged: (value) =>
                                              model = value ?? '',
                                        ),
                                        AppInputField(
                                          label: "Size",
                                          hint: "Enter size",
                                          defaultValue: size,
                                          onInputChanged: (value) =>
                                              size = value ?? '',
                                        ),
                                        AppInputField(
                                          label: "Location",
                                          hint: "Enter location",
                                          defaultValue: location,
                                          onInputChanged: (value) =>
                                              location = value ?? '',
                                        ),
                                        AppInputField(
                                          label: "Category",
                                          isDropdown: true,
                                          hint: categories
                                              .firstWhere(
                                                (category) =>
                                                    category["id"] ==
                                                    categoryId,
                                                orElse: () => {"category": ''},
                                              )["category"]
                                              .toString(),
                                          defaultValue: categories
                                              .firstWhere(
                                                (category) =>
                                                    category["id"] ==
                                                    categoryId,
                                                orElse: () =>
                                                    {"category": null},
                                              )["category"]
                                              .toString(), // Correct default value
                                          dropdownItems:
                                              categories.map((category) {
                                            return DropdownMenuItem<String>(
                                              value: category["id"].toString(),
                                              child: Text(category[
                                                  "category"]), // Show category name
                                            );
                                          }).toList(),
                                          onDropdownChanged: (value) {
                                            print(value);
                                            setState(() {
                                              categoryId =
                                                  int.parse(value ?? "0");
                                            });
                                          },
                                        ),
                                        AppInputField(
                                          label: "Temperature",
                                          hint: "Enter temperature",
                                          defaultValue: temp.toString(),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onInputChanged: (value) => temp =
                                              double.tryParse(value ?? '0') ??
                                                  0,
                                        ),
                                        AppInputField(
                                          label: "PSI",
                                          hint: "Enter PSI value",
                                          defaultValue: psi.toString(),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          onInputChanged: (value) => psi =
                                              double.tryParse(value ?? '0') ??
                                                  0.0,
                                        ),
                                        AppInputField(
                                          label: "Distance Traveled",
                                          hint: "Enter distance",
                                          defaultValue: dist.toString(),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          onInputChanged: (value) => dist =
                                              double.tryParse(value ?? '0') ??
                                                  0.0,
                                        ),
                                        AppInputField(
                                          label: "Purchase Cost",
                                          hint: "Enter purchase cost",
                                          defaultValue: purchaseCost.toString(),
                                          keyboardType:
                                              TextInputType.numberWithOptions(
                                                  decimal: true),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'^\d*\.?\d*$'))
                                          ],
                                          onInputChanged: (value) =>
                                              purchaseCost = double.tryParse(
                                                      value ?? '0') ??
                                                  0.0,
                                        ),
                                        AppInputField(
                                            label: "Purchase Date",
                                            isDatePicker: true,
                                            controller: _purchaseDate,
                                            onDateSelected: (date) {
                                              setState(() {
                                                purchaseDate = date;
                                                _purchaseDate.text = _formatDate(
                                                    date); // Update text in field
                                              });
                                            }),
                                        AppInputField(
                                          label: "Warranty Period (months)",
                                          hint: "Enter warranty period",
                                          defaultValue:
                                              warrantyPeriod.toString(),
                                          keyboardType: TextInputType.number,
                                          inputFormatters: [
                                            FilteringTextInputFormatter
                                                .digitsOnly
                                          ],
                                          onInputChanged: (value) =>
                                              warrantyPeriod =
                                                  int.tryParse(value ?? '0') ??
                                                      0,
                                        ),
                                        AppInputField(
                                            label: "Warranty Expiry Date",
                                            isDatePicker: true,
                                            controller: _warrantyExpiry,
                                            onDateSelected: (date) => {
                                                  setState(() {
                                                    warrantyExpiry = date;
                                                    _warrantyExpiry.text =
                                                        _formatDate(
                                                            date); // Update text in field
                                                  }),
                                                }),
                                        isLoading
                                            ? Center(
                                                child:
                                                    CircularProgressIndicator())
                                            : Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
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
                                                    onPressed: () async {
                                                      if (_formKey.currentState!
                                                          .validate()) {
                                                        setState(() =>
                                                            isLoading = true);
                                                        var t = {
                                                          "id": tire?.id,
                                                          "serialNo": serialNo,
                                                          "temp": temp,
                                                          "psi": psi,
                                                          "dist": dist,
                                                          "purchaseDate":
                                                              purchaseDate
                                                                  .toIso8601String(),
                                                          "purchaseCost":
                                                              purchaseCost,
                                                          "warrantyPeriod":
                                                              warrantyPeriod,
                                                          "warrantyExpiry":
                                                              warrantyExpiry
                                                                  .toIso8601String(),
                                                          "categoryId":
                                                              categoryId,
                                                          "location": location,
                                                          "brand": brand,
                                                          "model": model,
                                                          "size": size,
                                                        };
                                                        try {
                                                          final response =
                                                              await APIService
                                                                  .instance
                                                                  .request(
                                                            tire == null
                                                                ? "https://yaantrac-backend.onrender.com/api/tires"
                                                                : "https://yaantrac-backend.onrender.com/api/tires/${tire.id}",
                                                            tire == null
                                                                ? DioMethod.post
                                                                : DioMethod.put,
                                                            formData: t,
                                                            contentType:
                                                                "application/json",
                                                          );

                                                          if (response
                                                                  .statusCode ==
                                                              200) {
                                                            ToastHelper.showCustomToast(
                                                                context,
                                                                tire == null
                                                                    ? "Tire added successfully"
                                                                    : "Tire updated successfully",
                                                                Colors.green,
                                                                tire == null
                                                                    ? Icons.add
                                                                    : Icons
                                                                        .edit);

                                                            Navigator.pop(
                                                                context);
                                                            Navigator.of(
                                                                    context)
                                                                .pushAndRemoveUntil(
                                                              MaterialPageRoute(
                                                                  builder:
                                                                      (context) =>
                                                                          HomeScreen(
                                                                            currentIndex:
                                                                                1,
                                                                          )),
                                                              (route) => false,
                                                            );
                                                          }
                                                        } catch (err) {
                                                          ToastHelper
                                                              .showCustomToast(
                                                                  context,
                                                                  "Network error, please try again.",
                                                                  Colors.red,
                                                                  Icons.error);
                                                        } finally {
                                                          setState(() =>
                                                              isLoading =
                                                                  false);
                                                        }
                                                      }
                                                    },
                                                    title: tire == null
                                                        ? "Add Tire"
                                                        : "Update Tire",
                                                  ))
                                                ],
                                              ),
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

  Future<void> _confirmDelete(int tireId) async {
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
                      "Are you sure you want to delete this tire? This action cannot be undone.",
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
                          await _onDelete(tireId);
                          if (context.mounted) Navigator.pop(context);
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

  Future<void> _onDelete(int tireId) async {
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/tires/$tireId",
          DioMethod.delete,
          contentType: "application/json");
      if (response.statusCode == 200) {
        setState(() {
          futureTires = getTires();
        });

        ToastHelper.showCustomToast(
            context, "Tire Deleted Successfully", Colors.red, Icons.delete);
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  Future<List<TireModel>> getTires() async {
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> tireList = response.data['data'];
        print(tireList);
        return tireList.map((json) => TireModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
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
            Container(
              padding: EdgeInsets.all(4.w),
              alignment: Alignment.center,
              child: IconButton(
                  alignment: Alignment.topRight,
                  onPressed: () {
                    _showAddEditModal();
                  },
                  icon: Icon(
                    Icons.add_circle,
                    size: 25.h,
                    color: Colors.black,
                  )),
            )
          ],
          backgroundColor: isDarkMode ? Colors.black : AppColors.secondaryColor,
        ),
        body: FutureBuilder<List<TireModel>>(
          future: futureTires,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.blueAccent));
            } else if (snapshot.hasError) {
              return Center(
                  child: Text("Error: ${snapshot.error}",
                      style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.white)));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                  child: Text("No tires available",
                      style: TextStyle(
                          color:
                              isDarkMode ? Colors.grey[900] : Colors.white)));
            } else {
              List<TireModel> tires = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.all(10.h),
                itemCount: tires.length,
                itemBuilder: (context, index) {
                  final tire = tires[index];
                  return Card(
                    color: isDarkMode ? Colors.grey[800]! : Colors.white,
                    elevation: 2.w,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25.r)),
                    child: GestureDetector(
                      onTap: () {
                        if (tire.id != null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TireStatusScreen(
                                tire: tire,
                              ),
                            ),
                          );
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
                              color: isDarkMode ? Colors.white : Colors.black),
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
                                    {_showAddEditModal(tire: tire)}),
                            ActionButton(
                                icon: Icons.delete,
                                color: Colors.red,
                                onPressed: () =>
                                    _confirmDelete(tire.id!.toInt())),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
