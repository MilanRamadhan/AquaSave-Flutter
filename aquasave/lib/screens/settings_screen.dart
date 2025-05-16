import 'package:aquasave/screens/change_password_screen.dart';
import 'package:aquasave/widgets/bottom_navbar.dart';
import 'package:flutter/material.dart';
import 'notification_settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:aquasave/providers/user_provider.dart';
import 'package:aquasave/screens/login_screen.dart';
import 'package:aquasave/utils/shared_pref.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      bottomNavigationBar: BottomNavBar(currentIndex: 2),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Pengaturan",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          // Keamanan Section
          _buildSectionHeader("Keamanan"),
          SettingItem(
            icon: Icons.lock,
            title: "Pengaturan Kata Sandi",
            subtitle: "Ubah kata sandi akun Anda",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
              );
            },
          ),

          SizedBox(height: 24),

          // Notifikasi Section
          _buildSectionHeader("Notifikasi"),
          SettingItem(
            icon: Icons.notifications,
            title: "Pengaturan Notifikasi",
            subtitle: "Atur preferensi notifikasi",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => NotificationSettingsScreen()),
              );
            },
          ),

          SizedBox(height: 24),

          // Akun Section
          _buildSectionHeader("Akun"),
          SettingItem(
            icon: Icons.logout,
            title: "Keluar",
            subtitle: "Keluar dari akun Anda",
            iconColor: Colors.red,
            textColor: Colors.red,
            onTap: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Konfirmasi Keluar"),
          content: Text("Apakah Anda yakin ingin keluar dari akun?"),
          actions: [
            TextButton(
              child: Text("Batal"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                "Keluar",
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                await SharedPref.clearUser();
                Provider.of<UserProvider>(context, listen: false).clearUser();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class SettingItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color iconColor;
  final Color textColor;

  SettingItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.subtitle = "",
    this.iconColor = Colors.blue,
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Icon(icon, color: iconColor),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
        subtitle: subtitle.isNotEmpty
            ? Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              )
            : null,
        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
