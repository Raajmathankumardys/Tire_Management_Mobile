import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../TMS/helpers/components/themes/app_colors.dart';
import '../TMS/helpers/components/widgets/Toast/Toast.dart';
import '../TMS/helpers/components/widgets/button/app_primary_button.dart';
import '../services/api_service.dart';

class Tire {
  int id;
  String brand;
  String model;
  String serialno;

  Tire(this.id, {this.brand = "", this.model = "", this.serialno = ""});

  static Tire generate(int id) {
    return Tire(id,
        brand: "", // Ensure brand is empty by default
        model: "", // Keep model empty if you want it to be selected later
        serialno: "");
  }
}

class Axle {
  int id;
  List<Tire> tires1;
  List<Tire> tires2;

  Axle(this.id, int initialTires)
      : tires1 = List.generate(initialTires, (index) => Tire.generate(index)),
        tires2 = List.generate(initialTires, (index) => Tire.generate(index));
}

class AxleAnimationPage extends StatefulWidget {
  final int vehicleid;
  const AxleAnimationPage({super.key, required this.vehicleid});
  @override
  _AxleAnimationPageState createState() => _AxleAnimationPageState();
}

class _AxleAnimationPageState extends State<AxleAnimationPage> {
  Tire? t;
  int assignTireCount = 0;
  List<Axle> axles = [];
  List<Map<String, dynamic>> selectedTires = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    super.initState();

    // Front Axle
    _addAxle(); // Rear Axle
    //populate();

    // Predefined tires with position mapping
  }

  Future<void> populate() async {
    List<dynamic> tireList;
    try {
      final response = await APIService.instance.request(
        "https://yaantrac-backend.onrender.com/api/vehicles/${widget.vehicleid}/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        tireList = response.data['data'];
        print(tireList);
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
          countMap.forEach((k, v) => {
                _addAxle(),
                for (int i = 2; i < v; i += 2) {_addTire(axles.last)}
              });
          for (var tireData in tireList) {
            _assignTireToAxle(tireData);
          }
        } else {
          String input = "F:2,R:2";
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
        }
        //return tireList.map((json) => TireModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
    // Assign tires to axles based on position
  }

// Function to assign tires to the correct axle based on position
  void _assignTireToAxle(Map<String, dynamic> tireData) {
    try {
      // Ensure position is not null
      String position = tireData['position'] ?? 'Unknown';
      int axleIndex;

      if (position == 'Unknown') {
        print(
            "Warning: Tire position is unknown for tire ID ${tireData['id']}");
        return;
      }

      // Extract axle number from position using regex
      RegExp regExp = RegExp(r'(\d+)?([A-Za-z]+)(\d+)?');
      var match = regExp.firstMatch(position);

      if (match == null) {
        print("Error: Unable to parse position format: $position");
        return;
      }

      // Determine axle index properly
      if (position.startsWith("F")) {
        axleIndex = 0; // Front Axle
      } else if (position.startsWith("R")) {
        axleIndex = 1; // Default rear axle index

        // Try extracting the axle number from position (e.g., R2L1 -> axle 2)
        if (match.group(1) != null) {
          axleIndex = int.parse(match.group(1)!) - 1;
        }
      } else {
        print("Warning: Unrecognized axle position format: $position");
        return;
      }

      assignTireCount++;

      print("Axles length before: ${axles.length}");

      // Ensure axles exist
      while (axles.length <= axleIndex) {
        axles.add(Axle(axleIndex + 1, 0)); // Create missing axles
      }

      Axle axle = axles[axleIndex];

      // Create a tire instance
      Tire tire = Tire(
        tireData["id"] ?? -1, // Default ID if missing
      );

      t = Tire(tireData['tire']['id'],
          brand: tireData['tire']['brand'],
          model: tireData['tire']['model'],
          serialno: tireData['tire']['serialNo']);

      print("Assigning tire ID: ${tireData['id']} to position: $position");

      // Assign to left or right side
      if (position.contains("L")) {
        if (axle.tires1.isEmpty) {
          axle.tires1.add(tire);
        } else {
          axle.tires1[0] = tire;
        }
        _pBrand(axle.tires1[0], position, axleIndex, t!);
      } else {
        if (axle.tires2.isEmpty) {
          axle.tires2.add(tire);
        } else {
          axle.tires2[0] = tire;
        }
        _pBrand(axle.tires2[0], position, axleIndex, t!);
      }

      print("Tire successfully assigned to axle ${axleIndex + 1}!");
    } catch (e) {
      print("Error in _assignTireToAxle: $e");
    }
  }

  void _pBrand(Tire tire, String position, int axleId, Tire item) async {
    setState(() {
      tire.id = item.id;
      tire.brand = item.brand;
      tire.model = item.model;
      tire.serialno = item.serialno;
    });
    print(position);
    // Remove previous selection and update
    selectedTires.removeWhere(
        (item) => item["id"] == tire.id && item["position"] == position);
    selectedTires.add({
      "tireId": tire.id,
      "position": position,
    });
  }

  Future<void> _selectBrand(
      BuildContext ctx, Tire tire, String position, int axleId) async {
    print("T1");
    TextEditingController searchController = TextEditingController();
    List<dynamic> tireData = [];
    List<dynamic> filteredTires = [];

    try {
      final response =
          await Dio().get('https://yaantrac-backend.onrender.com/api/tires');

      if (response.statusCode == 200 && response.data["data"] != null) {
        tireData = response.data["data"];
        filteredTires = List.from(tireData); // Show all tires initially

        if (!ctx.mounted) return; // Ensure the context is valid

        await showDialog(
          context: ctx, // Use the passed context
          builder: (BuildContext dialogContext) {
            return StatefulBuilder(
              builder: (context, setState) {
                return AlertDialog(
                  title: Column(
                    children: [
                      Text("Select Tire"),
                      SizedBox(height: 8),
                      TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: "Search by Brand...",
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onChanged: (value) {
                          // Update the filtered list
                          setState(() {
                            filteredTires = tireData
                                .where((item) => (item["serialNo"] ?? "Unknown")
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                    ],
                  ),
                  content: SizedBox(
                      width: double.maxFinite,
                      height: 300,
                      child: filteredTires.isEmpty
                          ? Center(
                              child: Text("No Tires Found"),
                            )
                          : ListView.builder(
                              itemCount: filteredTires.length,
                              itemBuilder: (context, index) {
                                var item = filteredTires[index];

                                return ListTile(
                                  title: Text(
                                      "Serial No: ${item['serialNo'] ?? 'Unknown'}"),
                                  subtitle: Text(
                                      "Brand : ${item['brand']} | Model: ${item['model']} | Size: ${item['size']}"),
                                  onTap: () {
                                    // Update tire details
                                    tire.id = item['id'];
                                    tire.brand = item["brand"];
                                    tire.model = item["model"];
                                    tire.serialno = item['serialNo'];

                                    // Update selected tires list in parent
                                    setState(() {
                                      selectedTires.removeWhere((existing) =>
                                          existing["position"] == position);
                                      selectedTires.add({
                                        "tireId": tire.id,
                                        "position": position,
                                      });
                                    });

                                    // Close dialog only if the context is still valid
                                    if (dialogContext.mounted) {
                                      Navigator.pop(dialogContext);
                                    }
                                  },
                                );
                              },
                            )),
                );
              },
            );
          },
        );

        // Force UI update after closing the dialog
        if (ctx.mounted) {
          (ctx as Element).markNeedsBuild();
        }
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

  Future<void> _submit() async {
    /*if (axles.length < 2) {
      ToastHelper.showCustomToast(context,
          "A vehicle must have at least two axles", Colors.red, Icons.error);
      return;
    }*/
    print(t == null);
    bool allTiresSelected = axles.every((axle) =>
        axle.tires1.every((tire) => tire.brand.isNotEmpty) &&
        axle.tires2.every((tire) => tire.brand.isNotEmpty));

    if (!allTiresSelected) {
      ToastHelper.showCustomToast(context,
          "All tires must have a selected brand", Colors.red, Icons.error);
      return;
    }
    if (selectedTires.length >= 2) {
      ToastHelper.showCustomToast(context, "All tires validated successfully!",
          Colors.green, Icons.tire_repair_outlined);

      print(selectedTires);
      print(widget.vehicleid);
      try {
        final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/vehicles/${widget.vehicleid}/tires",
          t == null ? DioMethod.post : DioMethod.put,
          formData: selectedTires,
          contentType: "application/json",
        );
        if (response.statusCode == 200) {
          print("Success");
          ToastHelper.showCustomToast(
              context, "Tire Mapped Successfully", Colors.green, Icons.add);
        } else {
          ToastHelper.showCustomToast(
              context, "Failed to process request", Colors.green, Icons.add);
        }
      } catch (err) {
        print(err);
        ToastHelper.showCustomToast(context, "Error", Colors.red, Icons.error);
      } finally {
        ToastHelper.showCustomToast(context, "Network error Please try again.",
            Colors.red, Icons.error);
      }
    } else {
      ToastHelper.showCustomToast(context, "Only Front Axle tires are selected",
          Colors.red, Icons.warning_amber);
    }
  }

  void _addAxle() {
    setState(() {
      if (axles.isEmpty) {
        // First axle (Front axle) with fixed 1+1 tires
        axles.add(Axle(0, 1));
      } else {
        axles.add(Axle(axles.length, 1)); // Other axles start with 2+2 tires
      }
      _listKey.currentState?.insertItem(axles.length - 1);
    });
  }

  void _removeAxle() {
    if (axles.length <= 1) {
      ToastHelper.showCustomToast(
          context, "You Can't Remove First Axle", Colors.red, Icons.error);
    }
    // Prevent removing the first axle
    int lastIndex = axles.length - 1;
    Axle lastAxle = axles[lastIndex];

    if (lastAxle.tires1.isEmpty && lastAxle.tires2.isEmpty) {
      _listKey.currentState?.removeItem(
        lastIndex,
        (context, animation) => _buildAxle(lastAxle, animation),
      );
      setState(() {
        axles.removeAt(lastIndex);
      });
    } else {
      ToastHelper.showCustomToast(
          context, "Remove all tires first", Colors.red, Icons.error);
    }
  }

  void _addTire(Axle axle) {
    if (axle.id == 0) return; // Prevent adding tires to the front axle
    setState(() {
      axle.tires1.add(Tire.generate(axle.tires1.length));
      axle.tires2.add(Tire.generate(axle.tires2.length));
    });
  }

  void _removeTire(Axle axle) {
    if (axle.id == 0) return; // Prevent removing tires from the front axle

    setState(() {
      if (axle.tires1.isNotEmpty && axle.tires2.isNotEmpty) {
        selectedTires.removeWhere((item) => item["id"] == axle.id);
        axle.tires1.removeLast();
        axle.tires2.removeLast();
      }

      // If there are no tires left in the axle, remove the axle itself
      if (axle.tires1.isEmpty && axle.tires2.isEmpty) {
        int axleIndex = axles.indexOf(axle);
        if (axleIndex != -1) {
          _listKey.currentState?.removeItem(
            axleIndex,
            (context, animation) => _buildAxle(axle, animation),
          );
          axles.removeAt(axleIndex);
        }
      }
    });
  }

  Widget _buildAxle(Axle axle, Animation<double> animation) {
    double leftOffset = axle.tires1.length * 5.0 +
        (axle.tires1.length - 1) * 3.0; // Adjust dynamically

    return SizeTransition(
      sizeFactor: animation,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h),
        padding: EdgeInsets.all(8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.h),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                axle.id == 0
                    ? "Front Axle"
                    : axle.id == axles.length - 1
                        ? "Rear Axle"
                        : "Axle ${axle.id + 1}",
                style: TextStyle(fontSize: 14.h, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Left side tires
                  Transform.translate(
                    offset: Offset(leftOffset, 0.h),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        axle.tires1.length,
                        (index) => Transform.translate(
                          offset: Offset(index * -8.h, 0),
                          child: _buildWheel(axle.tires1[index], axle.id, "L",
                              index + 1, axles.length),
                        ),
                      ),
                    ),
                  ),

                  // Axle Line
                  Container(
                    width: 60.h,
                    height: 2.h,
                    color: Colors.grey,
                  ),

                  // Right side tires
                  Transform.translate(
                    offset: Offset(-8.h, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        axle.tires2.length,
                        (index) => Transform.translate(
                          offset: Offset(index * -8.h, 0),
                          child: _buildWheel(axle.tires2[index], axle.id, "R",
                              index + 1, axles.length),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            /*if (axle.id != 0) // Hide add/remove buttons for the front axle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () => _addTire(axle),
                    icon: Icon(Icons.add_circle, color: Colors.green),
                  ),
                  IconButton(
                    onPressed: () => _removeTire(axle),
                    icon: Icon(Icons.remove_circle, color: Colors.red),
                  ),
                ],
              ),*/
          ],
        ),
      ),
    );
  }

  Widget _buildWheel(
      Tire tire, int axleId, String side, int position, int totalAxles) {
    String pos;

    // Mapping first axle as FL1, FR1
    if (axleId == 0) {
      pos = side == "L" ? "FL$position" : "FR$position";
    }
    // Mapping last axle as RL1, RL2
    else if (axleId == totalAxles - 1) {
      pos = side == "L" ? "RL$position" : "RR$position";
    }
    // Mapping middle axles as 2L1, 2R1, 3L1, 3R1...
    else {
      pos = "${axleId + 1}$side$position";
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectBrand(context, tire, pos, axleId),
          child: Container(
            padding: EdgeInsets.all(28.h),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tire.serialno.isEmpty ? Colors.grey : Colors.blue,
              border: Border.all(color: Colors.black, width: 3.h),
            ),
            child: Center(
              child: Text(
                pos,
                style: TextStyle(color: Colors.black, fontSize: 10.h),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            tire.serialno.isNotEmpty ? tire.serialno : "Select SerialNo",
            style: TextStyle(
              color: tire.serialno.isEmpty ? Colors.red : Colors.grey,
              fontSize: 10.h,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text("Tire Mapping"),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios)),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 120.h,
          ),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: axles.length,
              itemBuilder: (context, index, animation) {
                return _buildAxle(axles[index], animation);
              },
            ),
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: _addAxle,
                child: Text("Add Axle"),
              ),
              ElevatedButton(
                onPressed: _removeAxle,
                child: Text("Remove Axle"),
              ),
            ],
          ),*/
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [AppPrimaryButton(onPressed: _submit, title: "Submit")],
          ),
          SizedBox(
            height: 20.h,
          )
        ],
      ),
    ));
  }
}
