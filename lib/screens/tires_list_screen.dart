import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/models/tire.dart';
import 'package:yaantrac_app/screens/add_tire_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

class TiresListScreen extends StatefulWidget {
  const TiresListScreen({super.key});

  @override
  State<TiresListScreen> createState() => _TiresListScreenState();
}

class _TiresListScreenState extends State<TiresListScreen> {
  late Future<List<TireModel>> futureTires;

  @override
  void initState() {
    super.initState();
    futureTires = getTires();
  }

  Future<List<TireModel>> getTires() async {
    try {
      final response = await APIService.instance.request(
        "/tires",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
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
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddTireScreen()),
              ).then((_) {
                // Refresh tire list after adding a new tire
                setState(() {
                  futureTires = getTires();
                });
              });
            },
            icon: const Icon(Icons.add),
          )
        ],
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
                      const SizedBox(height: 8),
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

  Widget _buildTireListItem({required TireModel tire, required BuildContext context}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TireStatusScreen(tireId: tire.tireId),
          ),
        );
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
            ],
          ),
        ),
      ),
    );
  }
}

