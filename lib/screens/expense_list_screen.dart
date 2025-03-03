// import 'package:flutter/material.dart';
// import 'package:yaantrac_app/models/expense.dart';
// import 'package:yaantrac_app/screens/add_expense_screen.dart';
// import 'package:yaantrac_app/screens/add_income_screen.dart';
// import 'package:yaantrac_app/services/api_service.dart';
//
// import '../common/widgets/button/app_primary_button.dart';
//
// class ExpensesListScreen extends StatefulWidget {
//   final int tripId;
//   const ExpensesListScreen({super.key,required this.tripId});
//
//   @override
//   State<ExpensesListScreen> createState() => _ExpensesListScreenState();
// }
//
// class _ExpensesListScreenState extends State<ExpensesListScreen> {
//   late Future<List<ExpenseModel>> futureExpenses;
//   int _selectedIndex=0;
//
//   @override
//   void initState() {
//     super.initState();
//     futureExpenses = getExpenses();
//   }
//
//   Future<List<ExpenseModel>> getExpenses() async {
//     try {
//       final response = await APIService.instance.request(
//         "/expenses/trip/${widget.tripId}",
//         DioMethod.get,
//         contentType: "application/json",
//       );
//       if (response.statusCode == 200) {
//         Map<String, dynamic> responseData = response.data;
//         List<dynamic> expenseList = responseData['data'];
//         return expenseList.map((json) => ExpenseModel.fromJson(json)).toList();
//       } else {
//         throw Exception("Error: ${response.statusMessage}");
//       }
//     } catch (e) {
//       throw Exception("Error fetching expenses: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("Expenses & Income"),
//           bottom: TabBar(
//             onTap: (index){
//               setState(() {
//                 _selectedIndex=index;
//               });
//             },
//               tabs: const [
//             Tab(child: Text("Expense",style: TextStyle(color: Colors.white),),),
//             Tab(icon: Icon(Icons.wallet)),
//           ]),
//           leading: IconButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//             icon: const Icon(Icons.arrow_back),
//           ),
//         ),
//         bottomNavigationBar: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Row(
//             children: [
//               Expanded(
//                 child: AppPrimaryButton(
//                   onPressed: () {
//                     if(_selectedIndex==0)
//                     {
//                         Navigator.push(context, MaterialPageRoute(builder:(context)=>const AddExpenseScreen()));
//                     }
//                     else{
//                       Navigator.push(context, MaterialPageRoute(builder: (context)=>const AddIncomeScreen()));
//                     }
//                   },
//                   title:_selectedIndex==0?"Add Expense":"Add Income",
//                 ),
//               ),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [SafeArea(
//             child: FutureBuilder<List<ExpenseModel>>(
//               future: futureExpenses,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No expenses available"));
//                 } else {
//                   List<ExpenseModel> expenses = snapshot.data!;
//                   return ListView.builder(
//                     padding: const EdgeInsets.all(16),
//                     itemCount: expenses.length,
//                     itemBuilder: (context, index) {
//                       final expense = expenses[index];
//                       return Column(
//                         children: [
//                           _buildExpenseListItem(expense: expense),
//                           const SizedBox(height: 8),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               },
//             ),
//           ),const Text("Expenses")],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExpenseListItem({required ExpenseModel expense}) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             const Icon(Icons.receipt_long, size: 48, color: Colors.blueGrey),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     expense.category.toString().split('.').last,
//                     style: const TextStyle(
//                       color: Colors.black,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                   Text(
//                     'Amount: ₹${expense.amount.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       color: Color(0xFF93adc8),
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     'Date: ${expense.expenseDate.toLocal()}'.split(' ')[0],
//                     style: const TextStyle(
//                       color: Color(0xFF93adc8),
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     'Description: ${expense.description}',
//                     style: const TextStyle(
//                       color: Color(0xFF93adc8),
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             MenuAnchor(
//               builder: (BuildContext context, MenuController controller, Widget? child) {
//                 return IconButton(
//                   icon: const Icon(Icons.more_vert),
//                   onPressed: () => controller.open(),
//                 );
//               },
//               menuChildren: [
//                 MenuItemButton(
//                   child: const Text('Update'),
//                   onPressed: () {
//                     // Handle update logic
//                   },
//                 ),
//                 MenuItemButton(
//                   child: const Text('Delete'),
//                   onPressed: () {
//                     // Handle delete logic
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
// }

import 'package:flutter/material.dart';
import 'package:yaantrac_app/models/expense.dart';
import 'package:yaantrac_app/models/income.dart';
import 'package:yaantrac_app/screens/add_expense_screen.dart';
import 'package:yaantrac_app/screens/add_income_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';
import '../common/widgets/button/app_primary_button.dart';

class ExpensesListScreen extends StatefulWidget {
  final int tripId;
  const ExpensesListScreen({super.key, required this.tripId});

  @override
  State<ExpensesListScreen> createState() => _ExpensesListScreenState();
}

class _ExpensesListScreenState extends State<ExpensesListScreen> {
  late Future<List<ExpenseModel>> futureExpenses;
  late Future<List<IncomeModel>> futureIncomes;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    futureExpenses = getExpenses();
    futureIncomes = getIncomes();
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
        "/tires/$tireId",
        DioMethod.delete,
      );
      String tid = tireId.toString();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Tire to deleted successfully!"),
          ),
        );
        Navigator.pop(context);
      } else {
        print("Error: ${response.statusMessage}");
      }
    } catch (err) {
      print("Delete Error: $err");
    }
  }

  Future<List<ExpenseModel>> getExpenses() async {
    try {
      final response = await APIService.instance.request(
        "/expenses/trip/${widget.tripId}",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> expenseList = response.data['data'];
        return expenseList.map((json) => ExpenseModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching expenses: $e");
    }
  }

  Future<List<IncomeModel>> getIncomes() async {
    try {
      final response = await APIService.instance.request(
        "/income?tripId=${widget.tripId}",
        DioMethod.get,
        contentType: "application/json",
      );
      if (response.statusCode == 200) {
        List<dynamic> incomeList = response.data['data'];
        return incomeList.map((json) => IncomeModel.fromJson(json)).toList();
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (e) {
      throw Exception("Error fetching incomes: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlue,
          title: const Text("Expenses & Income"),
          bottom: TabBar(
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              Tab(
                  child:
                      Text("Expense", style: TextStyle(color: Colors.white))),
              Tab(child: Text("Income", style: TextStyle(color: Colors.white))),
            ],
          ),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: AppPrimaryButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => _selectedIndex == 0
                            ? const AddExpenseScreen()
                            : const AddIncomeScreen(),
                      ),
                    );
                  },
                  title: _selectedIndex == 0 ? "Add Expense" : "Add Income",
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildExpenseTab(),
            _buildIncomeTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseTab() {
    return FutureBuilder<List<ExpenseModel>>(
      future: futureExpenses,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No expenses available"));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildExpenseListItem(expense: snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildIncomeTab() {
    return FutureBuilder<List<IncomeModel>>(
      future: futureIncomes,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No incomes available"));
        } else {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return _buildIncomeListItem(income: snapshot.data![index]);
            },
          );
        }
      },
    );
  }

  Widget _buildExpenseListItem({required ExpenseModel expense}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            const Icon(Icons.receipt_long, size: 48, color: Colors.blueGrey),
            const SizedBox(width: 16),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    expense.category.toString().split('.').last,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Amount: ₹${expense.amount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Date: ${expense.expenseDate.toLocal()}'.split(' ')[0],
                    style: const TextStyle(
                      color: Color(0xFF93adc8),
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    'Description: ${expense.description}',
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
                _ActionButtonEdit(
                    icon: Icons.edit,
                    onPressed: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTireScreen(tire: tire),
                        ),
                      );*/

                      //_onDelete(tire.tireId.toString());
                    }),
                const SizedBox(width: 8),
                _ActionButtonDelete(
                    icon: Icons.delete,
                    onPressed: () {
                      //_confirmDelete(tire.tireId!.toInt());
                    }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIncomeListItem({required IncomeModel income}) {
    return _buildListItem(
      title: "Income",
      amount: income.amount,
      date: income.incomeDate,
      description: income.description,
    );
  }

  Widget _buildListItem(
      {required String title,
      required double amount,
      required DateTime date,
      required String description}) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500)),
                  Text('Amount: ₹${amount.toStringAsFixed(2)}'),
                  Text('Date: ${date.toLocal()}'.split(' ')[0]),
                  Text('Description: $description'),
                ],
              ),
              SizedBox(
                width: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _ActionButtonEdit(
                      icon: Icons.edit,
                      onPressed: () {
                        /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddEditTireScreen(tire: tire),
                        ),
                      );*/

                        //_onDelete(tire.tireId.toString());
                      }),
                  const SizedBox(width: 8),
                  _ActionButtonDelete(
                      icon: Icons.delete,
                      onPressed: () {
                        //_confirmDelete(tire.tireId!.toInt());
                      }),
                ],
              ),
            ],
          )),
    );
  }
}

class _ActionButtonEdit extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButtonEdit({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: Colors.green),
      onPressed: onPressed,
    );
  }
}

class _ActionButtonDelete extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ActionButtonDelete({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(icon, color: Colors.red), onPressed: onPressed);
  }
}
