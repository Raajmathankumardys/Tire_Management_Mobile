import 'package:flutter/material.dart';
import 'package:yaantrac_app/screens/add_expense_screen.dart';

// class ExpenseScreen extends StatelessWidget {
//   const ExpenseScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Expenses"),
//         actions: const [
//           Icon(Icons.settings),
//         ],
//       ),
//       body: const Padding(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(
//               width: double.infinity,
//               child: Card(
//                 child: Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text("Expense",
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.w500)),
//                       Text(r"$30000",
//                           style: TextStyle(
//                               fontSize: 35, fontWeight: FontWeight.w600)),
//                       Text("Last 30 days",
//                           style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w400,
//                               color: Colors.grey)),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20,),
//             Text("Category",style: TextStyle(fontSize:20,fontWeight: FontWeight.bold),),
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Fuel",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                             Text("Company Car fuel",style: TextStyle(color: Colors.grey),),
//                           ],
//                         ),
//                         Text(r"$1500",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                       ],
//                     ),
//                     SizedBox(height: 20,),
//                     LinearProgressIndicator(
//                       value: 10,
//                       color: Colors.blue,
//                       minHeight: 10,
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       backgroundColor: Colors.grey,
//                     ),
//                     SizedBox(height: 5,),
//                     Text("55%",style: TextStyle(color: Colors.grey,fontSize: 12),)
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(width: 10,),
//             Card(
//               child: Padding(
//                 padding: EdgeInsets.all(20.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text("Fuel",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                             Text("Company Car fuel",style: TextStyle(color: Colors.grey),),
//                           ],
//                         ),
//                         Text(r"$1500",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
//                       ],
//                     ),
//                     SizedBox(height: 20,),
//                     LinearProgressIndicator(
//                       value: 10,
//                       color: Colors.blue,
//                       minHeight: 10,
//                       borderRadius: BorderRadius.all(Radius.circular(10)),
//                       backgroundColor: Colors.grey,
//                     ),
//                     SizedBox(height: 5,),
//                     Text("55%",style: TextStyle(color: Colors.grey,fontSize: 12),)
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ExpenseScreen extends StatelessWidget {
  const ExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Trip 1: San Francisco - Los Angeles',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
          SizedBox(
          height: 260,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 3 / 2,
            children: const [
              ExpenseCard(title: 'Fuel cost', amount: '\$48.00'),
              ExpenseCard(title: 'Tolls', amount: '\$0.00'),
              ExpenseCard(title: 'Maintenance', amount: '\$0.00'),
              ExpenseCard(title: 'Income', amount: '\$100.00'),
            ],
          ),),
            const SizedBox(height: 16),
            const Row(
              children: [
                SummaryCard(title: 'Expenses', amount: '\$48.00', percentage: '+12%'),
                SizedBox(width: 16),
                SummaryCard(title: 'Profit by Trip', amount: '\$52.00'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Breakdown',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 8),
            const BreakdownItem(title: 'Fuel cost', subtitle: 'Shell', amount: '\$48.00'),
            const BreakdownItem(title: 'Income', subtitle: 'Amazon Flex', amount: '\$100.00'),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context)=>const AddExpenseScreen()));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Add expense',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;

  const ExpenseCard({super.key, required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const SizedBox(height: 8),
              Text(amount, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
    );
  }
}

class SummaryCard extends StatelessWidget {
  final String title;
  final String amount;
  final String? percentage;

  const SummaryCard({super.key, required this.title, required this.amount, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(amount, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (percentage != null)
            Text(
              percentage!,
              style: const TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

class BreakdownItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const BreakdownItem({super.key, required this.title, required this.subtitle, required this.amount});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              Text(subtitle, style:const TextStyle(fontSize: 14, color: Colors.blueGrey)),
            ],
          ),
          Text(amount, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}









