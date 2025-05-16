import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aquasave/utils/shared_pref.dart';

class ApiService {
  static const String baseUrl = "http://202.10.42.136";

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Debugging

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            "Login gagal! Periksa kembali email dan password Anda.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat login: $e");
    }
  }

  static Future<Map<String, dynamic>> register(
      String fullName, String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(
            {"fullName": fullName, "email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception("Registrasi gagal! Silakan coba lagi.");
      }
    } catch (e) {
      throw Exception("Terjadi kesalahan saat registrasi: $e");
    }
  }

  static Future<Map<String, dynamic>> getWaterUsage(String period) async {
    try {
      final headers = await _getAuthHeaders();
      final user = await SharedPref.getUser();

      // 🔍 Debugging tambahan
      print("📌 User Object: $user");
      print("📌 User ID: ${user?.id}");

      if (user == null) {
        throw Exception("User tidak ditemukan, pastikan pengguna sudah login.");
      }

      String filter;
      switch (period.toLowerCase()) {
        case 'mingguan':
          filter = 'minggu';
          break;
        case 'bulanan':
          filter = 'bulan';
          break;
        case 'tahunan':
          filter = 'tahun';
          break;
        default:
          filter = 'hari';
      }

      final url = '$baseUrl/history/getHistory/${user.id}/?filter=$filter';
      print("🌐 Request API: $url");

      final response = await http.get(Uri.parse(url), headers: headers);

      // 🔍 Log Status Code & Response Body
      print("✅ Status Code: ${response.statusCode}");
      print("📨 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        throw Exception('Sesi Anda telah berakhir, silakan login kembali');
      } else {
        throw Exception('Gagal memuat data: ${response.body}');
      }
    } catch (e) {
      print("❌ Error: $e"); // 🔍 Log jika terjadi error
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  static Future<Map<String, String>> _getAuthHeaders() async {
    try {
      final user = await SharedPref.getUser();
      if (user?.token == null) {
        throw Exception('Token tidak ditemukan. Silakan login kembali.');
      }
      return {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${user!.token}",
      };
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil token: $e');
    }
  }

  static Future<void> updatePassword(
      String oldPassword, String newPassword) async {
    try {
      final headers = await _getAuthHeaders();
      final response = await http.put(
        Uri.parse('$baseUrl/auth/update-password'),
        headers: headers,
        body: jsonEncode(
            {"oldPassword": oldPassword, "newPassword": newPassword}),
      );

      if (response.statusCode != 200) {
        throw Exception('Gagal mengubah password. Silakan coba lagi.');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  // Logout
  static Future<http.Response> logoutUser(String userId) async {
    final response = await http.get(Uri.parse('$baseUrl/auth/logout/$userId'));
    return response;
  }

  // Get History Usage
  static Future<List<Map<String, dynamic>>> getHistoryData(
      String userId, String iotId, String filter) async {
    final response = await http.get(
      Uri.parse ('$baseUrl/history/getHistory/$userId/$iotId?filter=$filter'),
    );

    print('Response Code: ${response.statusCode}'); // 🛠 Debugging
    print('Response Body: ${response.body}'); // 🛠 Debugging

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Gagal mengambil data history');
    }
  }

  // Get IoT Tools by User ID
  static Future<http.Response> getIoTTools(String userId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/tool/getToolsByUserId/$userId'));
    return response;
  }
}
