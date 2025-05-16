import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aquasave/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaporanScreen extends StatefulWidget {
  final String userId;
  final String iotId;

  const LaporanScreen({super.key, required this.userId, required this.iotId});

  @override
  _LaporanScreenState createState() => _LaporanScreenState();
}

class _LaporanScreenState extends State<LaporanScreen> {
  String selectedFilter = 'hari';
  List<Map<String, dynamic>> historyData = [];
  bool isLoading = true;
  String userId = '';
  String iotId = '';
  String? error; // Menambahkan variabel error untuk menangani kesalahan
  String selectedPeriode = "Mingguan"; // Menambahkan variabel untuk periode yang dipilih

  @override
  void initState() {
    super.initState();
    loadUserData(); // Pastikan dipanggil saat halaman dibuka
    fetchData();
  }

Future<void> loadUserData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
    userId = prefs.getString('userId') ?? '';
    iotId = prefs.getString('iotId') ?? '';
  });

  print("🔍 User ID dari SharedPreferences: $userId");
  print("🔍 IoT ID dari SharedPreferences: $iotId");

  if (userId.isEmpty || iotId.isEmpty) {
    print("⚠️ Error: userId atau iotId kosong!");
  } else {
    print("✅ Data berhasil dimuat!");
  }
}


Future<void> fetchData() async {
  try {
    final responseData = await ApiService.getWaterUsage("hari");
    print("📊 Data yang diterima: $responseData"); // Tambahkan di sini
    if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
      setState(() {
        historyData = List<Map<String, dynamic>>.from(responseData['data']); // Ganti _chartData dengan historyData
      });
    } else {
      throw Exception("Format data tidak sesuai");
    }
  } catch (e) {
    print("❌ Error mengambil data: $e");
    setState(() {
      error = e.toString(); // Menyimpan pesan error untuk ditampilkan
    });
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        elevation: 0,
        title: Text(
          "Penggunaan Air",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : error != null
              ? _buildErrorWidget()
              : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            error!,
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: fetchData, // Memanggil ulang fetchHistoryData
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPeriodSelector(),
          SizedBox(height: 16),
          _buildChartCard(),
          SizedBox(height: 16),
          _buildStatsCard(),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: DropdownButtonFormField<String>(
          value: selectedPeriode,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            labelText: "Periode",
          ),
          items: ["Mingguan", "Bulanan", "Tahunan"]
              .map((periode) => DropdownMenuItem(
                    value: periode,
                    child: Text(periode),
                  ))
              .toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                selectedPeriode = value;
                fetchData(); // Memanggil ulang fetchHistoryData saat periode berubah
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildChartCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              "Grafik Penggunaan Air $selectedPeriode",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1.5,
              child: LineChart(_buildLineChartData()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ringkasan",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoBox(
                  title: "Total",
                  value: "${historyData.isNotEmpty ? historyData.map((e) => e['total']).reduce((a, b) => a + b) : 0} L",
                  icon: Icons.water_drop,
                ),
                InfoBox(
                  title: "Rata-rata",
                  value: "${historyData.isNotEmpty ? (historyData.map((e) => e['average']).reduce((a, b) => a + b) / historyData.length).toStringAsFixed(2) : 0} L",
                  icon: Icons.show_chart,
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InfoBox(
                  title: "Tertinggi",
                  value: "${historyData.isNotEmpty ? historyData.map((e) => e['highest']).reduce((a, b) => a > b ? a : b) : 0} L",
                  icon: Icons.arrow_upward,
                ),
                InfoBox(
                  title: "Terendah",
                  value: "${historyData.isNotEmpty ? historyData.map((e) => e['lowest']).reduce((a, b) => a < b ? a : b) : 0} L",
                  icon: Icons.arrow_downward,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartData _buildLineChartData() {
    // Implementasi data grafik sesuai dengan historyData
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 50,
      ),
      titlesData: FlTitlesData(
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 50,
            getTitlesWidget: (value, meta) {
              return Text(
                '${value.toInt()}',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              );
            },
            reservedSize: 30,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              int index = value.toInt();
              if (index >= 0 && index < historyData.length) {
                return Text(
                  historyData[index]['label'], // Mengambil label dari historyData
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                );
              }
              return Text('');
            },
            reservedSize: 22,
          ),
        ),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      ),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(
          spots: historyData.map((e) => FlSpot(e['x'], e['y'])).toList(), // Mengambil data dari historyData
          isCurved: true,
          barWidth: 4,
          color: Colors.blue,
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.blue.withOpacity(0.3), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          dotData: FlDotData(show: true),
        ),
      ],
    );
  }
}

class InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.blue, size: 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}
