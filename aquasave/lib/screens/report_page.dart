import 'package:aquasave/services/api_service.dart';
import 'package:aquasave/utils/shared_pref.dart';
import 'package:flutter/material.dart';

class ReportPage extends StatefulWidget {
  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  String selectedPeriod = "Mingguan";
  List<dynamic> waterUsageData = [];
  List<dynamic> reportData = [];
  bool isLoading = true;
  String? error;
  String userId = ""; // Ganti dengan ID user dari SharedPref
  String iotId = ""; // Ganti dengan ID sensor IoT

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = await SharedPref.getUser();
    if (user != null) {
      setState(() {
        userId = user.id; // Ambil ID user dari SharedPref
        iotId = "YOUR_IOT_ID"; // Ganti dengan ID sensor IoT yang sesuai
      });
      fetchWaterUsage(); // Panggil fetchWaterUsage setelah mendapatkan userId dan iotId
    } else {
      setState(() {
        error = 'User tidak ditemukan';
        isLoading = false;
      });
    }
  }

  Future<void> fetchData() async {
    try {
      final response = await ApiService.getWaterUsage("bulanan");

      print("📊 Data yang diterima di ReportPage:");
      print(response);

      if (response.containsKey('data')) {
        setState(() {
          reportData = response['data'];
        });
      } else {
        throw Exception("Format data tidak sesuai");
      }
    } catch (e) {
      print("❌ Error di ReportPage: $e");
    }
  }

  Future<void> fetchWaterUsage() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final responseData = await ApiService.getHistoryData(
          userId, iotId, selectedPeriod.toLowerCase());

      if (responseData.isNotEmpty) {
        setState(() {
          waterUsageData = responseData;
          isLoading = false;
        });
      } else {
        throw Exception('Tidak ada data yang ditemukan');
      }
    } catch (e) {
      print('Error fetching water usage: $e');
      setState(() {
        error = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Laporan Penggunaan Air",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.blue.shade100,
      ),
      body: Column(
        children: [
          _buildPeriodSelector(),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              error!,
              style: TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWaterUsage,
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (waterUsageData.isEmpty) {
      return Center(
        child: Text('Tidak ada data untuk ditampilkan'),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: waterUsageData.length,
      itemBuilder: (context, index) {
        final item = waterUsageData[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: EdgeInsets.all(16),
            title: Text(
              "Waktu: ${item['_id']['time']}",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 8),
                Text(
                  "Total Penggunaan Air: ${item['totalUsedWater']} L",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.blue,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  _getStatus(item['totalUsedWater']),
                  style: TextStyle(
                    color: _getStatusColor(_getStatus(item['totalUsedWater'])),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedPeriod,
        decoration: InputDecoration(
          labelText: "Pilih Periode",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        items: ["Mingguan", "Bulanan", "Tahunan"]
            .map((periode) => DropdownMenuItem(
                  value: periode,
                  child: Text(periode),
                ))
            .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() => selectedPeriod = value);
            fetchWaterUsage();
          }
        },
      ),
    );
  }

  String _getStatus(num usage) {
    double dailyUsage = usage.toDouble();

    if (selectedPeriod == "Bulanan") {
      dailyUsage = usage / 30; // Rata-rata per hari dalam sebulan
    } else if (selectedPeriod == "Tahunan") {
      dailyUsage = usage / 365; // Rata-rata per hari dalam setahun
    }

    if (dailyUsage <= 800) {
      return "Normal";
    } else if (dailyUsage <= 1000) {
      return "Tinggi";
    } else {
      return "Sangat Tinggi";
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return Colors.green;
      case 'tinggi':
        return Colors.orange;
      case 'sangat tinggi':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
