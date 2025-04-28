import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/TMS/Tire-Mapping/presentation/screen/tire_performance_tab.dart';
import 'package:yaantrac_app/TMS/Tire-Position/Cubit/tire_position_cubit.dart';
import 'package:yaantrac_app/TMS/Tire-Position/Cubit/tire_position_state.dart';
import 'package:yaantrac_app/TMS/Vehicle-Axle/cubit/vehicle_axle_state.dart';
import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../../Tire-Performance/service/tire_performance_service.dart';
import '../../../Vehicle-Axle/cubit/vehicle_axle_cubit.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';
import '../../cubit/tire_mapping_cubit.dart';
import '../../cubit/tire_mapping_state.dart';

class Axle {
  final String label;
  final List<TireInventory?> tires;

  Axle({required this.label, required this.tires});
}

String getDescriptionByPositionCode(
    List<TirePosition> allPositions, String code) {
  final match = allPositions.firstWhere(
    (pos) => pos.positionCode == code,
    orElse: () =>
        TirePosition(positionCode: '', description: 'Unknown', id: -1),
  );
  return match.description;
}

class AxleConfiguration extends StatefulWidget {
  final int vehicleId;
  final Vehicle vehicle;
  const AxleConfiguration(
      {super.key, required this.vehicleId, required this.vehicle});

  @override
  State<AxleConfiguration> createState() => _AxleConfigurationState();
}

class _AxleConfigurationState extends State<AxleConfiguration> {
  List<TireInventory> availableTires = [];
  List<Axle> axles = [];
  List<AddTireMapping> selectedtire = [];
  List<AddTireMapping> selectedtire1 = [];
  List<TirePosition> allPositions = [];
  List<VehicleAxle> getaxles = [];
  bool isTireLoading = true;
  bool isaction = true;
  late List<GetTireMapping> getvalue = [];
  @override
  void initState() {
    super.initState();
    fetchData();
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

  Future<void> fetchData() async {
    axles = [
      Axle(label: 'Front', tires: List.filled(2, null)),
      Axle(label: 'Axle 2', tires: List.filled(4, null)),
      Axle(label: 'Rear', tires: List.filled(4, null)),
    ];
    await fetchTires();
    await fetchTirePositions();
    await fetchTireMapping();

    if (mounted) {
      setState(() {
        selectedtire.clear();
        selectedtire1.clear();
        for (var g in getvalue) {
          for (var axle in axles) {
            for (int i = 0; i < axle.tires.length; i++) {
              if (getTirePositionLabel(axle, i) == g.tirePosition) {
                axle.tires[i] = availableTires.firstWhere(
                  (TireInventory) => g.tireId == TireInventory.id,
                  orElse: () => TireInventory(
                    // <-- replace with your model's default constructor or a dummy
                    id: 0,
                    serialNo: 'N/A',
                    temp: 0.0,
                    psi: 0.0,
                    dist: 0.0,
                    purchaseDate: null,
                    purchaseCost: 0.0,
                    warrantyPeriod: 0,
                    warrantyExpiry: null,
                    categoryId: 0,
                    location: 'Unknown',
                    brand: 'Unknown',
                    model: 'Unknown',
                    size: 'Unknown',
                  ),
                );
                selectedtire.add(AddTireMapping(
                    id: g.id,
                    tireId: g.tireId,
                    tirePosition: g.tirePosition,
                    axleId: getaxles
                        .firstWhere((VehicleAxle) => g.axleId == VehicleAxle.id,
                            orElse: () => VehicleAxle(
                                id: 0,
                                vehicleId: widget.vehicleId,
                                axleNumber: 0,
                                axlePosition: "Unknown"))
                        .id,
                    vehicleId: widget.vehicleId));
                selectedtire1.add(AddTireMapping(
                    id: g.id,
                    tireId: g.tireId,
                    tirePosition: g.tirePosition,
                    axleId: getaxles
                        .firstWhere((VehicleAxle) => g.axleId == VehicleAxle.id,
                            orElse: () => VehicleAxle(
                                id: 0,
                                vehicleId: widget.vehicleId,
                                axleNumber: 0,
                                axlePosition: "Unknown"))
                        .id,
                    vehicleId: widget.vehicleId));
              }
            }
          }
        }
        isTireLoading = false;
      });
    }
  }

  void inittireperformance() {
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => MultiBlocProvider(
    //       providers: [
    //         Provider<TirePerformanceService>(
    //           create: (context) => TirePerformanceService(),
    //         ),
    //         // For each tireId, create a BlocProvider dynamically
    //         ...getvalue.map((entry) {
    //           final tireId = entry.tireId;
    //           return BlocProvider<TirePerformanceCubit>(
    //             create: (context) {
    //               final service = context.read<TirePerformanceService>();
    //               final repo = TirePerformanceRepository(service);
    //               print(entry.tireId);
    //               return TirePerformanceCubit(repo)
    //                 ..fetchTirePerformance(tireId);
    //             },
    //           );
    //         }).toList(),
    //       ],
    //       child: TirePerformanceTab(getValue: getvalue),
    //     ),
    //   ),
    // );
    if (getvalue.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<TirePerformanceService>(
            create: (context) => TirePerformanceService(),
            child: TirePerformanceTab(
              getValue: getvalue,
              vehicle: widget.vehicle,
            ),
          ),
        ),
      );
    } else {
      ToastHelper.showCustomToast(
          context, "No Tires Found", Colors.red, Icons.warning);
    }
  }

  Future<void> fetchVehicleAxles() async {
    while (true) {
      final state = context.read<VehicleAxleCubit>().state;
      if (state is VehicleAxleLoaded) {
        setState(() {
          getaxles = state.vehicleaxle;
        });
        break;
      }
      if (state is VehicleAxleError) {
        print(state.message);
        break;
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Future<void> fetchTires() async {
    fetchVehicleAxles();
    while (true) {
      final state = context.read<TireInventoryCubit>().state;
      if (state is TireInventoryLoaded) {
        availableTires = state.tireinventory.toList();

        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<TireInventory?> showTireSelectionModal(BuildContext context) async {
    return showDialog<TireInventory>(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<TireInventory> filteredTires = List.from(availableTires);

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: const Text('Select a Tire'),
            content: SizedBox(
              width: double.maxFinite,
              height: 400,
              child: Column(
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by Serial No',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredTires = availableTires
                            .where((tire) => tire.serialNo
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredTires.length,
                      itemBuilder: (context, index) {
                        final tire = filteredTires[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              vertical: 3, horizontal: 1),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            title: Text(
                              '${tire.serialNo} - ${tire.brand} ${tire.model}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle:
                                Text('Size: ${tire.size}, PSI: ${tire.psi}'),
                            trailing: const Icon(Icons.arrow_forward_ios,
                                size: 16, color: Colors.blue),
                            onTap: () => Navigator.of(context).pop(tire),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> fetchTirePositions() async {
    while (true) {
      final state = context.read<TirePositionCubit>().state;
      if (state is TirePositionLoaded) {
        allPositions = state.tireposition.toList();
        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> fetchTireMapping() async {
    final state = await context.read<TireMappingCubit>().state;

    if (state is! TireMappingLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTireMapping(); // retry
      return;
    }

    getvalue = state.tiremapping;
    setState(() {
      isaction = false;
    });
  }

  String getTirePositionLabel(Axle axle, int index) {
    String position = '';
    int totalTires = axle.tires.length; // Total number of tires on the axle
    int halfTires =
        totalTires ~/ 2; // Divide by 2 to separate left and right sides

    // Dynamic label for tires based on axle label and tire index
    if (axle.label == 'Front') {
      position = index < halfTires
          ? 'FL${index + 1}' // For the first half, Left side
          : 'FR${index - halfTires + 1}'; // For the second half, Right side
    } else if (axle.label == 'Rear') {
      position = index < halfTires
          ? 'RL${index + 1}' // For the first half, Left side
          : 'RR${index - halfTires + 1}'; // For the second half, Right side
    } else {
      String a = axle.label.split(' ')[1];
      position = index < halfTires
          ? '${a}L${index + 1}' // For the first half, Left side
          : '${a}R${index - halfTires + 1}';
    }

    return position;
  }

  int getAxleId(String label) {
    switch (label) {
      case 'Front':
        return 1;
      case 'Rear':
        return axles.length;
      default:
        return int.parse(label.split(' ')[1]);
    }
  }

  Widget _buildTireWidget({
    required TireInventory? tire,
    required VoidCallback onSelect,
    required String positionLabel,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 65,
        height: 150,
        padding: EdgeInsets.fromLTRB(6, 0, 6, 0),
        decoration: BoxDecoration(
          color: tire != null ? Colors.black : Colors.grey.shade800,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: tire != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (getvalue.any((item) =>
                      (item.tirePosition == positionLabel &&
                          item.tireId == tire.id))) ...[
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          showDeleteConfirmationDialog(
                              context: context,
                              onConfirm: () {
                                setState(() {
                                  isTireLoading = true;
                                });

                                // Proceed with deleting from backend
                                context
                                    .read<TireMappingCubit>()
                                    .deleteTireMapping(
                                      widget.vehicleId,
                                      tire.id!,
                                    );

                                fetchData(); // Refresh data
                              },
                              content:
                                  "Are you sure you want to delete tire in postion ${positionLabel}?");
                        },
                        child: const Icon(Icons.delete,
                            size: 18, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    )
                  ],
                  Text(tire.serialNo,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(tire.brand,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 11)),
                  Text('${tire.model}',
                      style: const TextStyle(color: Colors.white, fontSize: 8)),
                  Text(positionLabel,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(
                    getDescriptionByPositionCode(allPositions, positionLabel),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getDescriptionByPositionCode(allPositions, positionLabel),
                    style: const TextStyle(color: Colors.white, fontSize: 9),
                  ),
                  Text(
                    positionLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    "Tap to",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                  Text(
                    "select tire",
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  )
                ],
              ), // Display the position label if no tire is selected
      ),
    );
  }

  bool _deepEquals(AddTireMapping a, AddTireMapping b) {
    return a.id == b.id &&
        a.tireId == b.tireId &&
        a.tirePosition == b.tirePosition &&
        a.axleId == b.axleId &&
        a.vehicleId == b.vehicleId;
  }

  int? getid(String position) {
    for (var i in getvalue) {
      if (i.tirePosition == position) {
        return i.id;
      }
    }
    return null;
  }

  void submit() {
    final totalTireCount =
        axles.fold(0, (sum, axle) => sum + axle.tires.length);
    if (selectedtire.length != totalTireCount) {
      ToastHelper.showCustomToast(
          context,
          'Please select all tires before submitting.',
          Colors.red,
          Icons.warning_amber);
    } else {
      if (getvalue.isEmpty) {
        context
            .read<TireMappingCubit>()
            .addTireMapping(selectedtire, widget.vehicleId);
      } else {
        List<AddTireMapping> diff = selectedtire.where((item1) {
          return !selectedtire1.any((item2) => _deepEquals(item1, item2));
        }).toList();
        List<AddTireMapping> post = [];
        List<AddTireMapping> put = [];
        for (var i in diff) {
          if (i.id == null) {
            post.add(i);
          } else {
            put.add(i);
          }
        }
        if (post.isNotEmpty) {
          context
              .read<TireMappingCubit>()
              .addTireMapping(post, widget.vehicleId);
        }
        if (put.isNotEmpty) {
          context
              .read<TireMappingCubit>()
              .updateTireMapping(put, widget.vehicleId);
        }
      }
      setState(() {
        isTireLoading = true;
      });
      fetchData();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    final boxwidth =
        axles.map((axle) => axle.tires.length).reduce((a, b) => a > b ? a : b);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () => {
                  context
                      .read<TireMappingCubit>()
                      .fetchTireMapping(widget.vehicleId)
                },
            icon: Icon(
              Icons.refresh,
              color: Colors.blueAccent,
            )),
        actionsIconTheme: IconThemeData(
          color: isdark ? Colors.white : Colors.black,
          size: 30,
        ),
        actions: [
          !isaction
              ? IconButton(
                  onPressed: inittireperformance,
                  icon: SvgPicture.asset(
                    'assets/vectors/tire_psi.svg',
                    height: 25.sp,
                  ),
                )
              : Text('')
          //
        ],
      ),
      body: BlocConsumer<TireMappingCubit, TireMappingState>(
        listener: (context, state) {
          if (state is AddedTireMappingState ||
              state is UpdateTireMappingState ||
              state is DeleteTireMappingState) {
            final message = (state as dynamic).message;
            String updatedMessage = message.toString();
            ToastHelper.showCustomToast(
                context,
                updatedMessage,
                Colors.green,
                (state is AddedTireMappingState)
                    ? Icons.add
                    : (state is UpdateTireMappingState)
                        ? Icons.edit
                        : Icons.delete);
          } else if (state is TireMappingError) {
            String updatedMessage = state.message.toString();
            ToastHelper.showCustomToast(
                context, updatedMessage, Colors.red, Icons.error);
          }
        },
        builder: (context, state) {
          if (state is TireMappingLoading) {
            return shimmer(
              count: 6,
            );
          } else if (state is TireMappingError) {
            String updatedMessage = state.message.toString();
            return Center(child: Text(updatedMessage));
          } else if (state is TireMappingLoaded) {
            return isTireLoading
                ? shimmer(
                    count: 6,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: boxwidth == 2 ? boxwidth * 200 : boxwidth * 100,
                      height: 700,
                      child: Align(
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            return SingleChildScrollView(
                              child: Column(
                                children: axles.map((axle) {
                                  final tireWidth = 60.0;
                                  final tireHeight = 80.0;
                                  final spacing = 10.0;
                                  final totalTires = axle.tires.length;
                                  final half = totalTires ~/ 2;
                                  final totalWidth = (half * tireWidth) +
                                      ((half - 1) * spacing);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: width,
                                      height: 200,
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          // Left Horizontal Line
                                          Positioned(
                                            left: width / 2 - totalWidth - 16,
                                            top: tireHeight + 8,
                                            child: Container(
                                              width: totalWidth,
                                              height: 6,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                          // Right Horizontal Line
                                          Positioned(
                                            left: width / 2 + 16,
                                            top: tireHeight + 8,
                                            child: Container(
                                              width: totalWidth,
                                              height: 6,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),

                                          // Left Tires
                                          ...List.generate(half, (i) {
                                            final left = width / 2 -
                                                totalWidth -
                                                16 +
                                                i * (tireWidth + spacing);
                                            return Positioned(
                                              top: 50,
                                              left: left - 40,
                                              child: _buildTireWidget(
                                                tire: axle.tires[i],
                                                positionLabel:
                                                    getTirePositionLabel(
                                                        axle, i),
                                                onSelect: () async {
                                                  final selected =
                                                      await showTireSelectionModal(
                                                          context);
                                                  if (selected != null) {
                                                    setState(() {
                                                      axle.tires[i] = selected;

                                                      selectedtire.removeWhere(
                                                        (item) =>
                                                            item.tirePosition ==
                                                            getTirePositionLabel(
                                                                axle, i),
                                                      );

                                                      selectedtire.add(
                                                        AddTireMapping(
                                                          id: getid(
                                                              getTirePositionLabel(
                                                                  axle, i)),
                                                          tireId: selected.id!,
                                                          tirePosition:
                                                              getTirePositionLabel(
                                                                  axle, i),
                                                          axleId: getaxles
                                                              .firstWhere(
                                                                (vehicleAxle) =>
                                                                    getAxleId(axle
                                                                        .label) ==
                                                                    vehicleAxle
                                                                        .axleNumber,
                                                                orElse: () =>
                                                                    VehicleAxle(
                                                                  id: 0,
                                                                  vehicleId: widget
                                                                      .vehicleId,
                                                                  axleNumber: 0,
                                                                  axlePosition:
                                                                      "Unknown",
                                                                ),
                                                              )
                                                              .id,
                                                          vehicleId:
                                                              widget.vehicleId,
                                                        ),
                                                      );
                                                    });
                                                  }
                                                },
                                              ),
                                            );
                                          }),

                                          // Right Tires
                                          ...List.generate(totalTires - half,
                                              (i) {
                                            final index = half + i;
                                            final left = width / 2 +
                                                16 +
                                                i * (tireWidth + spacing);
                                            return Positioned(
                                              top: 50,
                                              left: left + 40,
                                              child: _buildTireWidget(
                                                tire: axle.tires[index],
                                                positionLabel:
                                                    getTirePositionLabel(
                                                        axle, index),
                                                onSelect: () async {
                                                  final selected =
                                                      await showTireSelectionModal(
                                                          context);
                                                  if (selected != null) {
                                                    setState(() {
                                                      axle.tires[index] =
                                                          selected;
                                                      selectedtire.removeWhere(
                                                        (item) =>
                                                            item.tirePosition ==
                                                            getTirePositionLabel(
                                                                axle, index),
                                                      );

                                                      selectedtire.add(
                                                        AddTireMapping(
                                                          id: getid(
                                                              getTirePositionLabel(
                                                                  axle, index)),
                                                          tireId: selected.id!,
                                                          tirePosition:
                                                              getTirePositionLabel(
                                                                  axle, index),
                                                          axleId: getaxles
                                                              .firstWhere(
                                                                (vehicleAxle) =>
                                                                    getAxleId(axle
                                                                        .label) ==
                                                                    vehicleAxle
                                                                        .axleNumber,
                                                                orElse: () =>
                                                                    VehicleAxle(
                                                                  id: 0,
                                                                  vehicleId: widget
                                                                      .vehicleId,
                                                                  axleNumber: 0,
                                                                  axlePosition:
                                                                      "Unknown",
                                                                ),
                                                              )
                                                              .id,
                                                          vehicleId:
                                                              widget.vehicleId,
                                                        ),
                                                      );
                                                    });
                                                  }
                                                },
                                              ),
                                            );
                                          }),

                                          // Axle Label
                                          Positioned(
                                            top: tireHeight - 5,
                                            child: Container(
                                              padding: EdgeInsets.all(6),
                                              color: isdark
                                                  ? Colors.black
                                                  : Colors.white,
                                              child: Text(
                                                axle.label,
                                                style: const TextStyle(
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
          }
          return Center(child: Text("Not Found"));
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.sp),
        child: AppPrimaryButton(onPressed: submit, title: "Submit"),
      ),
    );
  }
}
