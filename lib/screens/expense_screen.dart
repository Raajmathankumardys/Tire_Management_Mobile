import 'package:flutter/material.dart';
import 'package:yaantrac_app/common/widgets/button/app_primary_button.dart';
import 'package:yaantrac_app/models/trip_summary.dart';
import 'package:yaantrac_app/screens/add_expense_screen.dart';
import 'package:yaantrac_app/screens/expense_list_screen.dart';
import 'package:yaantrac_app/screens/vehicles_list_screen.dart';
import 'package:yaantrac_app/services/api_service.dart';

var _tripid;

class ExpenseScreen extends StatefulWidget {
  final int? tripid;
  const ExpenseScreen({super.key, required this.tripid});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  late Future<TripProfitSummaryModel> tripProfitSummary;

  Future<TripProfitSummaryModel> getTripProfit() async {
    print("API URL: /trips/summary?tripId=${widget.tripid}");
    try {
      final response = await APIService.instance.request(
          "https://yaantrac-backend.onrender.com/api/trips/summary?tripId=${widget.tripid}",
          DioMethod.get,
          contentType: "application/json");
      if (response.statusCode == 200) {
        // print("${response.data}");
        Map<String, dynamic> responseData = response.data;
        print(responseData);

        Map<String, dynamic> tripProfit = responseData['data'];
        // setState(() {
        //   tripProfitSummary=TripProfitSummaryModel.fromJson(tripProfit);
        // });
        return TripProfitSummaryModel.fromJson(tripProfit);
      } else {
        throw Exception("Error: ${response.statusMessage}");
      }
    } catch (err) {
      throw Exception("Error fetching summary: $err");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tripProfitSummary = getTripProfit();
    _tripid = widget.tripid;
  }

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
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VehiclesListScreen()),
            );
          },
        ),
      ),
      body: FutureBuilder<TripProfitSummaryModel>(
        future: tripProfitSummary,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("No report available"));
          } else {
            final tripProfitSummary = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Trip Summary',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 400,
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 3 / 2,
                      children: [
                        ExpenseCard(
                            title: 'Fuel cost',
                            amount:
                                '\$${tripProfitSummary?.breakDown["FUEL"] ?? 0}'),
                        ExpenseCard(
                            title: 'Driver Allowances',
                            amount:
                                '\$${tripProfitSummary?.breakDown["DRIVER_ALLOWANCE"] ?? 0}'),
                        ExpenseCard(
                            title: 'Tolls',
                            amount:
                                '\$${tripProfitSummary?.breakDown["TOLL"] ?? 0}'),
                        ExpenseCard(
                            title: 'Maintenance',
                            amount:
                                '\$${tripProfitSummary?.breakDown["MAINTENANCE"] ?? 0}'),
                        ExpenseCard(
                            title: 'Miscellanous',
                            amount:
                                '\$${tripProfitSummary?.breakDown["MISCELLANEOUS"] ?? 0}'),
                        ExpenseCard(
                            title: 'Income',
                            amount: '\$${tripProfitSummary?.totalIncome ?? 0}'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SummaryCard(
                          title: 'Expenses',
                          amount: "\$${tripProfitSummary?.totalExpenses}"),
                      const SizedBox(width: 16),
                      SummaryCard(
                          title: 'Profit by Trip',
                          amount: "\$${tripProfitSummary?.profit}"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  /*const Text(
                    'Breakdown',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const BreakdownItem(
                      title: 'Fuel cost', subtitle: 'Shell', amount: '\$48.00'),
                  const BreakdownItem(
                      title: 'Income',
                      subtitle: 'Amazon Flex',
                      amount: '\$100.00'),*/
                ],
              ),
            );
          }
        },
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                  child: AppPrimaryButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ExpensesListScreen(tripId: _tripid)));
                      },
                      title: "View")),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpenseCard extends StatelessWidget {
  final String title;
  final String amount;

  const ExpenseCard(
      {super.key, required this.title, required this.amount, required});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Text(amount,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  const SummaryCard(
      {super.key, required this.title, required this.amount, this.percentage});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text(amount,
              style:
                  const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          if (percentage != null)
            Text(
              percentage!,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.green,
                  fontWeight: FontWeight.bold),
            ),
        ],
      ),
    );
  }
}

/*class BreakdownItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String amount;

  const BreakdownItem(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.amount});

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
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              Text(subtitle,
                  style: const TextStyle(fontSize: 14, color: Colors.blueGrey)),
            ],
          ),
          Text(amount,
              style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}*/
