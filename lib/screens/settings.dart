import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../config/themes/ThemeProvider.dart';

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
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child:
              Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text("Help & Support"),
              onTap: () => _showHelpSupportBottomSheet(context),
            ),
          ),
          const SizedBox(height: 20),
          _buildFAQSection(),
        ],
      ),
    );
  }

  // 🔹 FAQs Section for Tire Management System
  Widget _buildFAQSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              leading: const Icon(Icons.info_outline),
              title: const Text("How do I track tire wear?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Tire wear is tracked using sensors or manual inspections. The system records tire tread depth and alerts when replacement is needed.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.warning_amber_outlined),
              title: const Text("What are the common causes of tire damage?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Common causes include over/under-inflation, poor road conditions, misalignment, and excessive braking.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text("Can I integrate TPMS with this system?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Yes, the system supports Tire Pressure Monitoring Systems (TPMS) for real-time monitoring of pressure and temperature.",
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.schedule),
              title: const Text("How often should I rotate my tires?"),
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
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
