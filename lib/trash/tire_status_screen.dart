// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import '../TMS/helpers/components/themes/app_colors.dart';
// import '../TMS/helpers/components/widgets/Toast/Toast.dart';
// import '../TMS/helpers/components/widgets/button/app_primary_button.dart';
// import '../TMS/helpers/components/widgets/input/app_input_field.dart';
// import '../models/tire_performance.dart';
// import '../TMS/presentation/screen/Homepage.dart';
// import '../services/api_service.dart';
//
// import '../models/tire.dart';
//
// class TireStatusScreen extends StatefulWidget {
//   final TireModel tire;
//
//   const TireStatusScreen({super.key, required this.tire});
//
//   @override
//   State<TireStatusScreen> createState() => _TireStatusScreenState();
// }
//
// class _TireStatusScreenState extends State<TireStatusScreen> {
//   bool isLoading = true;
//   List<TirePerformanceModel> tirePerformances = [];
//
//   @override
//   void initState() {
//     fetchTireStatus();
//     super.initState();
//   }
//
//   void _showAddModal() {
//     final _formKey = GlobalKey<FormState>();
//     double pressure = 0.0;
//     double temperature = 0.0;
//     double wear = 0.0;
//     double distanctravelled = 0.0;
//     double treadDepth = 0.0;
//     bool isLoading = false;
//
//     showModalBottomSheet(
//         context: context,
//         isScrollControlled: true,
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
//         ),
//         builder: (
//           context,
//         ) {
//           return DraggableScrollableSheet(
//             initialChildSize: 0.40.h, // Starts at of screen height
//             minChildSize: 0.3.h, // Minimum height
//             maxChildSize: 0.50.h, // Maximum height
//             expand: false,
//             builder: (context, scrollController) {
//               return StatefulBuilder(builder: (context, setState) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius:
//                         BorderRadius.vertical(top: Radius.circular(35.r)),
//                   ),
//                   child: Expanded(
//                     child: Padding(
//                       padding: EdgeInsets.only(
//                         bottom: MediaQuery.of(context).viewInsets.bottom + 12.h,
//                       ),
//                       child: SingleChildScrollView(
//                         controller:
//                             scrollController, // Attach the scroll controller
//                         child: Form(
//                           key: _formKey,
//                           child: Column(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 height: 50.h,
//                                 decoration: BoxDecoration(
//                                   color: AppColors
//                                       .secondaryColor, // Adjust color as needed
//                                   borderRadius: BorderRadius.vertical(
//                                       top: Radius.circular(15.r)),
//                                 ),
//                                 child: Column(
//                                   children: [
//                                     SizedBox(height: 5.h),
//                                     Container(
//                                       width: 80.w,
//                                       height: 5.h,
//                                       padding: EdgeInsets.all(12.h),
//                                       decoration: BoxDecoration(
//                                         color: Colors.white,
//                                         borderRadius:
//                                             BorderRadius.circular(20.h),
//                                       ),
//                                     ),
//                                     SizedBox(height: 8.h),
//                                     Text(
//                                       "Add Tire Performance",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 16.h,
//                                         fontWeight: FontWeight.w500,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                   padding: EdgeInsets.only(
//                                     left: 12.w,
//                                     right: 12.w,
//                                     bottom: MediaQuery.of(context)
//                                             .viewInsets
//                                             .bottom +
//                                         12.h,
//                                     top: 12.h,
//                                   ),
//                                   child: Column(
//                                     children: [
//                                       AppInputField(
//                                         name: 'number_field',
//                                         label: "Pressure",
//                                         hint: "Enter pressure",
//                                         keyboardType: TextInputType.number,
//                                         defaultValue: pressure.toString(),
//                                         onInputChanged: (value) =>
//                                             pressure = double.parse(value!),
//                                       ),
//                                       AppInputField(
//                                         name: 'number_field',
//                                         label: "Temperature",
//                                         hint: "Enter temperature",
//                                         keyboardType: TextInputType.number,
//                                         defaultValue: temperature.toString(),
//                                         onInputChanged: (value) =>
//                                             temperature = double.parse(value!),
//                                       ),
//                                       AppInputField(
//                                         name: 'number_field',
//                                         label: "Wear",
//                                         hint: "Enter wear",
//                                         keyboardType: TextInputType.number,
//                                         defaultValue: wear.toString(),
//                                         onInputChanged: (value) =>
//                                             wear = double.parse(value!),
//                                       ),
//                                       AppInputField(
//                                         name: 'number_field',
//                                         label: "Distance Travelled",
//                                         hint: "Enter distance travelled",
//                                         keyboardType: TextInputType.number,
//                                         defaultValue:
//                                             distanctravelled.toString(),
//                                         onInputChanged: (value) =>
//                                             distanctravelled =
//                                                 double.parse(value!),
//                                       ),
//                                       AppInputField(
//                                         name: 'number_field',
//                                         label: "Tread Depth",
//                                         hint: "Enter tread depth",
//                                         keyboardType: TextInputType.number,
//                                         defaultValue: treadDepth.toString(),
//                                         onInputChanged: (value) =>
//                                             treadDepth = double.parse(value!),
//                                       ),
//                                       isLoading
//                                           ? const CircularProgressIndicator()
//                                           : Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.spaceEvenly,
//                                               children: [
//                                                 Expanded(
//                                                     child: AppPrimaryButton(
//                                                         onPressed: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         title: "Cancel")),
//                                                 SizedBox(
//                                                   width: 10.h,
//                                                 ),
//                                                 Expanded(
//                                                     child: AppPrimaryButton(
//                                                         width: 130.h,
//                                                         onPressed: () async {
//                                                           if (_formKey
//                                                               .currentState!
//                                                               .validate()) {
//                                                             setState(() =>
//                                                                 isLoading =
//                                                                     true);
//                                                             final tirep =
//                                                                 TirePerformanceModel(
//                                                                     tireId:
//                                                                         null,
//                                                                     // tire:
//                                                                     //     widget.tire,
//                                                                     pressure:
//                                                                         pressure,
//                                                                     temperature:
//                                                                         temperature,
//                                                                     wear: wear,
//                                                                     distanceTraveled:
//                                                                         distanctravelled,
//                                                                     treadDepth:
//                                                                         treadDepth);
//                                                             try {
//                                                               final response =
//                                                                   await APIService
//                                                                       .instance
//                                                                       .request(
//                                                                 "https://yaantrac-backend.onrender.com/api/tires/${widget.tire.id}/add-performance",
//                                                                 DioMethod.post,
//                                                                 formData: tirep
//                                                                     .toJson(),
//                                                                 contentType:
//                                                                     "application/json",
//                                                               );
//                                                               if (response
//                                                                       .statusCode ==
//                                                                   200) {
//                                                                 ToastHelper.showCustomToast(
//                                                                     context,
//                                                                     "Performance added successfully",
//                                                                     Colors
//                                                                         .green,
//                                                                     Icons.add);
//
//                                                                 Navigator.of(
//                                                                         context)
//                                                                     .pushAndRemoveUntil(
//                                                                         MaterialPageRoute(
//                                                                             builder: (context) =>
//                                                                                 TireStatusScreen(
//                                                                                   tire: widget.tire,
//                                                                                 )),
//                                                                         (route) =>
//                                                                             false);
//                                                               } else {
//                                                                 ToastHelper.showCustomToast(
//                                                                     context,
//                                                                     "Failed to process request",
//                                                                     Colors
//                                                                         .green,
//                                                                     Icons.add);
//                                                               }
//                                                             } catch (err) {
//                                                               ToastHelper
//                                                                   .showCustomToast(
//                                                                       context,
//                                                                       "Error: $err",
//                                                                       Colors
//                                                                           .red,
//                                                                       Icons
//                                                                           .error);
//                                                             } finally {
//                                                               ToastHelper
//                                                                   .showCustomToast(
//                                                                       context,
//                                                                       "Network error Please try again.",
//                                                                       Colors
//                                                                           .red,
//                                                                       Icons
//                                                                           .error);
//                                                               if (mounted)
//                                                                 setState(() =>
//                                                                     isLoading =
//                                                                         false);
//                                                             }
//                                                           }
//                                                         },
//                                                         title: "Add"))
//                                               ],
//                                             ),
//                                     ],
//                                   ))
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               });
//             },
//           );
//         });
//   }
//
//   Future<void> fetchTireStatus() async {
//     try {
//       final response = await APIService.instance.request(
//         "https://yaantrac-backend.onrender.com/api/tires/${widget.tire.id}/performances",
//         DioMethod.get,
//         contentType: "application/json",
//       );
//
//       if (response.statusCode == 200) {
//         if (response.data is Map<String, dynamic>) {
//           if (response.data.containsKey("data") &&
//               response.data["data"] is List) {
//             List<dynamic> performanceList = response.data["data"];
//             List<TirePerformanceModel> fetchedData = performanceList
//                 .map((json) =>
//                     TirePerformanceModel.fromJson(json as Map<String, dynamic>))
//                 .toList();
//
//             setState(() {
//               tirePerformances = fetchedData;
//               isLoading = false;
//             });
//           } else {
//             throw Exception("Unexpected 'data' format in response");
//           }
//         } else if (response.data is List) {
//           List<TirePerformanceModel> fetchedData = (response.data as List)
//               .map((json) =>
//                   TirePerformanceModel.fromJson(json as Map<String, dynamic>))
//               .toList();
//
//           setState(() {
//             tirePerformances = fetchedData;
//             isLoading = false;
//           });
//         } else {
//           throw Exception("Unexpected response format");
//         }
//       } else {
//         throw Exception("API Error: ${response.statusMessage}");
//       }
//     } catch (e) {
//       debugPrint("Network Error: $e");
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return SafeArea(
//       child: Scaffold(
//         appBar: AppBar(
//           title: Center(
//             child: Text("Tire Performance"),
//           ),
//           backgroundColor: theme.brightness == Brightness.dark
//               ? Colors.black
//               : Colors.blueAccent,
//           leading: IconButton(
//               icon: Icon(Icons.arrow_back_ios,
//                   color: theme.brightness == Brightness.dark
//                       ? Colors.white
//                       : Colors.black),
//               onPressed: () => Navigator.of(context).pushAndRemoveUntil(
//                     MaterialPageRoute(
//                         builder: (context) => HomeScreen(
//                               currentIndex: 1,
//                             )),
//                     (route) => false,
//                   )),
//           actions: [
//             IconButton(
//                 onPressed: _showAddModal,
//                 icon: Icon(
//                   Icons.add_circle,
//                   color: Colors.black,
//                 ))
//           ],
//         ),
//         body: isLoading
//             ? Center(child: CircularProgressIndicator())
//             : tirePerformances.isEmpty
//                 ? Center(
//                     child: Text(
//                       "No data available",
//                     ),
//                   )
//                 : SingleChildScrollView(
//                     padding: EdgeInsets.all(16.h),
//                     child: Column(
//                       children: [
//                         _buildStatCard(
//                             "Average Pressure",
//                             "${_calculateAverage((e) => e.pressure)} PSI",
//                             theme),
//                         _buildStatCard(
//                             "Average Temperature",
//                             "${_calculateAverage((e) => e.temperature)} °C",
//                             theme),
//                         _buildStatCard("Average Wear",
//                             "${_calculateAverage((e) => e.wear)}", theme),
//                         _buildStatCard(
//                             "Average Distance",
//                             "${_calculateAverage((e) => e.distanceTraveled)} KM",
//                             theme),
//                         _buildStatCard(
//                             "Average Tread Depth",
//                             "${_calculateAverage((e) => e.distanceTraveled)} KM",
//                             theme),
//                         _buildGraph("Pressure Graph", "Pressure", theme),
//                         _buildGraph("Temperature Graph", "Temperature", theme),
//                         _buildGraph("Wear Graph", "Wear", theme),
//                         _buildGraph(
//                             "Distance Travelled Graph", "Distance", theme),
//                         _buildGraph("Tread Depth Graph", "Treaddepth", theme),
//                       ],
//                     ),
//                   ),
//       ),
//     );
//   }
//
//   Widget _buildStatCard(String title, String value, ThemeData theme) {
//     return Card(
//       elevation: 2.h,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
//       color:
//           theme.brightness == Brightness.dark ? Colors.grey[600] : Colors.white,
//       child: Padding(
//         padding: EdgeInsets.all(12.h),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               title,
//             ),
//             Text(
//               value,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildGraph(String title, String parameter, ThemeData theme) {
//     return Padding(
//       padding: EdgeInsets.only(top: 12.h),
//       child: Container(
//         padding: EdgeInsets.all(24.h),
//         decoration: BoxDecoration(
//           border: Border.all(color: theme.dividerColor),
//           borderRadius: BorderRadius.circular(12.r),
//           color: theme.cardColor,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black12,
//               blurRadius: 6.r,
//               offset: Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//             ),
//             SizedBox(height: 10.h),
//             SizedBox(
//               height: 210.h,
//               child: LineChartWidget(
//                   tirePerformances: tirePerformances, parameter: parameter),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String _calculateAverage(double Function(TirePerformanceModel) selector) {
//     if (tirePerformances.isEmpty) return "0";
//     double sum = tirePerformances.map(selector).reduce((a, b) => a + b);
//     return (sum / tirePerformances.length).toStringAsFixed(2);
//   }
// }
//
// class LineChartWidget extends StatelessWidget {
//   final List<TirePerformanceModel> tirePerformances;
//   final String parameter;
//
//   const LineChartWidget(
//       {super.key, required this.tirePerformances, required this.parameter});
//
//   List<FlSpot> getSpots() {
//     return List.generate(
//       tirePerformances.length,
//       (index) => FlSpot((index).toDouble(), _getValue(tirePerformances[index])),
//     );
//   }
//
//   double _getValue(TirePerformanceModel model) {
//     switch (parameter) {
//       case 'Pressure':
//         return model.pressure;
//       case 'Temperature':
//         return model.temperature;
//       case 'Wear':
//         return model.wear;
//       case 'Distance':
//         return model.distanceTraveled;
//       case 'Treaddepth':
//         return model.treadDepth;
//       default:
//         return 0;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: 200.h,
//           child: LineChart(
//             LineChartData(
//               lineBarsData: [
//                 LineChartBarData(
//                   spots: getSpots(),
//                   isCurved: true,
//                   barWidth: 2.h,
//                   color: Colors.blue,
//                   dotData: FlDotData(show: true),
//                 ),
//               ],
//               titlesData: FlTitlesData(
//                 leftTitles: AxisTitles(
//                   axisNameWidget: Text(
//                     parameter.toString(),
//                     style:
//                         TextStyle(fontSize: 10.h, fontWeight: FontWeight.bold),
//                   ),
//                   sideTitles: SideTitles(
//                       showTitles: false), // Hide individual Y-axis values
//                 ),
//                 bottomTitles: AxisTitles(
//                   axisNameWidget: Padding(
//                     padding: EdgeInsets.only(top: 0.0),
//                     child: Text(
//                       'Readings',
//                       style:
//                           TextStyle(fontSize: 8.h, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   sideTitles: SideTitles(
//                       showTitles: false), // Hide individual X-axis values
//                 ),
//               ),
//               gridData: FlGridData(show: true), // Shows grid lines
//               borderData: FlBorderData(show: true),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
