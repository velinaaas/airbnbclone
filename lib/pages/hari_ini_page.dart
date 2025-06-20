import 'package:airbnbclone/pages/menu_page.dart';
import 'package:airbnbclone/pages/pesan_page.dart';
import 'package:airbnbclone/pages/tempat_page.dart';
import 'package:flutter/material.dart';

class HariIniPage extends StatefulWidget {
  const HariIniPage({super.key});

  @override
  State<HariIniPage> createState() => _HariIniPageState();
}

class _HariIniPageState extends State<HariIniPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HariIniContent(),
    TempatPage(),
    PesanPage(),
    const MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
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
            icon: Icon(Icons.house),
            label: 'Tempat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

class _HariIniContent extends StatefulWidget {
  const _HariIniContent();

  @override
  State<_HariIniContent> createState() => _HariIniContentState();
}

class _HariIniContentState extends State<_HariIniContent> {
  String selectedTab = '';
  List<Map<String, String>> akanCheckout = [
    {'name': 'Ahmad Yusuf', 'detail': 'Villa Mawar, 17-19 Juni 2025'},
    {'name': 'Lia Putri', 'detail': 'Apartemen Sakura, 18-20 Juni 2025'},
  ];
  List<Map<String, String>> tamuSaatIni = [];
  List<Map<String, String>> pesananSelesai = [];

  void _selectTab(String tab) {
    setState(() {
      selectedTab = tab;
    });
  }

  void _konfirmasiPesanan(Map<String, String> pesanan) {
    setState(() {
      akanCheckout.remove(pesanan);
      tamuSaatIni.add(pesanan);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pesanan ${pesanan['name']} diterima.'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _batalkanPesanan(Map<String, String> pesanan) {
    setState(() {
      akanCheckout.remove(pesanan);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pesanan ${pesanan['name']} dibatalkan.'),
      duration: const Duration(seconds: 2),
    ));
  }

  void _selesaikanPesanan(Map<String, String> pesanan) {
    setState(() {
      tamuSaatIni.remove(pesanan);
      pesananSelesai.add(pesanan);
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Pesanan ${pesanan['name']} telah selesai.'),
      duration: const Duration(seconds: 2),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Menghilangkan tombol back
        title: const Text('Hari Ini'),
      ),
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
            const SizedBox(height: 16),
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
            const SizedBox(height: 24),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _tabChip('Belum di proses (${akanCheckout.length})'),
                  const SizedBox(width: 8),
                  _tabChip('Terkonfirmasi (${tamuSaatIni.length})'),
                  const SizedBox(width: 8),
                  _tabChip('Selesai (${pesananSelesai.length})'),
                  const SizedBox(width: 8),
                  _tabChip('Ulasan tamu (0)'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            if (selectedTab == 'Belum di proses (${akanCheckout.length})') ...[
              const Text(
                'Pesanan Akan Check-Out',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              for (var p in akanCheckout)
                _orderCard(p['name']!, p['detail']!, p),
            ] else if (selectedTab == 'Terkonfirmasi (${tamuSaatIni.length})') ...[
              const Text(
                'Terkonfirmasi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              for (var t in tamuSaatIni)
                _orderCard(t['name']!, t['detail']!, t),
            ] else if (selectedTab == 'Selesai (${pesananSelesai.length})') ...[
              const Text(
                'Pesanan Selesai',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              for (var s in pesananSelesai)
                _orderCard(s['name']!, s['detail']!, null),
            ] else ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey.shade200,
                ),
                child: Column(
                  children: const [
                    Icon(Icons.insert_comment_outlined,
                        size: 48, color: Colors.grey),
                    SizedBox(height: 8),
                    Text(
                      'Tidak ada ulasan tamu untuk Anda tulis.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Semua reservasi (0)',
                  style: TextStyle(decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Kami siap membantu',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _helpCard(
                Icons.group,
                'Bergabung dengan Klub Tuan Rumah lokal',
                'Jalin koneksi, berkolaborasi, dan berbagi info dengan tuan rumah lain.',
              ),
              _helpCard(
                Icons.support_agent,
                'Hubungi layanan dukungan khusus',
                'Sebagai tuan rumah baru, Anda mendapatkan akses ke tim dukungan khusus.',
              ),
              const SizedBox(height: 24),
              const Text('Sumber informasi dan tips',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              _infoCard('Kini Anda bisa melakukan lebih banyak hal di Airbnb'),
              _infoCard(
                  'Jelajahi fitur untuk tuan rumah terbaru untuk membantu...'),
            ]
          ],
        ),
      ),
    );
  }

  Widget _tabChip(String label) {
    final bool isSelected = selectedTab == label;
    return GestureDetector(
      onTap: () => _selectTab(label),
      child: Chip(
        label: Text(label),
        shape: const StadiumBorder(side: BorderSide(color: Colors.grey)),
        backgroundColor: isSelected ? Colors.pink.shade100 : Colors.white,
      ),
    );
  }

  Widget _orderCard(String name, String detail, Map<String, String>? data) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(detail),
          const SizedBox(height: 8),
          if (data != null && akanCheckout.contains(data)) ...[
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _konfirmasiPesanan(data),
                  child: const Text('Konfirmasi'),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () => _batalkanPesanan(data),
                  child: const Text('Batalkan'),
                ),
              ],
            )
          ] else if (data != null && tamuSaatIni.contains(data)) ...[
            ElevatedButton(
              onPressed: () => _selesaikanPesanan(data),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Selesaikan Pesanan'),
            )
          ]
        ],
      ),
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