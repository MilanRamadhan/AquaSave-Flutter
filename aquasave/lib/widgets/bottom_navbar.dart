import 'package:aquasave/main.dart';
import 'package:flutter/material.dart';
import 'package:aquasave/screens/profile_screen.dart';
import 'package:aquasave/screens/settings_screen.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;

  BottomNavBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.blue.shade100,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
      onTap: (index) {
        if (index == currentIndex) return; // Jika sudah di halaman tersebut, tidak pindah lagi

        Widget nextScreen;
        switch (index) {
          case 0:
            nextScreen = MainScreen();
            break;
          case 1:
            nextScreen = ProfileScreen();
            break;
          case 2:
            nextScreen = SettingsScreen();
            break;
          default:
            nextScreen = MainScreen();
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      },
    );
  }
}
