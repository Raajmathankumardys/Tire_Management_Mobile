import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';

import '../services/api_service.dart';

class Tire {
  int id;
  String brand;
  String model;

  Tire(this.id, {this.brand = "", this.model = ""});

  static Tire generate(int id) {
    return Tire(
      id,
      brand: "", // Ensure brand is empty by default
      model: "", // Keep model empty if you want it to be selected later
    );
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
    List.generate(1, (_) => _addAxle());
    // Front Axle
    // _addAxle(); // Rear Axle
    populate();

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
          for (var tireData in tireList) {
            _assignTireToAxle(tireData);
          }
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
      // Check if position is valid
      if (position == 'Unknown') {
        print(
            "Warning: Tire position is unknown for tire ID ${tireData['id']}");
        return;
      }
      RegExp regExp = RegExp(r'(\d+)([A-Za-z]+)(\d+)');
      var match = regExp.firstMatch(position);

      // Determine axle index explicitly
      if (position.startsWith("F")) {
        axleIndex = 0; // Front Axle
      } else if (position.startsWith("R")) {
        axleIndex = (assignTireCount / 2).toInt();
      } else {
        axleIndex = int.parse(match!.group(1)!) - 1; // Rear Axle
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
          brand: tireData['tire']['brand'], model: tireData['tire']['model']);

      print("Assigning tire ID: ${tireData['id']} to position: $position");

      // Assign to left or right side
      if (position.contains("L")) {
        if (axle.tires1.isEmpty) {
          axle.tires1.add(tire);
        } else {
          axle.tires1[0] = tire;
          _pBrand(axle.tires1[axleIndex], position, axleIndex, t!);
        }
      } else {
        if (axle.tires2.isEmpty) {
          axle.tires2.add(tire);
        } else {
          axle.tires2[0] = tire;

          _pBrand(axle.tires2[axleIndex], position, axleIndex, t!);
        }
      }

      // Populate brand details

      // Add to selected tires list

      print("Tire successfully assigned!");
    } catch (e) {
      print("Error in _assignTireToAxle: $e");
    }
  }

  void _pBrand(Tire tire, String position, int axleId, Tire item) async {
    setState(() {
      tire.id = item.id;
      tire.brand = item.brand;
      tire.model = item.model;
    });

    // Remove previous selection and update
    selectedTires.removeWhere(
        (item) => item["id"] == tire.id && item["position"] == position);
    selectedTires.add({
      "tireId": tire.id,
      "position": position,
    });
  }

  Future<void> _selectBrand(Tire tire, String position, int axleId) async {
    print("T1");
    try {
      final response =
          await Dio().get('https://yaantrac-backend.onrender.com/api/tires');

      if (response.statusCode == 200 && response.data["data"] != null) {
        List<dynamic> tireData = response.data["data"];

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Select Tire"),
              content: SizedBox(
                width: double.maxFinite,
                height: 300, // Adjust modal height
                child: ListView.builder(
                  itemCount: tireData.length,
                  itemBuilder: (context, index) {
                    var item = tireData[index];
                    return ListTile(
                      title: Text("Brand: ${item['brand']}"),
                      subtitle: Text(
                          "Model: ${item['model']} | Stock: ${item['stock']}"),
                      onTap: () {
                        setState(() {
                          tire.id = item['id'];
                          tire.brand = item["brand"];
                          tire.model = item["model"];

                          // Remove previous selection and update
                          selectedTires.removeWhere((item) =>
                              item["id"] == tire.id &&
                              item["position"] == position);
                          selectedTires.add({
                            "tireId": tire.id,
                            "position": position,
                          });
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      } else {
        ToastHelper.showCustomToast(
            context, "Failed to fetch tire data", Colors.red, Icons.error);
      }
    } catch (e) {
      ToastHelper.showCustomToast(
          context, "Error fetching tires: $e", Colors.red, Icons.error);
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
        margin: EdgeInsets.symmetric(vertical: 5),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    offset: Offset(leftOffset, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        axle.tires1.length,
                        (index) => Transform.translate(
                          offset: Offset(index * -10.0, 0),
                          child: _buildWheel(axle.tires1[index], axle.id, "L",
                              index + 1, axles.length),
                        ),
                      ),
                    ),
                  ),

                  // Axle Line
                  Container(
                    width: 60,
                    height: 2,
                    color: Colors.grey,
                  ),

                  // Right side tires
                  Transform.translate(
                    offset: Offset(-10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        axle.tires2.length,
                        (index) => Transform.translate(
                          offset: Offset(index * -10.0, 0),
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
          onTap: () => _selectBrand(tire, pos, axleId),
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tire.brand.isEmpty ? Colors.grey : Colors.blue,
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                pos,
                style: TextStyle(color: Colors.black, fontSize: 10),
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            tire.brand.isNotEmpty ? tire.brand : "Select Brand",
            style: TextStyle(
              color: tire.brand.isEmpty ? Colors.red : Colors.grey,
              fontSize: 10,
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Truck Axle & Tire Animation")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 150,
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
            children: [
              ElevatedButton(
                onPressed: _submit,
                child: Text("Submit"),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
