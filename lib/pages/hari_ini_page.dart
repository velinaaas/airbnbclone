import 'package:flutter/material.dart';

class HariIniPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Selamat datang,\nZaza!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.notifications_none),
              ],
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Selesaikan Iklan Anda'),
            ),
            SizedBox(height: 24),

            // Reservasi
            SingleChildScrollView(
  scrollDirection: Axis.horizontal,
  child: Row(
    children: [
      _tabChip('Akan check-out (0)'),
      SizedBox(width: 8),
      _tabChip('Tamu saat ini (0)'),
      SizedBox(width: 8),
      _tabChip('Segera tiba (0)'),
      SizedBox(width: 8),
      _tabChip('Mendatang (0)'),
      SizedBox(width: 8),
      _tabChip('Menunggu penulisan ulasan (0)'),
    ],
  ),
),

            SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: Column(
                children: [
                  Icon(Icons.insert_comment_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 8),
                  Text(
                    'Tidak ada ulasan tamu untuk Anda tulis.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            TextButton(
              onPressed: () {},
              child: Text('Semua reservasi (0)', style: TextStyle(decoration: TextDecoration.underline)),
            ),

            SizedBox(height: 24),
            Text('Kami siap membantu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _helpCard(Icons.group, 'Bergabung dengan Klub Tuan Rumah lokal', 'Jalin koneksi, berkolaborasi, dan berbagi info dengan tuan rumah lain.'),
            _helpCard(Icons.support_agent, 'Hubungi layanan dukungan khusus', 'Sebagai tuan rumah baru, Anda mendapatkan akses ke tim dukungan khusus.'),

            SizedBox(height: 24),
            Text('Sumber informasi dan tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _infoCard('Kini Anda bisa melakukan lebih banyak hal di Airbnb'),
            _infoCard('Jelajahi fitur untuk tuan rumah terbaru untuk membantu...'),
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label) {
    return Chip(
      label: Text(label),
      shape: StadiumBorder(side: BorderSide(color: Colors.grey)),
      backgroundColor: Colors.white,
    );
  }

  Widget _helpCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.black),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _infoCard(String title) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Text(title),
    );
  }
}
