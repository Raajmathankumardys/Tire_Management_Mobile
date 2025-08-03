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
  TextEditingController type = TextEditingController();
  TextEditingController pressure = TextEditingController();
  TextEditingController tread = TextEditingController();
  TextEditingController temp = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController purchaseDate = TextEditingController();
  TextEditingController expectedLifespan = TextEditingController();
  String? status;
  late TireInventory? tire = widget.tire;
  late List<TireCategory> categories = [];

  String _formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(date);
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
    //print(tire!.toJson());
    if (tire != null) {
      serialNo.text = tire!.serialNumber;
      brand.text = tire!.brand;
      model.text = tire!.model;
      size.text = tire!.size;
      type.text = tire!.type;
      temp.text =
          tire!.temperature == null ? "0.0" : tire!.temperature!.toString();
      pressure.text =
          tire!.pressure == null ? "0.0" : tire!.pressure!.toString();
      tread.text =
          tire!.treadDepth == null ? "0.0" : tire!.treadDepth!.toString();
      purchaseDate.text = tire!.purchaseDate!;
      price.text = tire!.price.toString();
      //_purchaseDate = tire!.purchaseDate;
      expectedLifespan.text = tire!.expectedLifespan.toString();
      status = tire!.status.toString().split('.').last;
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
                              name: constants.dropdownfield,
                              label: "Status",
                              isDropdown: true,
                              defaultValue: status,
                              dropdownItems: const [
                                DropdownMenuItem(
                                    value: "IN_USE", child: Text("In Use")),
                                DropdownMenuItem(
                                    value: "IN_STOCK", child: Text("In Stock")),
                                DropdownMenuItem(
                                    value: "WORN_OUT", child: Text("Worn Out")),
                                DropdownMenuItem(
                                    value: "DAMAGED", child: Text("Damaged")),
                              ],
                              onDropdownChanged: (value) {
                                setState(() {
                                  status = value;
                                });
                              },
                              required: true,
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.serialno,
                              hint: tireinventoryconstants.serialnohint,
                              controller: serialNo,
                              required: true,
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.brand,
                              hint: tireinventoryconstants.brandhint,
                              controller: brand,
                              required: true,
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.model,
                              hint: tireinventoryconstants.modelhint,
                              controller: model,
                              required: true,
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: tireinventoryconstants.size,
                              hint: tireinventoryconstants.sizehint,
                              controller: size,
                              required: true,
                            ),
                            AppInputField(
                              name: constants.textfield,
                              label: "Type",
                              hint: "enter type",
                              controller: type,
                              required: true,
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: tireinventoryconstants.temperature,
                              hint: tireinventoryconstants.temperaturehint,
                              controller: temp,
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
                              controller: pressure,
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: "Tread Depth",
                              hint: "enter tread depth",
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d*$'))
                              ],
                              controller: tread,
                            ),
                            AppInputField(
                                name: constants.numberfield,
                                label: "Price",
                                hint: "enter price",
                                keyboardType: TextInputType.numberWithOptions(
                                    decimal: true),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'^\d*\.?\d*$'))
                                ],
                                controller: price,
                                required: true,
                                onInputChanged: (value) => price.text =
                                    '${int.tryParse(value ?? '0') ?? 0}'),
                            AppInputField(
                              name: constants.datefield,
                              label: tireinventoryconstants.purchasedate,
                              isDatePicker: true,
                              format: DateFormat('yyyy-MM-dd'),
                              controller:
                                  purchaseDate, // Ensure this is initialized
                              onDateSelected: (date) {
                                setState(() {
                                  purchaseDate.text = _formatDate(
                                      date!); // Update field with formatted date
                                });
                              },
                              required: true,
                            ),
                            AppInputField(
                              name: constants.numberfield,
                              label: "ExpectedLifeSpan",
                              hint: "enter expectedLifespan",
                              controller: expectedLifespan,
                              required: true,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              onInputChanged: (value) => expectedLifespan.text =
                                  '${int.tryParse(value ?? '0') ?? 0}',
                            ),
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
                                            serialNumber: serialNo.text,
                                            type: type.text,
                                            purchaseDate: purchaseDate
                                                .text, // Convert String to DateTime

                                            temperature:
                                                double.parse(temp.text),
                                            pressure:
                                                double.parse(pressure.text),
                                            treadDepth:
                                                double.parse(tread.text),
                                            price: double.parse(price.text),
                                            brand: brand.text,
                                            model: model.text,
                                            size: size.text,
                                            expectedLifespan: int.parse(
                                                expectedLifespan.text),
                                            status:
                                                TireStatus.values.firstWhere(
                                              (e) => e.name == status,
                                              orElse: () => TireStatus
                                                  .REPLACED, // default fallback
                                            ));
                                        print(t1.toJson());
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

                                        Navigator.pop(context);
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
