import 'package:aquasave/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  @override
  _NotificationSettingsScreenState createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool isMainNotificationOn = false;
  bool isSoundOn = true;
  bool isVibrationOn = false;
  bool isWaterReminderOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
    bottomNavigationBar: BottomNavBar(currentIndex: 2), // Set index sesuai halaman
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        title: Text("Pengaturan Notifikasi",
            style: TextStyle()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 6,
                    spreadRadius: 2),
              ],
            ),
            child: Column(
              children: [
                buildSwitchTile("Notifikasi Utama", isMainNotificationOn,
                    (value) {
                  setState(() {
                    isMainNotificationOn = value;
                  });
                }),
                buildSwitchTile("Suara", isSoundOn, (value) {
                  setState(() {
                    isSoundOn = value;
                  });
                }),
                buildSwitchTile("Getaran", isVibrationOn, (value) {
                  setState(() {
                    isVibrationOn = value;
                  });
                }),
                buildSwitchTile("Pengingat Air", isWaterReminderOn, (value) {
                  setState(() {
                    isWaterReminderOn = value;
                  });
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSwitchTile(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: TextStyle(fontSize: 16)),
      value: value,
      onChanged: onChanged,
      activeColor: Colors.blue.shade300,
    );
  }
}
