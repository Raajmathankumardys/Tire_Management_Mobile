import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../helpers/components/themes/app_colors.dart';
import '../../helpers/components/widgets/button/app_primary_button.dart';

class FilterExpenseScreen extends StatelessWidget {
  const FilterExpenseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Center(
            child:
                Text("Filters", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          backgroundColor: AppColors.secondaryColor,
          leading: IconButton(
              onPressed: () {}, icon: const Icon(Icons.arrow_back_ios))),
      body: Padding(
        padding: EdgeInsets.all(12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Date Range",
              style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.w700),
            ),
            Wrap(
              spacing: 5.h,
              children: [
                Chip(label: Text("Day Before Yesterday")),
                Chip(label: Text("Yesterday")),
                Chip(label: Text("Today")),
                Chip(label: Text("Tommorow")),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Trip Id",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.h),
                ),
                SizedBox(
                  height: 3.h,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Trip Id",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search)),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Vehicle Number",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.h),
                ),
                SizedBox(
                  height: 3.h,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Vehicle Number",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search)),
                ),
              ],
            ),
            SizedBox(
              height: 5.h,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver Name",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.h),
                ),
                SizedBox(
                  height: 3.h,
                ),
                TextField(
                  decoration: InputDecoration(
                      hintText: "Driver",
                      hintStyle: TextStyle(color: Colors.grey),
                      suffixIcon: Icon(Icons.search)),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: AppPrimaryButton(onPressed: () {}, title: "Apply Filters"),
            )
          ],
        ),
      ),
    );
  }
}
