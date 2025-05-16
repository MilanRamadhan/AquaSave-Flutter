import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquasave/models/user_model.dart';

class SharedPref {
  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("user", jsonEncode(user.toJson()));
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("user");

    print("Data dari SharedPreferences: $userData"); // Debugging

    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;  // Jika tidak ada data, kembalikan null
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user");
  }
}
