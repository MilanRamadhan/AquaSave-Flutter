import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aquasave/utils/shared_pref_iot.dart';
import '../models/iot_model.dart';
import 'package:aquasave/providers/user_provider.dart';
import 'package:provider/provider.dart';

class IoTProvider with ChangeNotifier {
  List<IoTTool> _iotDevices = [];

  List<IoTTool> get iotDevices => _iotDevices;

  Future<Map<String, dynamic>> loadIoTDevices(BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user?.id; // Mengambil userId dari provider

      if (userId == null || userId.isEmpty) {
        throw Exception('User ID tidak ditemukan di UserProvider');
      }

      final url =
          Uri.parse('http://202.10.42.136/tool/getToolsByUserId/$userId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body)['data'];

        _iotDevices =
            responseData.map((item) => IoTTool.fromJson(item)).toList();
        notifyListeners();
        print("data iot : ${response.body}");
        return {'status': true, 'data': _iotDevices};
      } else {
        print('Gagal memuat data IoT: ${response.statusCode}'); // Menambahkan print ketika error
        throw Exception('Gagal memuat data IoT: ${response.statusCode}');
      }
    } catch (error) {
      print('❌ Error memuat data IoT: $error'); // Menambahkan print ketika error
      throw error;
    }
  }

  Future<void> loadTools() async {
    final tool = await SharedPrefIOT.getTools();
    if (tool != null) {
      _iotDevices = [tool]; // Mengubah menjadi List<IoTTool>
    } else {
      _iotDevices = []; // Jika tidak ada data, set menjadi list kosong
    }
    notifyListeners(); // Panggil notifyListeners setelah mengubah _iotDevices
  }

  Future<void> saveTools(IoTTool tool) async {
    await SharedPrefIOT.saveTools(tool);
    _iotDevices.add(tool); // Menambahkan tool ke dalam list
    notifyListeners(); // Panggil notifyListeners setelah menambahkan tool
  }
}
