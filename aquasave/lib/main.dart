import 'package:aquasave/providers/user_provider.dart';
import 'package:aquasave/screens/report_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/panduan_screen.dart';
import 'screens/sensor_settings_page.dart';
import 'package:aquasave/screens/notification_screen.dart';
import 'package:aquasave/screens/laporan_screen.dart';
import 'package:aquasave/widgets/bottom_navbar.dart';
import 'package:aquasave/providers/iot_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => IoTProvider()), // Pastikan IoTProvider ada di sini
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AquaSave',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.grey[50],
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.blue.shade100,
          titleTextStyle: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
        ),
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatelessWidget {
  final List<MenuItemData> menuItems = [
    MenuItemData(
      icon: Icons.water_drop,
      title: "Penggunaan Air",
      subtitle: "Lihat penggunaan air hari ini",
      screen: LaporanScreen(userId: '', iotId: ''),
      usage: "5L",
      details: ["16 Jam", "51L / 800L"],
    ),
    MenuItemData(
      icon: Icons.insert_chart,
      title: "Laporan Penggunaan Air",
      screen: ReportPage(),
    ),
    MenuItemData(
      icon: Icons.menu_book,
      title: "Panduan Hemat Air",
      screen: PanduanScreen(),
    ),
    MenuItemData(
      icon: Icons.sensors,
      title: "Pengaturan Sensor",
      screen: SensorSettingsPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: BottomNavBar(currentIndex: 0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              SizedBox(height: 20),
              ...menuItems.map((item) => _buildMenuItem(context, item)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "Halo\nSelamat Datang",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.notifications, size: 30),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationScreen()),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context, MenuItemData item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => item.screen),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(15),
          ),
          padding: EdgeInsets.all(16),
          child: Row(
            children: [
              Column(
                children: [
                  Icon(item.icon, color: Colors.blue, size: 40),
                  if (item.usage != null)
                    Text(
                      item.usage!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (item.subtitle != null) Text(item.subtitle!),
                    if (item.details != null)
                      ...item.details!.map(
                        (detail) => Text(
                          detail,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItemData {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget screen;
  final String? usage;
  final List<String>? details;

  MenuItemData({
    required this.icon,
    required this.title,
    required this.screen,
    this.subtitle,
    this.usage,
    this.details,
  });
}
