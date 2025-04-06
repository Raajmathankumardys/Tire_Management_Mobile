import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yaantrac_app/TMS/Vehicle/presentation/widget/vehiclewidget.dart';
import 'package:yaantrac_app/TMS/presentation/constants.dart';
import '../../../../common/widgets/Toast/Toast.dart';
import '../../../../common/widgets/button/app_primary_button.dart';
import '../../../../common/widgets/input/app_input_field.dart';
import '../../../../config/themes/app_colors.dart';
import '../../../../screens/tiremapping.dart';
import '../../../presentation/customcard.dart';
import '../../../presentation/deleteDialog.dart';
import '../../../presentation/widget/shimmer.dart';
import '../../cubit/vehicle_cubit.dart';
import '../../cubit/vehicle_state.dart';

class vehiclescreen extends StatefulWidget {
  const vehiclescreen({super.key});
  @override
  State<vehiclescreen> createState() => _vehiclelistscreen_State();
}

class _vehiclelistscreen_State extends State<vehiclescreen> {
  late Future<List<Vehicle>> futureVehicles;
  late int vehicleId;
  void _showAddEditModal(BuildContext ctx, [Vehicle? vehicle]) {
    final _formKey = GlobalKey<FormState>();

    // Initialize controllers
    TextEditingController nameController = TextEditingController();
    TextEditingController typeController = TextEditingController();
    TextEditingController licensePlateController = TextEditingController();
    TextEditingController yearController = TextEditingController();
    TextEditingController axleNoController = TextEditingController();
    bool isdark = Theme.of(context).brightness == Brightness.dark;
    // Prefill values if editing an existing vehicle
    if (vehicle != null) {
      nameController.text = vehicle.name;
      typeController.text = vehicle.type;
      licensePlateController.text = vehicle.licensePlate;
      yearController.text = vehicle.manufactureYear.toString();
      axleNoController.text = vehicle.axleNo.toString();
    }

    showModalBottomSheet(
      context: ctx,
      isScrollControlled: true,
      backgroundColor: isdark ? Colors.black : Colors.white,
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
                            width: 70.h,
                            height: 5.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            vehicle == null
                                ? vehicleconstants.addvehicle
                                : vehicleconstants.editvehicle,
                            style: TextStyle(
                              fontSize: 12.h,
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
                            label: vehicleconstants.name,
                            hint: vehicleconstants.namehint,
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              }
                              if (value.length < 3) {
                                return vehicleconstants.namevalidation;
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: vehicleconstants.type,
                            hint: vehicleconstants.typehint,
                            controller: typeController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              }
                              if (value.length < 2) {
                                return vehicleconstants.typevalidation;
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: constants.textfield,
                            label: vehicleconstants.licenseplate,
                            hint: vehicleconstants.licenseplatehint,
                            controller: licensePlateController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              }
                              // Regular expression for alphanumeric license plate (6-10 chars)
                              final licensePlatePattern = RegExp(
                                  vehicleconstants.licenseplateregex,
                                  caseSensitive: false);
                              if (!licensePlatePattern.hasMatch(value)) {
                                return vehicleconstants.licenseplatevalidation;
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: constants.numberfield,
                            label: vehicleconstants.manufactureyear,
                            hint: vehicleconstants.manufactureyearhint,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: yearController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              } else if (int.parse(value) <= 1900 ||
                                  int.parse(value) >
                                      (DateTime.now().year).toInt()) {
                                return vehicleconstants
                                    .manufactureyearvalidation;
                              }
                              return null;
                            },
                          ),
                          AppInputField(
                            name: constants.numberfield,
                            label: vehicleconstants.axleno,
                            hint: vehicleconstants.axlenohint,
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: axleNoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return constants.required;
                              } else if (int.parse(value) < 2) {
                                return vehicleconstants.axlenovalidation;
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
                                    final newVehicle = Vehicle(
                                      id: vehicle?.id,
                                      name: nameController.text,
                                      licensePlate: licensePlateController.text,
                                      manufactureYear:
                                          int.parse(yearController.text),
                                      type: typeController.text,
                                      axleNo: int.parse(axleNoController.text),
                                    );

                                    if (vehicle == null) {
                                      ctx
                                          .read<VehicleCubit>()
                                          .addVehicle(newVehicle);
                                    } else {
                                      ctx
                                          .read<VehicleCubit>()
                                          .updateVehicle(newVehicle);
                                    }
                                    Navigator.pop(context);
                                  }
                                },
                                title: vehicle == null
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
    return Scaffold(
      appBar: AppBar(
        title: Center(
            child: Text(vehicleconstants.appbar,
                style: TextStyle(fontWeight: FontWeight.bold))),
        backgroundColor: isdark ? AppColors.darkappbar : AppColors.lightappbar,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
            )),
        actions: [
          IconButton(
              onPressed: () => {_showAddEditModal(context)},
              icon: Icon(
                Icons.add_circle,
                color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
              ))
        ],
      ),
      body: BlocConsumer<VehicleCubit, VehicleState>(
        listener: (context, state) {
          if (state is AddedVehicleState ||
              state is UpdatedVehicleState ||
              state is DeletedVehicleState) {
            final message = (state as dynamic).message;
            String updatedMessage = message.toString();
            ToastHelper.showCustomToast(
                context,
                updatedMessage,
                Colors.green,
                (state is AddedVehicleState)
                    ? Icons.add
                    : (state is UpdatedVehicleState)
                        ? Icons.edit
                        : Icons.delete);
          } else if (state is VehicleError) {
            String updatedMessage = state.message.toString();
            ToastHelper.showCustomToast(
                context, updatedMessage, Colors.red, Icons.error);
          }
        },
        builder: (context, state) {
          if (state is VehicleLoading) {
            return shimmer();
          } else if (state is VehicleError) {
            String updatedMessage = state.message.toString();
            return Center(child: Text(updatedMessage));
          } else if (state is VehicleLoaded) {
            return ListView.builder(
              itemCount: state.vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = state.vehicles[index];
                return CustomCard(
                  child: ExpansionTile(
                    tilePadding: EdgeInsets.all(2.h),
                    onExpansionChanged: (value) {
                      setState(() {
                        vehicleId = vehicle.id!;
                      });
                    },
                    title: vehiclewidget(vehicle: vehicle),
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AxleAnimationPage(
                                                vehicleid: vehicle.id!,
                                              )));
                                },
                                icon: Icon(
                                  Icons.tire_repair_outlined,
                                  color: Colors.grey,
                                  size: 20.h,
                                )),
                            IconButton(
                              onPressed: () {
                                /*Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                       builder: (context) => tripslistscreen(
                                              vehicleid: vehicle.id!,
                                            )));*/
                                /*Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider(
                                      create: (context) => BaseCubit<Trip>(
                                        BaseRepository<Trip>(
                                          BaseService<Trip>(
                                            baseUrl:
                                                "/vehicles/${vehicle.id!}/trips",
                                            fromJson: Trip.fromJson,
                                            toJson: (trip) => trip.toJson(),
                                          ),
                                        ),
                                      )..fetchItems(),
                                      child: tripslistscreen(
                                          vehicleid: vehicle.id!),
                                    ),
                                  ),
                                );*/
                              },
                              icon: Icon(Icons.tour),
                              color: Colors.cyanAccent,
                              iconSize: 20.h,
                            ),
                            IconButton(
                              onPressed: () {
                                _showAddEditModal(context, vehicle);
                              },
                              icon: const FaIcon(Icons.edit),
                              color: Colors.green,
                              iconSize: 20.h,
                            ),
                            IconButton(
                                onPressed: () async => {
                                      await showDeleteConfirmationDialog(
                                        context: context,
                                        content: vehicleconstants.modaldelete,
                                        onConfirm: () {
                                          context
                                              .read<VehicleCubit>()
                                              .deleteVehicle(
                                                  vehicle, vehicleId);
                                        },
                                      )
                                    },
                                icon: const FaIcon(FontAwesomeIcons.trash),
                                color: Colors.red,
                                iconSize: 15.h),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }
          return Center(child: Text(vehicleconstants.novehicle));
        },
      ),
    );
  }
}
