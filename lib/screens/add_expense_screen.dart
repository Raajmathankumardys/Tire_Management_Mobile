import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense", style:TextStyle(fontSize: 20),),
        actions: const [
          Icon(Icons.search),
        ],
        leading:Builder(builder:(BuildContext context){
          return IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back));
        }),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Add a new expense",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25),),
              const SizedBox(height:10,),
              Column(
                children: [
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Trip Id",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                      SizedBox(height:3,),
                      TextField(
                        decoration: InputDecoration(hintText: "Trip Id",hintStyle: TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Expense Type",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                      const SizedBox(height:3,),
                      // TextField(
                      //   decoration: InputDecoration(hintText: "Expense Type",hintStyle: TextStyle(color: Colors.grey)),
                      // ),
                      DropdownButtonFormField(items: const <DropdownMenuItem>[
                        DropdownMenuItem(value: "fuel",child: Text("Fuel Costs"),),
                        DropdownMenuItem(value:"driver",child: Text("Driver Allowances"),),
                        DropdownMenuItem(value:"toll",child: Text("Toll Charges"),),
                        DropdownMenuItem(value:"maintenance",child: Text("Maintenance"),),
                        DropdownMenuItem(value:"miscellaneous",child: Text("Maintenance"),),
                      ],onChanged: (val){},)
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Amount",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                      const SizedBox(height:3,),
                      TextField(
                        decoration: const InputDecoration(hintText: "Amount",hintStyle: TextStyle(color: Colors.grey)),
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Date",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                      const SizedBox(height:3,),
                      InputDatePickerFormField(firstDate: DateTime(DateTime.now().month), lastDate: DateTime(DateTime.now().month,
                      ))
                    ],
                  ),
                  const SizedBox(height: 20,),
                  const Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Description",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 18),),
                      SizedBox(height:3,),
                      TextField(
                      decoration: InputDecoration(hintText: "Description",hintStyle: TextStyle(color: Colors.grey)),
                      keyboardType: TextInputType.multiline, maxLines: null,

                      ),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  Row(
                    children: [
                      Expanded(child: AppPrimaryButton(onPressed: (){}, title: "Attach Reciept")),
                      const SizedBox(width: 10,),
                      Expanded(child: AppPrimaryButton(onPressed: (){}, title: "Submit")),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15,),
              const Column(
                children: [
                  Text("Summary",style: TextStyle(fontWeight: FontWeight.w800,fontSize: 25),),
                  SizedBox(height: 10,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Income",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      Text("1000",style: TextStyle(fontSize: 16,color: Colors.grey),),
                    ],
                  ),
                  SizedBox(height: 10,), Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Income",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      Text("1000",style: TextStyle(fontSize: 16,color: Colors.grey),),
                    ],
                  ),
                  SizedBox(height: 10,), Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Income",style: TextStyle(fontSize: 18,fontWeight: FontWeight.w500),),
                      Text("1000",style: TextStyle(fontSize: 16,color: Colors.grey),),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),

    );
  }
}
