import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../TMS/helpers/components/widgets/Toast/Toast.dart';
import '../models/tire.dart';
import '../services/api_service.dart';

class TirePressureScreen extends StatefulWidget {
  @override
  _TirePressureScreenState createState() => _TirePressureScreenState();
}

class _TirePressureScreenState extends State<TirePressureScreen> {
  TireModel? selectedFL1;
  TireModel? selectedFR1;
  TireModel? selectedRL1;
  TireModel? selectedRR1;
  List<dynamic> selectedTires = [
    {"tireId": null, "position": "FL1"},
    {"tireId": null, "position": "FR1"},
    {"tireId": null, "position": "RL1"},
    {"tireId": null, "position": "RR1"}
  ];
  Map<String, int> tireMap = {
    "FL1": 0,
    "FR1": 1,
    "RL1": 2,
    "RR1": 3,
  };
  List<TireModel?> tyre = List.generate(4, (index) => null);

  String _formatDate(DateTime date) {
    return "${date.day.toString().padLeft(2, '0')}-"
        "${date.month.toString().padLeft(2, '0')}-"
        "${date.year}";
  }

  Future<void> populate() async {
    List<dynamic> tireList;
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/87/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        tireList = response.data['data'];
        if (tireList.isNotEmpty) {
          List<String> p =
              tireList.map((tire) => tire["position"] as String).toList();
          Map<String, int> countMap = {};

          for (String input in p) {
            RegExp regExp = RegExp(r'(\d+|F|R)'); // Match 'F', 'R', or numbers
            var match = regExp.firstMatch(input);

            if (match != null) {
              String key = match.group(1)!; // Extract matched part
              countMap[key] = (countMap[key] ?? 0) + 1; // Update count
            }
          }
        } /*else {
          String input = "F:2,2:4,3:4,R:2";
          List<String> a = input.split(",");
          Map<String, int> b = {};
          for (var i in a) {
            var c = i.split(":");
            b[c[0]] = int.parse(c[1]);
          }
          b.forEach((k, v) => {
            _addAxle(),
            for (int i = 2; i < v; i += 2) {_addTire(axles.last)}
          });
          //List.generate(2, (_) => _addAxle());
          //_addAxle();
        }*/
        //return tireList.map((json) => TireModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
    // Assign tires to axles based on position
  }

  Future<void> _showTireSelectionDialog(
      BuildContext ctx, String title, int index) async {
    final Dio dio = Dio();

    try {
      final response =
          await dio.get("https://yaantrac-backend.onrender.com/api/tires");

      if (response.statusCode == 200) {
        if (response.data["data"] != null) {
          List<dynamic> tireList = response.data['data'] ?? [];
          List<TireModel> tires =
              tireList.map((json) => TireModel.fromJson(json)).toList();

          if (tires.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("No tires available")),
            );
            return;
          }

          _showTireDialog(context, title, tires);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Unexpected API response format")),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "Failed to load tires. Status code: ${response.statusCode}")),
        );
      }
    } catch (e) {
      print("Error fetching tire data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching tire data")),
      );
    }
  }

  Future<void> _showTireDialog(
      BuildContext ctx, String title, List<TireModel> tires) async {
    TextEditingController searchController = TextEditingController();
    List<TireModel> filteredTires = List.from(tires);
    try {
      if (!ctx.mounted) return; // Define filteredTires outside
      await showDialog(
        context: ctx,
        builder: (BuildContext dialogContext) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text("Select a Tire for $title"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by Serial No",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filteredTires = tires
                              .where((tire) => tire.serialNo
                                  .toLowerCase()
                                  .contains(value.toLowerCase()))
                              .toList();
                        });
                      },
                    ),
                    SizedBox(height: 5),
                    Container(
                      height: 300.h,
                      width: 300.w,
                      child: filteredTires.isEmpty
                          ? Center(child: Text("No tires found"))
                          : ListView.builder(
                              itemCount: filteredTires.length,
                              itemBuilder: (context, index) {
                                var tire = filteredTires[index];
                                return ListTile(
                                  title: Text("${tire.serialNo}",
                                      style: TextStyle(fontSize: 14.sp)),
                                  subtitle: Text(
                                      "Model: ${tire.model} | Brand: ${tire.brand}"),
                                  trailing: Icon(Icons.arrow_forward_ios,
                                      size: 16.sp, color: Colors.blue),
                                  onTap: () {
                                    if (tireMap.containsKey(title)) {
                                      setState(() {
                                        int tireIndex = tireMap[title]!;
                                        selectedTires[tireIndex] = {
                                          "tireId": tire.id,
                                          "position": title,
                                        };
                                        tyre[tireIndex] = tire;
                                      });
                                    }
                                    print(selectedTires);
                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                    }
                                    //Navigator.pop(context);
                                  },
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
      if (ctx.mounted) {
        (ctx as Element).markNeedsBuild();
      } else {
        if (ctx.mounted) {
          ToastHelper.showCustomToast(
              ctx, "Failed to fetch tire data", Colors.red, Icons.error);
        }
      }
    } catch (e) {
      if (ctx.mounted) {
        ToastHelper.showCustomToast(
            ctx, "Error fetching tires: $e", Colors.red, Icons.error);
      }
    }
  }

  void _submitTires() {
    bool allTiresSelected =
        selectedTires.every((tire) => tire["tireId"] != null);

    if (!allTiresSelected) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select all tires before submitting")),
      );
      return;
    }

    print("Submitting selected tires: $selectedTires");

    // Send data to API (if needed)
    //_sendTiresToServer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return (false)
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Car Image in the Center
                    Positioned(
                      height: constraints.maxHeight * 0.3,
                      width: constraints.maxWidth * 0.6,
                      child: SvgPicture.asset("assets/images/cars.svg",
                          fit: BoxFit.contain),
                    ),
                    Positioned(
                      bottom: 10.h,
                      child: ElevatedButton(
                        onPressed: _submitTires,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text("Submit Tires"),
                      ),
                    ),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.45, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.55, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.45, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.55, color: Color(0xfffd3003)),

                    /// Tire Info Boxes (Dynamically Updated)
                    _buildTireInfoBox(
                      constraints,
                      right: 0.6,
                      top: 0.05,
                      title: selectedTires[0]['position'],
                      tire: tyre[0],
                      onTap: () => _showTireSelectionDialog(context, "FL1", 0),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.05,
                      top: 0.05,
                      title: selectedTires[1]['position'],
                      tire: tyre[1],
                      onTap: () => _showTireSelectionDialog(context, "FR1", 1),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.6,
                      top: 0.70,
                      title: selectedTires[2]['position'],
                      tire: tyre[2],
                      onTap: () => _showTireSelectionDialog(context, "RL1", 2),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.05,
                      top: 0.70,
                      title: selectedTires[3]['position'],
                      tire: tyre[3],
                      onTap: () => _showTireSelectionDialog(context, "RR1", 3),
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    /// Car Image in the Center
                    Positioned(
                      height: constraints.maxHeight * 0.8,
                      width: constraints.maxWidth * 0.3,
                      child: SvgPicture.asset("assets/images/trailer.svg",
                          fit: BoxFit.contain),
                    ),
                    Positioned(
                      bottom: 10.h,
                      child: ElevatedButton(
                        onPressed: _submitTires,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10.w, vertical: 10.h),
                          backgroundColor: Colors.blue,
                        ),
                        child: Text("Submit Tires"),
                      ),
                    ),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.28, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.72, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.31, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.64, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.27, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.68, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.23, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.72, top: 0.35, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.42, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.42, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.49, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.49, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.56, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.56, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.35, top: 0.63, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.63, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.28, color: Color(0xff25fd03)),
                    _buildTireIcon(constraints,
                        left: 0.6, top: 0.72, color: Color(0xfffd3003)),

                    /// Tire Info Boxes (Dynamically Updated)
                    _buildTireInfoBox(
                      constraints,
                      right: 0.6,
                      top: 0.05,
                      title: selectedTires[0]['position'],
                      tire: tyre[0],
                      onTap: () => _showTireSelectionDialog(context, "FL1", 0),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.05,
                      top: 0.05,
                      title: selectedTires[1]['position'],
                      tire: tyre[1],
                      onTap: () => _showTireSelectionDialog(context, "FR1", 1),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.6,
                      top: 0.80,
                      title: selectedTires[2]['position'],
                      tire: tyre[2],
                      onTap: () => _showTireSelectionDialog(context, "RL1", 2),
                    ),
                    _buildTireInfoBox(
                      constraints,
                      right: 0.05,
                      top: 0.80,
                      title: selectedTires[3]['position'],
                      tire: tyre[3],
                      onTap: () => _showTireSelectionDialog(context, "RR1", 3),
                    ),
                  ],
                );
        },
      ),
    );
  }

  /// Tire Info Box UI (Dynamic)
  Widget _buildTireInfoBox(
    BoxConstraints constraints, {
    required double top,
    required double right,
    required String title,
    required VoidCallback onTap,
    TireModel? tire,
  }) {
    return Positioned(
      right: constraints.maxWidth * right,
      top: constraints.maxHeight * top,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.all(1.h),
          width: 120.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.blue, width: 2.w),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5.r,
                spreadRadius: 2.r,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// Title (Front / Rear)
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 6.h),
              if (tire != null) ...[
                /// Serial Number
                Text(
                  "Serail No: ${tire.serialNo}",
                  style: TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w500),
                ),
                Divider(thickness: 1, color: Colors.blue[200]),

                /// Tire Brand & Model
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.directions_car, size: 14.sp, color: Colors.blue),
                    SizedBox(width: 2.w),
                    Container(
                      child: Text(
                        "${tire.brand} - ${tire.model}",
                        style: TextStyle(
                            fontSize: 10.sp, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),

                _infoRow(Icons.thermostat, "Temp: ${tire.temp}°C"),

                /// PSI
                _infoRow(Icons.speed, "PSI: ${tire.psi}"),

                /// Distance
                _infoRow(Icons.route, "Distance: ${tire.dist} km"),

                /// Warranty Period
                _infoRow(
                    Icons.shield, "Warranty: ${tire.warrantyPeriod} years"),

                /// Warranty Expiry Date
                _infoRow(Icons.event,
                    "Expiry: ${_formatDate(tire.warrantyExpiry!)}"),
              ] else

                /// Default Message When No Tire is Selected
                Text(
                  "Tap to select Tire",
                  style: TextStyle(color: Colors.grey, fontSize: 12.sp),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔥 Helper Widget for Row Items
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Row(
        children: [
          Icon(icon, size: 8.sp, color: Colors.blue),
          SizedBox(width: 8.h),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 9.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTireIcon(BoxConstraints constraints,
      {double? left,
      double? right,
      required double top,
      required Color color}) {
    return Positioned(
      left: left != null ? constraints.maxWidth * left : null,
      right: right != null ? constraints.maxWidth * right : null,
      top: constraints.maxHeight * top,
      child: SvgPicture.asset(
        "assets/images/FL_Tyre.svg",
        color: color,
        height: 30.h,
      ),
    );
  }
}
