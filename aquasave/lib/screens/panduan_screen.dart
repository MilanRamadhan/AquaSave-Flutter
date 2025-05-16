import 'package:flutter/material.dart';

class PanduanScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade100,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Panduan Penghematan Air", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tips Penghematan Air Di Rumah",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              _buildTipCard(
                "1. Periksa Kebocoran",
                "Periksa kran, pipa, dan toilet secara rutin untuk mendeteksi kebocoran. "
                "Bahkan kebocoran kecil dapat menghabiskan banyak air jika dibiarkan. "
                "Ganti seal atau bagian yang rusak untuk menghindari pemborosan air.",
              ),
              _buildTipCard(
                "2. Gunakan Perangkat Hemat Air",
                "• Pasang shower head bertekanan rendah atau aerator untuk mengurangi aliran air tanpa mengurangi kenyamanan.\n"
                "• Gunakan keran hemat air di wastafel dapur dan kamar mandi.\n"
                "• Gunakan toilet dual-flush yang memungkinkan Anda memilih antara flush besar atau kecil sesuai kebutuhan.",
              ),
              _buildTipCard(
                "3. Matikan Air Saat Tidak Digunakan",
                "• Matikan keran saat menyikat gigi atau mencuci tangan untuk menghemat air.\n"
                "• Matikan shower saat sabunan tubuh dan shampoo.",
              ),
              _buildTipCard(
                "4. Cuci Piring Dengan Efisien",
                "• Gunakan mesin pencuci piring hanya saat penuh, atau cuci dengan tangan menggunakan dua baskom, satu untuk air sabun dan satu untuk membilas.\n"
                "• Gunakan air bekas cucian untuk menyiram tanaman atau membersihkan.",
              ),
              _buildTipCard(
                "5. Penggunaan Air Di Taman Dan Tanaman",
                "• Gunakan sistem irigasi tetes untuk menyiram tanaman, yang lebih efisien daripada menyiram dengan selang.\n"
                "• Tanam tanaman yang tahan kekeringan untuk mengurangi kebutuhan akan penyiraman.",
              ),
              _buildTipCard(
                "6. Daur Ulang Air",
                "• Gunakan air bekas mencuci sayur untuk menyiram tanaman, atau air hujan untuk kegiatan rumah tangga yang tidak membutuhkan air bersih."
              ),
              _buildTipCard(
                "7. Hemat Air Saat Mandi",
                "• Mandilah dengan waktu yang lebih singkat atau gunakan ember untuk mandi jika tidak ada shower bertekanan rendah. Jangan biarkan air mengalir saat Anda sedang menggunakan sabun atau sampo."
              ),
              _buildTipCard(
                "8. Cuci Pakaian dengan Efisien",
                "• Cuci pakaian hanya jika muatan mesin penuh untuk menghindari pemborosan air.\n"
                "• Gunakan mesin cuci yang efisien dengan penggunaan air yang lebih sedikit.",
              ),
              _buildTipCard(
                "9. Gunakan Wadah yang Efisien",
                "• Gunakan ember atau wadah untuk mencuci mobil atau kendaraan, daripada menggunakan selang yang terus-menerus mengalirkan air."
              ),
              _buildTipCard(
                "10. Mengurangi Penggunaan Air Panas",
                "• Hindari penggunaan air panas yang berlebihan karena membutuhkan lebih banyak energi dan air."
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTipCard(String title, String content) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),
            Text(content, style: TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
