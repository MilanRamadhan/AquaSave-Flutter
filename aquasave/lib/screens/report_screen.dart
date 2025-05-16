import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:aquasave/services/api_service.dart';
import 'package:aquasave/models/water_usage.dart';
import 'package:aquasave/core/theme/app_theme.dart';

class ReportScreen extends StatefulWidget {
  @override
  _ReportScreenState createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String _selectedPeriode = 'Mingguan';
  bool _isLoading = false;
  String? _error;
  List<WaterUsage> _usageData = [];
  Map<String, dynamic> _stats = {};

  @override
  void initState() {
    super.initState();
    _loadData('Mingguan');
  }

  Future<void> _loadData(String period) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final response = await ApiService.getWaterUsage(period);

      if (response['status'] == 'success' && response['data'] != null) {
        final List<dynamic> usageData = response['data'];

        final List<WaterUsage> waterUsages =
            usageData.map((item) => WaterUsage.fromJson(item)).toList();

        // Hitung statistik
        double total = waterUsages.fold(0, (sum, item) => sum + item.usage);
        double avg = total / waterUsages.length;
        double highest =
            waterUsages.map((e) => e.usage).reduce((a, b) => a > b ? a : b);
        double lowest =
            waterUsages.map((e) => e.usage).reduce((a, b) => a < b ? a : b);

        setState(() {
          _usageData = waterUsages;
          _stats = {
            'total': total,
            'average': avg,
            'highest': highest,
            'lowest': lowest,
          };
        });
      } else {
        throw Exception(response['message'] ?? 'Gagal memuat data');
      }
    } catch (e) {
      print('Error in _loadData: $e');
      setState(() => _error = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text("Laporan Penggunaan Air"),
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorWidget()
              : _buildContent(),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          Text('Periode:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButton<String>(
              value: _selectedPeriode,
              isExpanded: true,
              underline: SizedBox(),
              items: ['Mingguan', 'Bulanan', 'Tahunan'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedPeriode = newValue;
                  });
                  _loadData(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartCard() {
    if (_usageData.isEmpty) {
      return Center(child: Text('Tidak ada data'));
    }

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grafik Penggunaan Air',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 24),
          Container(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()}L');
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= _usageData.length) return Text('');
                        final date = _usageData[value.toInt()].date;
                        return Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Text(
                            _selectedPeriode == 'Mingguan'
                                ? '${date.day}/${date.month}'
                                : _selectedPeriode == 'Bulanan'
                                    ? '${date.month}'
                                    : '${date.month}/${date.year}',
                            style: TextStyle(fontSize: 12),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: true),
                lineBarsData: [
                  LineChartBarData(
                    spots: _usageData.asMap().entries.map((entry) {
                      return FlSpot(
                        entry.key.toDouble(),
                        entry.value.usage,
                      );
                    }).toList(),
                    isCurved: true,
                    color: AppTheme.primaryColor,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryColor.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Statistik',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          _buildStatRow(
              'Total Penggunaan', '${_stats['total']?.toStringAsFixed(0)}L'),
          _buildStatRow(
              'Rata-rata', '${_stats['average']?.toStringAsFixed(0)}L'),
          _buildStatRow(
              'Tertinggi', '${_stats['highest']?.toStringAsFixed(0)}L'),
          _buildStatRow('Terendah', '${_stats['lowest']?.toStringAsFixed(0)}L'),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 48, color: Colors.red),
          SizedBox(height: 16),
          Text(
            _error ?? 'Terjadi kesalahan',
            style: TextStyle(color: Colors.red),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => _loadData(_selectedPeriode),
            child: Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }
}
