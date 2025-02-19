import 'package:flutter/material.dart';
import 'package:yaantrac_app/screens/expense_screen.dart';
import 'package:yaantrac_app/screens/tires_list_screen.dart';

class VehiclesListScreen extends StatefulWidget {
  const VehiclesListScreen({super.key});

  @override
  State<VehiclesListScreen> createState() => _VehiclesListScreenState();
}

class _VehiclesListScreenState extends State<VehiclesListScreen> {
  final List<bool> _isExpandedList = [false, false, false, false]; // Track expansion state for each item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vehicle"),
        leading:IconButton(onPressed: (){}, icon:const Icon(Icons.arrow_back)),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16), // Add padding to the list
          itemCount: _isExpandedList.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                ExpansionPanelList(
                  elevation: 1,
                  expansionCallback: (panelIndex, isExpanded) {
                    setState(() {
                      _isExpandedList[index] = !_isExpandedList[index];
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: _buildTireListItem(
                            replacementTime: "${index + 1} weeks",
                            stock: 3 + index,
                            minStock: 2 + index,
                          ),
                        );
                      },
                      body: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: (){}, icon: const Icon(Icons.where_to_vote_outlined,color: Colors.blue,size:30,),tooltip: "Trips",),
                            IconButton(onPressed: (){}, icon: const Icon(Icons.route,color: Colors.green,size: 30,),tooltip: "Tires",),
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const TiresListScreen()));
                            }, icon: const Icon(Icons.tire_repair_sharp,color: Colors.grey,)),
                            IconButton(onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>const ExpenseScreen()));
                            }, icon: const Icon(Icons.wallet),color: Colors.yellow,tooltip: "Expense/Income",),
                          ],
                        ),
                      ),
                      isExpanded: _isExpandedList[index],
                      canTapOnHeader: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16), // Space between each panel
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
  }) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.directions_car,
            color: Colors.white,
            size: 24,
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
    );
  }
}
