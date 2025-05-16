import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aquasave/models/iot_model.dart';

class SharedPrefIOT {
  static Future<void> saveTools(IoTTool user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("tools", jsonEncode(user.toJson()));
  }

  static Future<IoTTool?> getTools() async {
    final prefs = await SharedPreferences.getInstance();
    String? userData = prefs.getString("tools");

    print("Data dari SharedPreferences: $userData"); // Debugging

    if (userData != null) {
      return IoTTool.fromJson(jsonDecode(userData));
    }
    return null;  // Jika tidak ada data, kembalikan null
  }

  static Future<void> clearTools() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("tools");
  }
}
