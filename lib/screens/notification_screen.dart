import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Alerts & Notifications"),
        leading: IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back)),
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.clear_all_sharp)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              child: const Card(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Tire Pressure Low",style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20),),
                          Text("Tire pressure is low in 3rd",style: TextStyle(fontSize: 15),),                  ],
                      ),
                      Text("5m ago",style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
