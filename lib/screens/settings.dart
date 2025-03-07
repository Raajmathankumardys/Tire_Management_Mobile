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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Help & Support",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("📧 Email: support@yaantrac.com",
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 10),
              Text("📞 Phone: +1-800-123-4567", style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close", style: TextStyle(fontSize: 16)),
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
        title: Center(
          child:
              Text("Settings", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        backgroundColor: isDarkMode ? Colors.black : Colors.blueAccent,
      ),
      body: ListView(
        children: [
          SizedBox(height: 40),
          Card(
            child: ListTile(
              leading: Icon(Icons.brightness_6),
              title: Text("Dark Mode"),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) => themeProvider.toggleTheme(value),
              ),
            ),
          ),
          SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: Icon(Icons.help_outline),
              title: Text("Help & Support"),
              onTap: () => _showHelpSupportBottomSheet(context),
            ),
          )
        ],
      ),
    );
  }
}
