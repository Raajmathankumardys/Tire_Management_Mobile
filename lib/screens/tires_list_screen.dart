import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/screens/add_tire_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import 'package:yaantrac_app/common/widgets/button/action_button.dart';

class TiresListScreen extends StatefulWidget {
  const TiresListScreen({super.key});

  @override
  State<TiresListScreen> createState() => _TiresListScreenState();
}

class _TiresListScreenState extends State<TiresListScreen> {
  late Future<List<TireModel>> futureTires;

  @override
  void initState() {
    futureTires = getTires();
    super.initState();
  }

  Future<void> _confirmDelete(int tireId) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this tire?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false), // No
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true), // Yes
            child: const Text("Yes", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _onDelete(tireId); // Call delete function if confirmed
    }
  }

  Future<void> _onDelete(int tireId) async {
    try {
      final response = await APIService.instance.request(
          "/tires/$tireId", DioMethod.delete,
          contentType: "application/json");
      String tid = tireId.toString();
      if (response.statusCode == 200) {
        print("API CAlled");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tire to deleted successfully!"),
          ),
        );
        getTires();
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  Future<List<TireModel>> getTires() async {
    try {
      final response = await APIService.instance.request(
        "/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        print("API CAlled");
        Map<String, dynamic> responseData = response.data;
        List<dynamic> tireList = responseData['data'];
        return tireList.map((json) => TireModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching tires: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tires"),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Expanded(
            child: AppPrimaryButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddEditTireScreen()),
                  ).then((value) => setState(() {
                        futureTires =
                            getTires(); // Refresh data after returning
                      }));
                  /* await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ,
                    ),
                  );
                  setState(() {
                    futureTires = getTires(); // Refresh data after returning
                  });*/
                },
                title: "Add Tire")),
      ),
      body: SafeArea(
        child: FutureBuilder<List<TireModel>>(
          future: futureTires,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No tires available"));
            } else {
              List<TireModel> tires = snapshot.data!;
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tires.length,
                itemBuilder: (context, index) {
                  final tire = tires[index];
                  return Column(
                    children: [
                      _buildTireListItem(
                        tire: tire,
                        context: context,
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildTireListItem(
      {required TireModel tire, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        if (tire.tireId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TireStatusScreen(tireId: tire.tireId!),
            ),
          );
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Tire not found!!")));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  "assets/vectors/tire.svg",
                  width: 10,
                  height: 10,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tire.brand,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Model: ${tire.model}',
                      style: const TextStyle(
                        color: Color(0xFF93adc8),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Size: ${tire.size}, Stock: ${tire.stock}',
                      style: const TextStyle(
                        color: Color(0xFF93adc8),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  ActionButton(
                    icon: Icons.edit,
                    color: Colors.green,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTireScreen(tire: tire),
                        ),
                      );
                    },
                  ),
                  SizedBox(width: 8),
                  ActionButton(
                    icon: Icons.delete,
                    color: Colors.red,
                    onPressed: () {
                      _confirmDelete(tire.tireId!.toInt());
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
