import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yaantrac_app/TMS/Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../../../helpers/components/widgets/Add_Edit_Modal/add_edit_modal_top.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/input/app_input_field.dart';
import '../../../../helpers/constants.dart';
import '../../cubit/tire_performance_cubit.dart';
import '../../cubit/tire_performance_state.dart';

class add_edit_modal_tire_performance extends StatefulWidget {
  //final TireInventory tire;
  final BuildContext ctx;
  final int? tireId;
  add_edit_modal_tire_performance({super.key, required this.ctx, this.tireId});

  @override
  State<add_edit_modal_tire_performance> createState() =>
      _add_edit_modal_tire_performanceState();
}

class _add_edit_modal_tire_performanceState
    extends State<add_edit_modal_tire_performance> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController pressure = TextEditingController();
  TextEditingController temperature = TextEditingController();
  TextEditingController wear = TextEditingController();
  TextEditingController treadDepth = TextEditingController();
  TextEditingController dist = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(35.r)),
      ),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical, // Attach the scroll controller
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  add_edit_modal_top(title: tireperformancesconstants.addtirep),
                  Padding(
                      padding: EdgeInsets.only(
                        left: 12.w,
                        right: 12.w,
                        bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
                        top: 12.h,
                      ),
                      child: Column(
                        children: [
                          AppInputField(
                              name: constants.numberfield,
                              label: tireperformancesconstants.pressure,
                              hint: tireperformancesconstants.pressurehint,
                              keyboardType: TextInputType.number,
                              controller: pressure,
                              required: true),
                          AppInputField(
                              name: constants.numberfield,
                              label: tireperformancesconstants.temperature,
                              hint: tireperformancesconstants.temperaturehint,
                              keyboardType: TextInputType.number,
                              controller: temperature,
                              required: true),
                          AppInputField(
                              name: constants.numberfield,
                              label: tireperformancesconstants.wear,
                              hint: tireperformancesconstants.wearhint,
                              keyboardType: TextInputType.number,
                              controller: wear,
                              required: true),
                          AppInputField(
                              name: constants.numberfield,
                              label: tireperformancesconstants.distance,
                              hint: tireperformancesconstants.distancehint,
                              keyboardType: TextInputType.number,
                              controller: dist,
                              required: true),
                          AppInputField(
                              name: constants.numberfield,
                              label: tireperformancesconstants.treaddepth,
                              hint: tireperformancesconstants.treaddepthhint,
                              keyboardType: TextInputType.number,
                              controller: treadDepth,
                              required: true),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                  child: AppPrimaryButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      title: constants.cancel)),
                              SizedBox(
                                width: 10.h,
                              ),
                              Expanded(
                                  child: AppPrimaryButton(
                                      width: 130.h,
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          final tirep = TirePerformance(
                                              tireId: widget.tireId,
                                              pressure:
                                                  double.parse(pressure.text),
                                              temperature: double.parse(
                                                  temperature.text),
                                              wear: double.parse(wear.text),
                                              distanceTraveled:
                                                  double.parse(dist.text),
                                              treadDepth: double.parse(
                                                  treadDepth.text));
                                          widget.ctx
                                              .read<TirePerformanceCubit>()
                                              .addTirePerformance(tirep);
                                          Navigator.pop(context);
                                        }
                                      },
                                      title: constants.save))
                            ],
                          ),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
