import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:yaantrac_app/Expense_Tracker/Trip-Profit-Summary/presentation/screen/transaction.dart';
import 'package:yaantrac_app/commonScreen/Homepage.dart';
import 'package:yaantrac_app/helpers/constants.dart';
import '../../../../../Expense_Tracker/Trip-Profit-Summary/presentation/screen/trip_profit_summary_screen.dart';
import '../../../../../Expense_Tracker/Trips/cubit/trips_cubit.dart';
import '../../../../../Expense_Tracker/Trips/cubit/trips_state.dart';
import '../../../../../Expense_Tracker/Trips/presentation/screen/trips_screen.dart';
import '../../../../../Expense_Tracker/Trips/repository/trips_repository.dart';
import '../../../../../Expense_Tracker/Trips/service/trips_service.dart';
import '../../../../../helpers/components/themes/app_colors.dart';

class TripViewPage extends StatefulWidget {
  final String tripId;
  final Trip trip;
  final int? index;
  final String? vehicleId;
  const TripViewPage(
      {super.key,
      required this.tripId,
      required this.trip,
      this.index,
      this.vehicleId});

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
        length: 2, // Three sections: Trip Details, Expenses, Income
        child: Scaffold(
          appBar: AppBar(
            title: const Center(
              child: Text(
                tripprofitsummary.appbar,
                style: TextStyle(color: Colors.white),
              ),
            ),
            backgroundColor: AppColors.secondaryColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () {
                widget.vehicleId == null
                    ? Navigator.pop(context)
                    : Navigator.push(
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
                                  return TripCubit(repo)
                                    ..fetchTrip(vehicleId: widget.vehicleId);
                                },
                              ),
                            ],
                            child: TripsScreen(
                              vehicleId: widget.vehicleId,
                            ),
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
                Tab(text: tripprofitsummary.transaction),
                Tab(text: tripprofitsummary.tripsummary)
              ],
            ),
          ),
          body: TabBarView(
            children: [
              TransactionScreen(
                tripId: widget.trip.id!,
                trip: widget.trip,
                vehicleId: widget.vehicleId,
              ),
              TripProfitSummaryScreen(
                trip: widget.trip,
              ) // First tab for trip details
            ],
          ),
        ));
  }
}
