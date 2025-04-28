import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../../Tire-Category/cubit/tire_category_cubit.dart';
import '../../../Tire-Category/cubit/tire_category_state.dart';
import '../../cubit/tire_inventory_cubit.dart';
import '../../cubit/tire_inventory_state.dart';

class add_edit_modal_tire_inventory extends StatefulWidget {
  final TireInventory? tire;
  final BuildContext ctx;
  const add_edit_modal_tire_inventory(
      {super.key, this.tire, required this.ctx});

  @override
  State<add_edit_modal_tire_inventory> createState() =>
      _add_edit_modal_tire_inventoryState();
}

class _add_edit_modal_tire_inventoryState
    extends State<add_edit_modal_tire_inventory> {
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
  late TireInventory? tire = widget.tire;
  late List<TireCategory> categories = [];

  String _formatDate(DateTime date) {
    return DateFormat('dd-MM-yyyy').format(date);
  }

  void _waitForTireCategories() async {
    while (true) {
      final state = context.read<TireCategoryCubit>().state;
      if (state is TireCategoryLoaded) {
        setState(() {
          categories = state.tirecategory;
        });
        break;
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _waitForTireCategories();
    if (tire != null) {
      serialNo.text = tire!.serialNo;
      brand.text = tire!.brand;
      model.text = tire!.model;
      size.text = tire!.size;
      location.text = tire!.location;
      category.text = tire!.categoryId.toString();
      temp.text = tire!.temp.toString();
      psi.text = tire!.psi.toString();
      dist.text = tire!.dist.toString();
      purchaseDate.text = _formatDate(tire!.purchaseDate!);
      purchasecost.text = tire!.purchaseCost.toString();
      warrantyExpiry.text = _formatDate(tire!.warrantyExpiry!);
      _purchaseDate = tire!.purchaseDate;
      _warrantyExpiry = tire!.warrantyExpiry;
      warrantyperiod.text = tire!.warrantyPeriod.toString();
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
          ),
          child: Column(
            children: [
              add_edit_modal_top(
                title: tire == null
                    ? tireinventoryconstants.addtire
                    : tireinventoryconstants.edittire,
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
                          bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.serialno,
                              hint: tireinventoryconstants.serialnohint,
                              controller: serialNo,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.brand,
                              hint: tireinventoryconstants.brandhint,
                              controller: brand,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.model,
                              hint: tireinventoryconstants.modelhint,
                              controller: model,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.size,
                              hint: tireinventoryconstants.sizehint,
                              controller: size,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.location,
                              hint: tireinventoryconstants.locationhint,
                              controller: location,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.dropdownfield,
                              label: tireinventoryconstants.category,
                              isDropdown: true,
                              controller: category,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                              defaultValue: categories.any((cat) =>
                                      cat.id.toString() == category.text)
                                  ? category
                                      .text // ✅ Ensure it exists in the dropdown
                                  : null, // ✅ Prevents null errors

                              dropdownItems: categories.map((cat) {
                                return DropdownMenuItem<String>(
                                  value: cat.id.toString(),
                                  child: Text(cat.category.toString()),
                                );
                              }).toList(),

                              onDropdownChanged: (value) {
                                if (value != null) {
                                  setState(() {
                                    category.text = value;
                                  });
                                }
                              },
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: tireinventoryconstants.temperature,
                              hint: tireinventoryconstants.temperaturehint,
                              controller: temp,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
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
                              name: constants.numberfield,
                              label: tireinventoryconstants.pressure,
                              hint: tireinventoryconstants.pressurehint,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'))
                              ],
                              controller: psi,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: tireinventoryconstants.distance,
                              hint: tireinventoryconstants.distancehint,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'))
                              ],
                              controller: dist,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: tireinventoryconstants.purchasecost,
                              hint: tireinventoryconstants.purchasecosthint,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'))
                              ],
                              controller: purchasecost,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                            ),
                            AppInputField(
                              name: constants.datefield,
                              label: tireinventoryconstants.purchasedate,
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
                              name: constants.numberfield,
                              label: tireinventoryconstants.warrantyperiod,
                              hint: tireinventoryconstants.warrantyperiodhint,
                              controller: warrantyperiod,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return constants.required;
                                }
                                return null;
                              },
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onInputChanged: (value) => warrantyperiod.text =
                                  '${int.tryParse(value ?? '0') ?? 0}',
                            ),
                            AppInputField(
                                name: constants.datefield,
                                label: tireinventoryconstants.warrantyexpiry,
                                isDatePicker: true,
                                controller: warrantyExpiry,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return constants.required;
                                  }
                                  return null;
                                },
                                onDateSelected: (date) => {
                                      setState(() {
                                        _warrantyExpiry = date!;
                                        warrantyExpiry.text = _formatDate(
                                            date); // Update text in field
                                      }),
                                    }),
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      child: AppPrimaryButton(
                                          onPressed: () =>
                                              {Navigator.pop(context)},
                                          title: constants.cancel)),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                      child: AppPrimaryButton(
                                    width: 150,
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        TireInventory t1 = TireInventory(
                                            id: tire?.id,
                                            serialNo: serialNo.text,
                                            purchaseDate:
                                                _purchaseDate, // Convert String to DateTime
                                            warrantyExpiry: _warrantyExpiry,
                                            temp: double.parse(temp.text),
                                            psi: double.parse(psi.text),
                                            dist: double.parse(dist.text),
                                            purchaseCost:
                                                double.parse(purchasecost.text),
                                            warrantyPeriod:
                                                int.parse(warrantyperiod.text),
                                            categoryId:
                                                int.parse(category.text),
                                            location: location.text,
                                            brand: brand.text,
                                            model: model.text,
                                            size: size.text);
                                        tire == null
                                            ? widget.ctx
                                                .read<TireInventoryCubit>()
                                                .addTireInventory(t1)
                                            : widget.ctx
                                                .read<TireInventoryCubit>()
                                                .updateTireInventory(t1);
                                        final state = context
                                            .read<TireInventoryCubit>()
                                            .state;
                                        print(state);
                                        if (state is TireInventoryError) {
                                          ToastHelper.showCustomToast(
                                              context,
                                              state.message,
                                              Colors.red,
                                              Icons.error);
                                        } else {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                                    title: tire == null
                                        ? constants.save
                                        : constants.update,
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
  }
}
