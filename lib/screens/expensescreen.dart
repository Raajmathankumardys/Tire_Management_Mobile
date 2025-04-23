import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import '../TMS/Expense/presentation/screen/expense_screen.dart';
import '../TMS/Income/presentation/screen/income_screen.dart';
import '../TMS/Trip-Profit-Summary/presentation/screen/trip_profit_summary_screen.dart';
import '../TMS/Trips/cubit/trips_cubit.dart';
import '../TMS/Trips/cubit/trips_state.dart';
import '../TMS/Trips/presentation/screen/trips_screen.dart';
import '../TMS/Trips/repository/trips_repository.dart';
import '../TMS/Trips/service/trips_service.dart';
import '../TMS/helpers/components/themes/app_colors.dart';

class TripViewPage extends StatefulWidget {
  final int tripId;
  final Trip trip;
  final int? index;
  final int vehicleId;
  const TripViewPage(
      {super.key,
      required this.tripId,
      required this.trip,
      this.index,
      required this.vehicleId});

  @override
  State<TripViewPage> createState() => _TripViewPageState();
}

class _TripViewPageState extends State<TripViewPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: widget.index ?? 0,
        length: 3, // Three sections: Trip Details, Expenses, Income
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text("Trip Overview"),
            ),
            backgroundColor: AppColors.secondaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        Provider<TripService>(
                          create: (_) => TripService(),
                        ),
                        BlocProvider<TripCubit>(
                          create: (context) {
                            final service = context.read<TripService>();
                            final repo = TripRepository(service);
                            return TripCubit(repo)..fetchTrip(widget.vehicleId);
                          },
                        ),
                      ],
                      child: TripsScreen(vehicleid: widget.vehicleId),
                    ),
                  ),
                );
              },
            ),
            bottom: const TabBar(
              labelColor: Colors.black,
              indicatorColor: Colors.white,
              dividerColor: Colors.white,
              unselectedLabelColor: Colors.white,
              tabs: [
                Tab(text: "Trip View"),
                Tab(text: "Expenses"),
                Tab(text: "Income"),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TripProfitSummaryScreen(
                  trip: widget.trip), // First tab for trip details
              ExpenseScreen(tripId: widget.tripId), // Second tab for expenses
              IncomeScreen(tripId: widget.trip.id!), // Third tab for income
            ],
          ),
        ));
  }
}
