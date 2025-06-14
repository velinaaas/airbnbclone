import 'package:airbnbclone/pages/edit_host_page.dart';
import 'package:airbnbclone/views/explore.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 12),
          const Text(
            "Profil",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          // Kartu Profil Pengguna (klik pindah ke edit_host_page)
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditHostPage()),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.black,
                    child: Text('T', style: TextStyle(color: Colors.white, fontSize: 28)),
                  ),
                  SizedBox(height: 12),
                  Text('Titis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Tuan Rumah', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Kartu Perjalanan & Koneksi
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  title: "Perjalanan terdahulu",
                  iconAsset: 'https://i.pinimg.com/736x/58/ad/be/58adbe4bf4bc3ffea359890aec774e80.jpg',
                  isBaru: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _FeatureCard(
                  title: "Koneksi",
                  iconAsset: 'https://img.lovepik.com/png/20231007/Cartoon-hand-drawn-men-and-women-clapping-friendship-day-illustration_117819_wh1200.png',
                  isBaru: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Menjadi Tuan Rumah
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Image.network(
                  'https://tse3.mm.bing.net/th/id/OIP.kuJuNMZGzkq87-gGn9_3hgHaE_?cb=iwc2&rs=1&pid=ImgDetMain',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Menjadi Tamu", style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text(
                        "Anda bisa mulai menerima tamu dengan mudah dan mendapatkan penghasilan tambahan.",
                        style: TextStyle(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Tombol "Pindah ke mode tamu"
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ExplorePage()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: const StadiumBorder(),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text("Pindah ke mode tamu"),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// Kartu Fitur Tambahan
class _FeatureCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final bool isBaru;

  const _FeatureCard({
    required this.title,
    required this.iconAsset,
    this.isBaru = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Image.network(
                iconAsset,
                width: 40,
                height: 40,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (isBaru)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.blue[800],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'BARU',
                style: TextStyle(fontSize: 10, color: Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
