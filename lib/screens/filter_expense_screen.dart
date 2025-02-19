import 'package:flutter/material.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';

class FilterExpenseScreen extends StatelessWidget {
  const FilterExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Filter"),
        leading: Builder(builder:(BuildContext context){
          return IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back));
        }),
      ),
      body: Padding(padding:const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Date Range",style: TextStyle(fontSize:18,fontWeight: FontWeight.w700),),
          const Wrap(
            spacing: 5,
            children: [
              Chip(label: Text("Yesterday")),Chip(label: Text("Yesterday")),Chip(label: Text("Yesterday")),Chip(label: Text("Yesterday")),
            ],
          ),
          const SizedBox(height: 10,),
          const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Trip Id",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
              SizedBox(height:3,),
              TextField(
                decoration: InputDecoration(hintText: "Trip Id",hintStyle: TextStyle(color: Colors.grey),suffixIcon: Icon(Icons.search)),
              ),
            ],
          ),
          const SizedBox(height: 5,),const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Vehicle Number",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
              SizedBox(height:3,),
              TextField(
                decoration: InputDecoration(hintText: "Vehicle Number",hintStyle: TextStyle(color: Colors.grey),suffixIcon: Icon(Icons.search)),
              ),
            ],
          ),
          const SizedBox(height: 5,),const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Driver Name",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
              SizedBox(height:3,),
              TextField(
                decoration: InputDecoration(hintText: "Driver",hintStyle: TextStyle(color: Colors.grey),suffixIcon: Icon(Icons.search)),
              ),
            ],
          ),
          const SizedBox(height: 15,),
          AppPrimaryButton(onPressed: (){}, title: "Apply Filters")
        ],
      ),
      ),
    );
  }
}
