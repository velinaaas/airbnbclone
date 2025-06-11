import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _welcomeCard(context), // <- Tambahan banner

          const SizedBox(height: 16),
          _sectionTitle('MENERIMA TAMU'),
          _menuItem(Icons.attach_money, 'Penghasilan'),
          _menuItem(Icons.home, 'Status properti'),
          _menuItem(Icons.star, 'Ulasan'),
          _menuItem(Icons.edit, 'Panduan komunitas'),
          const SizedBox(height: 16),
          _sectionTitle('PENGELOLAAN'),
          _menuItem(Icons.calendar_today, 'Kalender'),
          _menuItem(Icons.insert_chart, 'Wawasan'),
          _menuItem(Icons.lightbulb, 'Tips dan artikel'),
          const SizedBox(height: 16),
          _sectionTitle('PENGATURAN'),
          _menuItem(Icons.settings, 'Pengaturan'),
          _menuItem(Icons.help, 'Bantuan'),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // Tambahkan aksi saat menu diklik jika perlu
      },
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _welcomeCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _imageBox('https://picsum.photos/seed/1/60/60'),
              const SizedBox(width: 8),
              _imageBox('https://picsum.photos/seed/2/60/60'),
              const SizedBox(width: 8),
              _imageBox('https://picsum.photos/seed/3/60/60'),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Pertama kalinya menggunakan Airbnb?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'Temukan tips dan praktik terbaik dari para tuan rumah yang dinilai tinggi.',
            style: TextStyle(color: Colors.grey[700]),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HalamanTips()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                side: BorderSide(color: Colors.grey.shade300),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Mulai sekarang'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _imageBox(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        url,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
      ),
    );
  }
}

class HalamanTips extends StatelessWidget {
  const HalamanTips({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tips Airbnb')),
      body: const Center(
        child: Text(
          'Selamat datang di halaman tips!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
