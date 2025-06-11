import 'package:flutter/material.dart';
import 'kalender_page.dart';
import 'tempat_page.dart';
import 'pesan_page.dart';
import 'menu_page.dart';

class HariIniPage extends StatefulWidget {
  const HariIniPage({super.key});

  @override
  State<HariIniPage> createState() => _HariIniPageState();
}

class _HariIniPageState extends State<HariIniPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _HariIniContent(),
    KalenderPage(),
    TempatPage(),
    PesanPage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Hari ini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Tempat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}
class _HariIniContent extends StatelessWidget {
  const _HariIniContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hari Ini')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Selamat datang,\nTitis!',
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
                side: const BorderSide(color: Colors.black),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Selesaikan Iklan Anda'),
            ),
            SizedBox(height: 24),
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
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade200,
              ),
              child: Column(
                children: const [
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
              child: const Text(
                'Semua reservasi (0)',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(height: 24),
            const Text('Kami siap membantu', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            _helpCard(Icons.group, 'Bergabung dengan Klub Tuan Rumah lokal', 'Jalin koneksi, berkolaborasi, dan berbagi info dengan tuan rumah lain.'),
            _helpCard(Icons.support_agent, 'Hubungi layanan dukungan khusus', 'Sebagai tuan rumah baru, Anda mendapatkan akses ke tim dukungan khusus.'),
            SizedBox(height: 24),
            const Text('Sumber informasi dan tips', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
      shape: const StadiumBorder(side: BorderSide(color: Colors.grey)),
      backgroundColor: Colors.white,
    );
  }

  Widget _helpCard(IconData icon, String title, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          Icon(icon, size: 32, color: Colors.black),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
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
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Text(title),
    );
  }
}
