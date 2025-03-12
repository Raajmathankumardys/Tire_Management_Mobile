import 'package:flutter/material.dart';
import 'dart:math';

import 'package:yaantrac_app/common/widgets/Toast/Toast.dart';

void main() {
  runApp(TruckAxleApp());
}

class TruckAxleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AxleAnimationPage(),
    );
  }
}

class Tire {
  int id;
  String brand;
  String model;
  int stock;

  Tire(this.id, {this.brand = "", this.model = "", required this.stock});

  static final brands = ["Michelin", "Goodyear", "Bridgestone", "Pirelli"];
  static final models = ["X-Series", "Duratrac", "Ecopia", "Scorpion"];

  static Tire generate(int id) {
    return Tire(
      id,
      brand: "", // Ensure brand is empty by default
      model: "", // Keep model empty if you want it to be selected later
      stock: Random().nextInt(50) + 1,
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
  @override
  _AxleAnimationPageState createState() => _AxleAnimationPageState();
}

class _AxleAnimationPageState extends State<AxleAnimationPage> {
  List<Axle> axles = [];
  List<Map<String, dynamic>> selectedTires = [];
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  @override
  void initState() {
    // TODO: implement initState
    _addAxle();
    super.initState();
  }

  void _removeAxle() {
    if (axles.isNotEmpty) {
      int lastIndex = axles.length - 1;

      // Remove item first from list
      Axle removedAxle = axles.removeAt(lastIndex);

      // Ensure AnimatedList still has a valid index
      _listKey.currentState?.removeItem(
        lastIndex,
        (context, animation) => _buildAxle(removedAxle, animation),
      );

      setState(() {});
    }
  }

  void _selectBrand(Tire tire, String position, int axleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Select Tire Brand"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: Tire.brands.map((brand) {
              return ListTile(
                title: Text(brand),
                onTap: () {
                  setState(() {
                    tire.brand = brand;

                    // Store selected tire info
                    selectedTires.removeWhere((item) =>
                        item["id"] == axleId && item["position"] == position);
                    selectedTires.add({
                      "id": axleId == 0 ? "null" : axleId,
                      "tire": tire,
                      "position": position,
                    });
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _submit() {
    // Check if all tires have a selected brand
    bool allTiresSelected = axles.every((axle) =>
        axle.tires1.every((tire) => tire.brand.isNotEmpty) &&
        axle.tires2.every((tire) => tire.brand.isNotEmpty));

    if (!allTiresSelected) {
      ToastHelper.showCustomToast(context,
          "All tires must have a selected brand", Colors.red, Icons.error);
      return;
    }

    // If validation passes, print tire data
    for (var entry in selectedTires) {
      print({
        "id": null, //?? entry["id"],
        "brand": entry["tire"].brand,
        "position": entry["position"],
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("All tires validated successfully!"),
        backgroundColor: Colors.green,
      ),
    );
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

  void _addTire(Axle axle) {
    if (axle.id == 0) return; // Prevent adding tires to the front axle
    setState(() {
      axle.tires1.add(Tire.generate(axle.tires1.length));
      axle.tires2.add(Tire.generate(axle.tires2.length));
    });
  }

  void _removeTire(Axle axle) {
    if (axle.id == 0) return; // Prevent removing tires from the front axle
    if (axle.tires1.isNotEmpty && axle.tires2.isNotEmpty) {
      setState(() {
        axle.tires1.removeLast();
        axle.tires2.removeLast();
      });
    }
  }

  Widget _buildAxle(Axle axle, Animation<double> animation) {
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
                axle.id == 0 ? "Front Axle" : "Axle ${axle.id + 1}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    spacing: 5,
                    children: List.generate(
                        axle.tires1.length,
                        (index) => _buildWheel(
                            axle.tires1[index], axle.id, "L", index + 1)),
                  ),
                  Center(
                    child: Container(
                      width: 50,
                      height: 20,
                      color: Colors.grey[600],
                    ),
                  ),
                  Wrap(
                    spacing: 5,
                    children: List.generate(
                        axle.tires2.length,
                        (index) => _buildWheel(
                            axle.tires2[index], axle.id, "R", index + 1)),
                  ),
                ],
              ),
            ),
            if (axle.id != 0) // Hide add/remove buttons for the front axle
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
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWheel(Tire tire, int axleId, String side, int position) {
    String pos = "$side$position"; // e.g., LL1, RL2

    return Column(
      children: [
        GestureDetector(
          onTap: () => _selectBrand(tire, pos, axleId),
          child: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: tire.brand.isEmpty
                  ? Colors.red
                  : Colors.black, // Highlight if not selected
              border: Border.all(color: Colors.white, width: 3),
            ),
            child: Center(
              child: Text(
                "${axleId + 1}$pos",
                style: TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ),
          ),
        ),
        SizedBox(height: 4),
        Center(
          child: Text(
            tire.brand.isNotEmpty ? tire.brand : "Select Brand",
            style: TextStyle(
              color: tire.brand.isEmpty
                  ? Colors.red
                  : Colors.grey, // Highlight if missing
              fontSize: 12,
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
        children: [
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: axles.length,
              itemBuilder: (context, index, animation) {
                return _buildAxle(axles[index], animation);
              },
            ),
          ),
          Row(
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
          ),
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
