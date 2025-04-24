import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../helpers/components/themes/ThemeProvider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void _showHelpSupportBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Help & Support",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text("📧 Email: support@yaantrac.com",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text("📞 Phone: +1-800-123-4567",
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Settings",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.w),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Dark Mode"),
              trailing: ElevatedButton(
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
                child: Text("Toggle Theme"),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help & Support"),
              onTap: () => _showHelpSupportBottomSheet(context),
            ),
          ),
          SizedBox(height: 18.h),
          _buildFAQSection(),
        ],
      ),
    );
  }

  // 🔹 FAQs Section for Tire Management System
  Widget _buildFAQSection() {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ExpansionTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("How do I track tire wear?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    "Tire wear is tracked using sensors or manual inspections. The system records tire tread depth and alerts when replacement is needed.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.warning_amber_outlined),
              title: const Text("What are the common causes of tire damage?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    "Common causes include over/under-inflation, poor road conditions, misalignment, and excessive braking.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text("Can I integrate TPMS with this system?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    "Yes, the system supports Tire Pressure Monitoring Systems (TPMS) for real-time monitoring of pressure and temperature.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.schedule),
              title: const Text("How often should I rotate my tires?"),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    "It's recommended to rotate tires every 5,000 to 7,500 miles for even wear and extended lifespan.",
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
