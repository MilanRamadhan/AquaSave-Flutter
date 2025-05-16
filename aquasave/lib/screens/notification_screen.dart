import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Notifikasi"),
        backgroundColor: Colors.blue.shade100,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          NotificationItem(
            title: "Keran Air Menyala lebih Lama Dari Biasanya",
            message: "Tutup Segera untuk Menghemat!",
            time: "Today",
          ),
          NotificationItem(
            title: "Penggunaan Air Anda Hari ini Sudah Melebihi 500 Liter",
            message: "Mari lebih Hemat Untuk Sisa Hari ini.",
            time: "Yesterday",
          ),
          NotificationItem(
            title: "Anda Telah Mencapai Batas Penggunaan Air Hari Ini",
            message: "Pastikan Penggunaan Air lebih Efisien.",
            time: "This Week",
          ),
        ],
      ),
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String message;
  final String time;

  NotificationItem({required this.title, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(message),
            SizedBox(height: 8),
            Text(
              time,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}