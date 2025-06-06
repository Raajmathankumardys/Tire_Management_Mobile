import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/helpers/constants.dart';

import '../../../../helpers/components/shimmer.dart';
import '../../../../helpers/components/widgets/Toast/Toast.dart';
import '../../../../helpers/components/widgets/button/app_primary_button.dart';
import '../../../../helpers/components/widgets/deleteDialog.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_cubit.dart';
import '../../../Tire-Inventory/cubit/tire_inventory_state.dart';
import '../../../Tire-Performance/service/tire_performance_service.dart';
import '../../../Tire-Position/Cubit/tire_position_cubit.dart';
import '../../../Tire-Position/Cubit/tire_position_state.dart';
import '../../../Vehicle-Axle/cubit/vehicle_axle_cubit.dart';
import '../../../Vehicle-Axle/cubit/vehicle_axle_state.dart';
import '../../../Vehicle/cubit/vehicle_state.dart';
import '../../cubit/tire_mapping_cubit.dart';
import '../../cubit/tire_mapping_state.dart';
import 'tire_performance_tab.dart';

class CarMappingScreen extends StatefulWidget {
  final int vehicleId;
  final Vehicle vehicle;
  const CarMappingScreen(
      {super.key, required this.vehicleId, required this.vehicle});

  @override
  State<CarMappingScreen> createState() => _CarMappingScreenState();
}

class _CarMappingScreenState extends State<CarMappingScreen> {
  final List<String> allowedPositions = [
    tiremappingconstants.fl1,
    tiremappingconstants.fr1,
    tiremappingconstants.rl1,
    tiremappingconstants.rr1
  ];
  List<TirePosition> allPositions = [];
  List<TirePosition> filteredPositions = [];
  List<TireInventory> allTires = [];
  List<VehicleAxle> getaxles = [];
  List<GetTireMapping> tiremapping = [];
  Map<String, TireInventory?> selectedTires = {};
  List<AddTireMapping> p1 = [];
  List<GetTireMapping> getvalue = [];
  bool isload = true;
  bool isaction = true;
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
    await fetchTireInventory();
    await fetchTirePositions();
    await fetchVehicleAxles();
    await fetchTireMapping(); // <-- Add this!
    setState(() {
      selectedTires.clear();
    });
    if (mounted) {
      setState(() {
        for (var item in getvalue) {
          selectedTires.addAll({
            item.tirePosition: allTires.firstWhere(
              (tire) => item.tireId == tire.id,
              orElse: () => TireInventory(
                id: item.tireId,
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
            )
          });
          p1.addAll({
            AddTireMapping(
                id: item.id,
                vehicleId: widget.vehicleId,
                axleId: item.axleId,
                tirePosition: item.tirePosition,
                tireId: item.tireId)
          });
        }
        isload = false;
      });
    }
  }

  Future<void> fetchTirePositions() async {
    final state = await context.read<TirePositionCubit>().state;
    if (state is! TirePositionLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTirePositions(); // Try again until loaded
      return;
    }

    setState(() {
      allPositions = state.tireposition;
      filteredPositions = allPositions
          .where((p) => allowedPositions.contains(p.positionCode))
          .toList();
    });
  }

  Future<void> fetchVehicleAxles() async {
    final state = await context.read<VehicleAxleCubit>().state;
    if (state is! VehicleAxleLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchVehicleAxles(); // Try again until loaded
      return;
    }

    setState(() {
      getaxles = state.vehicleaxle;
    });
  }

  Future<void> fetchTireInventory() async {
    final state = await context.read<TireInventoryCubit>().state;

    if (state is! TireInventoryLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTireInventory(); // Try again until loaded
      return;
    }

    setState(() {
      allTires = state.tireinventory;
    });
  }

  Future<void> fetchTireMapping() async {
    final state = await context.read<TireMappingCubit>().state;

    if (state is! TireMappingLoaded) {
      await Future.delayed(const Duration(milliseconds: 100));
      await fetchTireMapping(); // retry
      return;
    }

    getvalue = state.tiremapping;
    tiremapping = state.tiremapping;
    setState(() {
      isaction = false;
    });
  }

  Future<TireInventory?> showTireDialog(String position) async {
    TextEditingController searchController = TextEditingController();
    List<TireInventory> filteredTires = List.from(allTires);

    return showDialog<TireInventory>(
      context: context,
      builder: (BuildContext ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return AlertDialog(
              title: Text(tiremappingconstants.select(position)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: tiremappingconstants.search,
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredTires = allTires
                            .where((tire) => tire.serialNo
                                .toLowerCase()
                                .contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 300,
                    width: 300,
                    child: ListView.builder(
                      itemCount: filteredTires.length,
                      itemBuilder: (_, index) {
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
                            subtitle: Text(
                                '${tireinventoryconstants.size}: ${tire.size}, ${tireinventoryconstants.pressure}: ${tire.psi}'),
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
            );
          },
        );
      },
    );
  }

  Color getBorderColor(String code) {
    switch (code) {
      case tiremappingconstants.fl1:
        return Colors.pink;
      case tiremappingconstants.fr1:
        return Colors.orange;
      case tiremappingconstants.rl1:
        return Colors.green;
      case tiremappingconstants.rr1:
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Widget tireBox(TirePosition pos, bool isdark) {
    final selected = selectedTires[pos.positionCode];

    return GestureDetector(
      onTap: () async {
        final tire = await showTireDialog(pos.positionCode);
        if (tire != null) {
          setState(() {
            selectedTires[pos.positionCode] = tire;
          });
        }
      },
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isdark ? Colors.black : Colors.white,
          border: Border.all(color: getBorderColor(pos.positionCode), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            if (getvalue.any((item) => (item.tirePosition == pos.positionCode &&
                item.tireId == selected!.id))) ...[
              Row(
                children: [
                  Text(
                    pos.description,
                    style: TextStyle(fontSize: 7),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        showDeleteConfirmationDialog(
                            context: context,
                            onConfirm: () => {
                                  context
                                      .read<TireMappingCubit>()
                                      .deleteTireMapping(
                                          widget.vehicleId, selected?.id ?? 0),
                                  setState(() {
                                    isload = true;
                                  }),
                                  fetchData()
                                },
                            content: tiremappingconstants
                                .deletemodal(pos.positionCode));
                      },
                      child:
                          const Icon(Icons.delete, size: 18, color: Colors.red),
                    ),
                  )
                ],
              ),
            ],
            if (!getvalue.any((item) =>
                (item.tirePosition == pos.positionCode &&
                    item.tireId == selected!.id))) ...[
              Text(
                pos.description,
                style: TextStyle(fontSize: 9),
              )
            ],
            Text(
              pos.positionCode,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              selected?.serialNo ?? " ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            if (selected != null) ...[
              Text(selected.brand),
              Text(selected.model),
            ] else ...[
              Text(tiremappingconstants.tap, style: TextStyle(fontSize: 12)),
            ],
          ],
        ),
      ),
    );
  }

  int getvehicleaxleId(int axleno) {
    return getaxles
        .firstWhere((VehicleAxle) => axleno == VehicleAxle.axleNumber,
            orElse: () => VehicleAxle(
                id: 0,
                vehicleId: widget.vehicleId,
                axleNumber: 0,
                axlePosition: "Unknown"))
        .id;
  }

  int? getid(String position) {
    for (var i in getvalue) {
      if (i.tirePosition == position) {
        return i.id;
      }
    }
    return null;
  }

  bool _deepEquals(AddTireMapping a, AddTireMapping b) {
    return a.id == b.id &&
        a.tireId == b.tireId &&
        a.tirePosition == b.tirePosition &&
        a.axleId == b.axleId &&
        a.vehicleId == b.vehicleId;
  }

  void inittireperformance() {
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
      ToastHelper.showCustomToast(context, tiremappingconstants.nomappingfound,
          Colors.red, Icons.warning);
    }
  }

  void onSubmit() {
    print(tiremapping);
    if (filteredPositions
        .every((p) => selectedTires.containsKey(p.positionCode))) {
      final payload = filteredPositions.map((pos) {
        final tire = selectedTires[pos.positionCode]!;
        return AddTireMapping(
            id: getid(pos.positionCode),
            tireId: tire.id ?? 0,
            tirePosition: pos.positionCode,
            axleId: pos.positionCode[0] == "F"
                ? getvehicleaxleId(1)
                : getvehicleaxleId(2),
            vehicleId: widget.vehicleId);
      }).toList();
      Set<int> uniqueTireIds = {};
      bool allUnique = true;

      for (var mapping in payload) {
        int tireId = mapping.tireId;
        if (!uniqueTireIds.add(tireId)) {
          allUnique = false;
          break;
        }
      }

      if (allUnique) {
        if (getvalue.isEmpty) {
          context
              .read<TireMappingCubit>()
              .addTireMapping(payload, widget.vehicleId);
          setState(() {
            selectedTires.clear();
          });
          fetchData();
        } else {
          List idswap = [];
          int? tp;
          payload.forEach((i) => print(i.toJson()));
          for (var item in payload) {
            for (var getItem in getvalue) {
              if (item.tireId == getItem.tireId) {
                // Swap the `id` values
                tp = item.id;
                idswap.add(tp);
                item.id = getItem.id;
              }
            }
          }
          for (var qw in idswap) {
            for (var item in payload) {
              for (var getItem in getvalue) {
                if (item!.id == getItem!.id && item.tireId != getItem.tireId) {
                  item.id = qw;
                }
              }
            }
          }
          payload.forEach((i) => print(i.toJson()));
          // Output the updated `value` list
          List<AddTireMapping> diff = payload.where((item1) {
            return !p1.any((item2) => _deepEquals(item1, item2));
          }).toList();
          //print(diff);
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
            setState(() {
              isload = true;
              selectedTires.clear();
            });
            fetchData();
          }
          if (put.isNotEmpty) {
            context
                .read<TireMappingCubit>()
                .updateTireMapping(put, widget.vehicleId);
            setState(() {
              isload = true;
              selectedTires.clear();
            });
            fetchData();
          }
        }
        ToastHelper.showCustomToast(context, tiremappingconstants.submitted,
            Colors.green, Icons.beenhere_rounded);
      } else {
        ToastHelper.showCustomToast(
            context, "All Tires Must be Unique ", Colors.red, Icons.warning);
      }
    } else {
      ToastHelper.showCustomToast(
          context, tiremappingconstants.select4, Colors.red, Icons.warning);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isdark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        // title: const Text("Car Mapping"),
        // leading: IconButton(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(
        //           builder: (context) => HomeScreen(),
        //         ),
        //       );
        //     },
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: isdark ? AppColors.darkaddbtn : AppColors.lightaddbtn,
        //     )),
        actions: [
          !isaction
              ? IconButton(
                  onPressed: inittireperformance,
                  icon: SvgPicture.asset(
                    tiremappingconstants.performancepath,
                    height: 25.sp,
                  ),
                )
              : Text(''),
        ],
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
            return isload
                ? shimmer(
                    count: 6,
                  )
                : Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Car Frame
                        SizedBox(
                          width: 350,
                          height: 350,
                          child: CustomPaint(
                            painter: CarFramePainter(),
                          ),
                        ),

                        // Axle Labels
                        const Positioned(
                            top: 0,
                            child: LabelChip(tiremappingconstants.frontaxle)),
                        const Positioned(
                            bottom: 0,
                            child: LabelChip(tiremappingconstants.rearaxle)),

                        // Tires
                        Positioned(
                          top: 10,
                          left: 0,
                          child: tireBox(
                              filteredPositions.firstWhere(
                                  (p) =>
                                      p.positionCode ==
                                      tiremappingconstants.fl1,
                                  orElse: () => TirePosition(
                                      positionCode: "",
                                      description: "",
                                      id: 0)),
                              isdark),
                        ),
                        Positioned(
                          top: 10,
                          right: 0,
                          child: tireBox(
                              filteredPositions.firstWhere(
                                  (p) =>
                                      p.positionCode ==
                                      tiremappingconstants.fr1,
                                  orElse: () => TirePosition(
                                      positionCode: "",
                                      description: "",
                                      id: 0)),
                              isdark),
                        ),
                        Positioned(
                          bottom: 10,
                          left: 0,
                          child: tireBox(
                              filteredPositions.firstWhere((p) =>
                                  p.positionCode == tiremappingconstants.rl1),
                              isdark),
                        ),
                        Positioned(
                          bottom: 10,
                          right: 0,
                          child: tireBox(
                              filteredPositions.firstWhere((p) =>
                                  p.positionCode == tiremappingconstants.rr1),
                              isdark),
                        ),
                      ],
                    ),
                  );
          }
          return Center(child: Text(tiremappingconstants.nomappingfound));
        },
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AppPrimaryButton(onPressed: onSubmit, title: constants.save)),
    );
  }
}

class CarFramePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey.shade800
      ..strokeWidth = 4.0;

    // Draw horizontal lines (axles)
    canvas.drawLine(Offset(0, 50), Offset(size.width, 50), paint); // Front
    canvas.drawLine(Offset(0, size.height - 50),
        Offset(size.width, size.height - 50), paint); // Rear

    // Draw vertical line (center chassis)
    canvas.drawLine(Offset(size.width / 2, 50),
        Offset(size.width / 2, size.height - 50), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LabelChip extends StatelessWidget {
  final String text;
  const LabelChip(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text),
    );
  }
}
