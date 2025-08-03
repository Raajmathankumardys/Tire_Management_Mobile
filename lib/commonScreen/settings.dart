import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../helpers/components/themes/ThemeProvider.dart';
import '../helpers/constants.dart';

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
              const Text(settingsconstants.help,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              const Text(settingsconstants.email,
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 10),
              const Text(settingsconstants.phone,
                  style: TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(settingsconstants.close,
                      style: TextStyle(fontSize: 16)),
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
    bool isSwitched = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Center(
          child: Text(settingsconstants.appbar,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        ),
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            )),
        // leading: IconButton(
        //     onPressed: () {},
        //     icon: Icon(
        //       Icons.arrow_back_ios,
        //       color: Colors.white,
        //     )),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 20.w),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.brightness_6),
              title: Text(settingsconstants.darkmode),
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Card(
            child: ListTile(
              leading: const Icon(Icons.help_outline),
              title: const Text(settingsconstants.help),
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
              settingsconstants.faq,
              style: TextStyle(fontSize: 16.h, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.h),
            ExpansionTile(
              leading: const Icon(Icons.info_outline),
              title: const Text(settingsconstants.wear),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    settingsconstants.wearanswer,
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.warning_amber_outlined),
              title: const Text(settingsconstants.damage),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    settingsconstants.damageanswer,
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.settings),
              title: const Text(settingsconstants.tpms),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    settingsconstants.tpmsans,
                  ),
                )
              ],
            ),
            ExpansionTile(
              leading: const Icon(Icons.schedule),
              title: const Text(settingsconstants.rotate),
              children: [
                Padding(
                  padding: EdgeInsets.all(6.h),
                  child: Text(
                    settingsconstants.rotateans,
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
