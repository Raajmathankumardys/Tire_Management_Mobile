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
import '../../../commonScreen/Homepage.dart';
import '../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../Tire-Mapping/cubit/tire_mapping_cubit.dart';
import '../../Tire-Mapping/cubit/tire_mapping_state.dart';
import '../../Tire-Performance/service/tire_performance_service.dart';
import '../../Vehicle/cubit/vehicle_cubit.dart';
import '../../Vehicle/cubit/vehicle_state.dart';
import '../../Vehicle/repository/vehicle_repository.dart';
import '../../Vehicle/service/vehicle_service.dart';
import '../cubit/vehicle_axle_cubit.dart';

class Axle {
  final String label;
  List<TireInventory?> tires;

  Axle({required this.label, required this.tires});
}

class VehicleTireMapping extends StatefulWidget {
  final String vehicleId;
  final Vehicle vehicle;
  const VehicleTireMapping(
      {super.key, required this.vehicleId, required this.vehicle});

  @override
  State<VehicleTireMapping> createState() => _VehicleTireMappingState();
}

class _VehicleTireMappingState extends State<VehicleTireMapping> {
  late Vehicle ve;
  List<TireInventory> availableTires = [];
  List<Axle> axles = [];
  List<VehicleMapping> selectedtire = [];
  List<VehicleMapping> selectedtire1 = [];
  List<TirePosition> allPositions = [];
  List<VehicleAxle> getaxles = [];
  bool isTireLoading = true;
  bool isaction = true;
  late List<VehicleMapping> getvalue = [];
  double boxwidth1 = 0.0;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      selectedtire.clear();
      selectedtire1.clear();
    });
    await fetchVehicles();
    await fetchVehicleAxles();
    setState(() {
      axles.clear();
      for (var i in getaxles) {
        axles.add(Axle(
            label: i.axleNumber, tires: List.filled(i.numberOfWheels, null)));
      }
      boxwidth1 = axles
          .map((axle) => axle.tires.length)
          .reduce((a, b) => a > b ? a : b)
          .toDouble();
    });

    await fetchTires();
    await fetchTirePositions();
    await fetchTireMapping();

    if (mounted) {
      setState(() {
        for (var g in getvalue) {
          for (var axle in axles) {
            for (int i = 0; i < axle.tires.length; i++) {
              if (getTirePositionLabel(axle, i) ==
                  getVehiclePositionCode(allPositions, g.positionId)) {
                axle.tires[i] = availableTires.firstWhere(
                  (TireInventory) => g.tireId == TireInventory.id,
                  orElse: () => TireInventory(
                      // <-- replace with your model's default constructor or a dummy
                      id: '',
                      serialNumber: 'N/A',
                      temperature: 0.0,
                      pressure: 0.0,
                      treadDepth: 0.0,
                      purchaseDate: '',
                      price: 0.0,
                      type: 'Unknown',
                      brand: 'Unknown',
                      model: 'Unknown',
                      size: 'Unknown',
                      expectedLifespan: 0,
                      status: TireStatus.REPLACED),
                );
                selectedtire.add(VehicleMapping(
                    vehicleId: widget.vehicleId,
                    tireId: g.tireId,
                    positionId: g.positionId));
                selectedtire1.add(VehicleMapping(
                    vehicleId: widget.vehicleId,
                    tireId: g.tireId,
                    positionId: g.positionId));
              }
            }
          }
        }
        isTireLoading = false;
      });
    }
  }

  Future<void> fetchVehicleAxles() async {
    final cubit = context.read<VehicleAxleCubit>();
    cubit.fetchVehicleAxles(widget.vehicleId);
    while (true) {
      final state = cubit.state;
      if (state is VehicleAxleLoaded) {
        setState(() {
          getaxles = [];
          getaxles = state.vehicleaxle;
        });
        break;
      } else if (state is VehicleAxleError) {
        ToastHelper.showCustomToast(
            context, state.message, Colors.red, Icons.error);
        break;
      }
      await Future.delayed(Duration(milliseconds: 10));
    }
  }

  Future<void> fetchTires() async {
    final cubit = context.read<TireInventoryCubit>();
    cubit.fetchTireInventory();
    while (true) {
      final state = cubit.state;
      if (state is TireInventoryLoaded) {
        setState(() {
          availableTires = state.tireinventory;
        });
        break;
      } else if (state is TireInventoryError) {
        ToastHelper.showCustomToast(
            context, state.message, Colors.red, Icons.error);
        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> fetchVehicles() async {
    final cubit = context.read<VehicleCubit>();
    cubit.fetchVehicleById(widget.vehicleId);

    while (true) {
      final state = cubit.state;
      if (state is VehicleLoadedById) {
        setState(() {
          ve = state.vehicle;
        });
        break;
      } else if (state is VehicleError) {
        ToastHelper.showCustomToast(
            context, state.message, Colors.red, Icons.error);
        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> fetchTirePositions() async {
    final cubit = context.read<TirePositionCubit>();
    cubit.fetchTirePosition();
    while (true) {
      final state = cubit.state;
      if (state is TirePositionLoaded) {
        setState(() {
          allPositions = state.tireposition.toList();
        });
        break;
      } else if (state is TirePositionError) {
        ToastHelper.showCustomToast(
            context, state.message, Colors.red, Icons.error);
        break;
      }
      await Future.delayed(const Duration(milliseconds: 10));
    }
  }

  Future<void> fetchTireMapping() async {
    /*if (ve.tirePositions != null) {
      setState(() {
        getvalue.clear();
        for (var entry in ve.tirePositions!.entries) {
          getvalue.add(VehicleMapping(
              vehicleId: widget.vehicleId,
              tireId: entry.value,
              positionId: getVehiclePositionId(allPositions, entry.key)));
        }
      });
    }*/
  }

  String getVehiclePositionId(List<TirePosition> allPositions, String code) {
    final match = allPositions.firstWhere(
      (pos) => pos.positionCode == code,
      orElse: () => TirePosition(
          positionCode: '',
          description: 'Unknown',
          id: "",
          side: "None",
          axleNumber: -1,
          position: -1),
    );
    return match.id!;
  }

  String getVehiclePositionCode(List<TirePosition> allPositions, String id) {
    final match = allPositions.firstWhere(
      (pos) => pos.id == id,
      orElse: () => TirePosition(
          positionCode: '',
          description: 'Unknown',
          id: "",
          side: "None",
          axleNumber: -1,
          position: -1),
    );
    return match.positionCode;
  }

  String getTirePositionLabel(Axle axle, int index) {
    String position = '';
    int totalTires = axle.tires.length; // Total number of tires on the axle
    int halfTires =
        totalTires ~/ 2; // Divide by 2 to separate left and right sides
    position = index < halfTires
        ? '${axle.label}L${index + 1}' // For the first half, Left side
        : '${axle.label}R${index - halfTires + 1}';

    return position;
  }

  getaxlelabel(String label) {
    int number = int.parse(label.replaceAll(RegExp(r'[^\d]'), ''));
    return "Axle ${number}";
  }

  String getDescriptionByPositionCode(
      List<TirePosition> allPositions, String code) {
    final match = allPositions.firstWhere(
      (pos) => pos.positionCode == code,
      orElse: () => TirePosition(
          positionCode: '',
          description: 'Unknown',
          id: "",
          side: "None",
          axleNumber: -1,
          position: -1),
    );
    return match.description;
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

  bool _deepEquals(VehicleMapping a, VehicleMapping b) {
    return a.tireId == b.tireId && a.positionId == b.positionId;
  }

  void submit() {
    final totalTireCount =
        axles.fold(0, (sum, axle) => sum + axle.tires.length);
    // if (selectedtire.length != totalTireCount) {
    //   ToastHelper.showCustomToast(
    //       context,
    //       'Please select all tires before submitting.',
    //       Colors.red,
    //       Icons.warning_amber);
    // } else {
    if (getvalue.isEmpty) {
      setState(() {
        isTireLoading = true;
      });
      context
          .read<VehicleAxleCubit>()
          .addVehicleAxle(selectedtire, widget.vehicleId);
      fetchData();
    } else {
      List<VehicleMapping> diff = selectedtire.where((item1) {
        return !selectedtire1.any((item2) => _deepEquals(item1, item2));
      }).toList();
      if (diff.isNotEmpty) {
        setState(() {
          isTireLoading = true;
        });
        context.read<VehicleAxleCubit>().addVehicleAxle(diff, widget.vehicleId);
        fetchData();
      }
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
    /*if (getvalue.isNotEmpty && ve.tirePositions != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Provider<TirePerformanceService>(
            create: (context) => TirePerformanceService(),
            child: TirePerformanceTab(
              getValue: ve.tirePositions!,
              vehicle: widget.vehicle,
            ),
          ),
        ),
      );
    } else {
      ToastHelper.showCustomToast(
          context, "No Tires Found", Colors.red, Icons.warning);
    }*/
  }

  Future<TireInventory?> showTireSelectionModal(
      BuildContext context, String position) async {
    return showDialog<TireInventory>(
      context: context,
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<TireInventory> tire =
            availableTires.where((t) => t.position == null).toList();
        List<TireInventory> filteredTires = tire;

        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Select a Tire $position'),
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
                        filteredTires = tire
                            .where((tire) => tire.serialNumber
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: filteredTires.isEmpty
                        ? Center(
                            child: Text("No Tires Found"),
                          )
                        : ListView.builder(
                            itemCount: filteredTires.length,
                            itemBuilder: (context, index) {
                              final tire = filteredTires[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 3, horizontal: 1),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${tire.serialNumber} - ${tire.brand} ${tire.model}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: Text(
                                      'Size: ${tire.size}, PSI: ${tire.pressure}'),
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

  Widget _buildTireWidget({
    required TireInventory? tire,
    required VoidCallback onSelect,
    required String positionLabel,
  }) {
    return GestureDetector(
      onTap: onSelect,
      child: Container(
        width: 68,
        height: 180,
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
                  if (getvalue.any((item) => (item.positionId ==
                          getVehiclePositionId(allPositions, positionLabel) &&
                      item.tireId == tire.id))) ...[
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {
                          showDeleteConfirmationDialog(
                              context: context,
                              onConfirm: () {
                                // setState(() {
                                //   for (var i in axles) {
                                //     for (int t = 0; t < i.tires.length; t++) {
                                //       final tireInList = i.tires[t];
                                //       if (tireInList != null &&
                                //           tire.serialNumber ==
                                //               tireInList.serialNumber) {
                                //         i.tires[t] = TireInventory(
                                //           id: '',
                                //           serialNumber: 'N/A',
                                //           temperature: 0.0,
                                //           pressure: 0.0,
                                //           treadDepth: 0.0,
                                //           purchaseDate: '',
                                //           price: 0.0,
                                //           type: 'Unknown',
                                //           brand: 'Unknown',
                                //           model: 'Unknown',
                                //           size: 'Unknown',
                                //           expectedLifespan: 0,
                                //           status: TireStatus.WORN_OUT,
                                //         );
                                //       }
                                //     }
                                //   }
                                // });
                                // selectedtire.removeWhere((tire) =>
                                //     tire.positionId ==
                                //     getVehiclePositionId(
                                //         allPositions, positionLabel));
                                // getvalue.removeWhere((tire) =>
                                //     tire.positionId ==
                                //     getVehiclePositionId(
                                //         allPositions, positionLabel));

                                setState(() {
                                  isTireLoading = true;
                                });

                                // Proceed with deleting from backend
                                context
                                    .read<VehicleAxleCubit>()
                                    .deleteVehicleAxle(
                                        widget.vehicleId,
                                        getVehiclePositionId(
                                            allPositions, positionLabel));

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
                  Text(tire.serialNumber,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 12)),
                  Text(tire.brand,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 9)),
                  Text('${tire.model}',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  Text('${tire.type}',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  Text('${tire.size}',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  Text('${tire.purchaseDate}',
                      style: const TextStyle(color: Colors.white, fontSize: 9)),
                  Text(positionLabel,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                  Text(
                    getDescriptionByPositionCode(allPositions, positionLabel),
                    style: const TextStyle(color: Colors.white, fontSize: 9),
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
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
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

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: !isTireLoading
            ? IconButton(
                onPressed: () => {
                      setState(() {
                        isTireLoading = true;
                      }),
                      fetchData()
                    },
                icon: Icon(
                  Icons.refresh,
                  color: Colors.blueAccent,
                ))
            : Text(''),
        actionsIconTheme: IconThemeData(
          color: isdark ? Colors.white : Colors.black,
          size: 30,
        ),
        actions: [
          !isTireLoading
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
      body: BlocConsumer<VehicleAxleCubit, VehicleAxleState>(
        listener: (context, state) {
          if (state is AddedVehicleAxleState ||
              state is UpdatedVehicleAxleState ||
              state is DeletedVehicleAxleState) {
            final message = (state as dynamic).message;
            String updatedMessage = message.toString();
            ToastHelper.showCustomToast(
                context,
                updatedMessage,
                Colors.green,
                (state is AddedVehicleAxleState)
                    ? Icons.add
                    : (state is UpdatedVehicleAxleState)
                        ? Icons.edit
                        : Icons.delete);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MultiBlocProvider(providers: [
                  Provider<VehicleService>(
                    create: (context) => VehicleService(),
                  ),
                  BlocProvider<VehicleCubit>(
                    create: (context) {
                      final vehicleService = context.read<VehicleService>();
                      final vehicleRepository =
                          VehicleRepository(vehicleService);
                      return VehicleCubit(vehicleRepository)..fetchVehicles();
                    },
                  ),
                ], child: HomeScreen()),
              ),
            );
          } else if (state is VehicleAxleError) {
            String updatedMessage = state.message.toString();
            ToastHelper.showCustomToast(
                context, updatedMessage, Colors.red, Icons.error);
          }
        },
        builder: (context, state) {
          if (state is VehicleAxleLoading) {
            return shimmer(
              count: 6,
            );
          } else if (state is VehicleAxleError) {
            String updatedMessage = state.message.toString();
            return Center(child: Text(updatedMessage));
          } else if (state is VehicleAxleLoaded) {
            return isTireLoading
                ? shimmer(
                    count: 6,
                  )
                : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: boxwidth1 == 2 ? boxwidth1 * 200 : boxwidth1 * 100,
                      height: boxwidth1 * 200,
                      child: Align(
                        alignment: Alignment.center,
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            return SingleChildScrollView(
                              child: Column(
                                children: axles.map((axle) {
                                  final tireWidth = 60.0;
                                  final tireHeight = 90.0;
                                  final spacing = 10.0;
                                  final totalTires = axle.tires.length;
                                  final half = totalTires ~/ 2;
                                  final totalWidth = (half * tireWidth) +
                                      ((half - 1) * spacing);

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: SizedBox(
                                      width: width,
                                      height: 230,
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
                                                          context,
                                                          getTirePositionLabel(
                                                              axle, i));
                                                  if (selected != null) {
                                                    setState(() {
                                                      axle.tires[i] = selected;

                                                      selectedtire.removeWhere(
                                                        (item) =>
                                                            getVehiclePositionCode(
                                                                allPositions,
                                                                item
                                                                    .positionId) ==
                                                            getTirePositionLabel(
                                                                axle, i),
                                                      );

                                                      selectedtire.add(VehicleMapping(
                                                          vehicleId:
                                                              widget.vehicleId,
                                                          tireId: selected.id!,
                                                          positionId:
                                                              getVehiclePositionId(
                                                                  allPositions,
                                                                  getTirePositionLabel(
                                                                      axle,
                                                                      i))));
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
                                                          context,
                                                          getTirePositionLabel(
                                                              axle, index));
                                                  if (selected != null) {
                                                    setState(() {
                                                      axle.tires[index] =
                                                          selected;
                                                      selectedtire.removeWhere(
                                                        (item) =>
                                                            getVehiclePositionCode(
                                                                allPositions,
                                                                item
                                                                    .positionId) ==
                                                            getTirePositionLabel(
                                                                axle, index),
                                                      );

                                                      selectedtire.add(VehicleMapping(
                                                          vehicleId:
                                                              widget.vehicleId,
                                                          tireId: selected.id!,
                                                          positionId:
                                                              getVehiclePositionId(
                                                                  allPositions,
                                                                  getTirePositionLabel(
                                                                      axle,
                                                                      index))));
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
                                                getaxlelabel(axle.label),
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
