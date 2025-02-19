import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/assets/app_images.dart';
import 'package:yaantrac_app/assets/app_vectors.dart';
import 'package:yaantrac_app/screens/add_tire_screen.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/tire_status_screen.dart';

class TiresListScreen extends StatelessWidget {
  const TiresListScreen({super.key});

 // Track expansion state for each item
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tires"),
        leading:IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon:const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddTireScreen()));
          }, icon: const Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16), // Add padding to the list
          itemCount: 4,
          itemBuilder: (context, index) {
            return Column(
              children: [
                _buildTireListItem(
                  replacementTime: "${index + 1} weeks",
                  stock: 3 + index,
                  minStock: 2 + index,
                  context: context,
                ),
                const SizedBox(height: 8), // Space between each panel
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTireListItem({
    required String replacementTime,
    required int stock,
    required int minStock,
    required context,
  }) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context,MaterialPageRoute(builder: (context)=>const TireStatusScreen()));
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
                    const Text(
                      'Michelin Defender',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'To be replaced in $replacementTime',
                      style: const TextStyle(
                        color: Color(0xFF93adc8),
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Stock: $stock, Min: $minStock',
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

