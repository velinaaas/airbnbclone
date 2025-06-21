import 'package:airbnbclone/models/user_profil.dart';
import 'package:airbnbclone/pages/hari_ini_page.dart';
import 'package:airbnbclone/services/authService.dart';
import 'package:airbnbclone/views/edit_profil.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  UserProfile? userProfile;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    final profile = await AuthService.getUserProfile();
    setState(() {
      userProfile = profile;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 0,
        backgroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const SizedBox(height: 12),
                const Text(
                  "Profil",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                // Kartu Profil Pengguna
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const EditProfilPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: Colors.black,
                          child: Text(
                            userProfile?.name.substring(0, 1).toUpperCase() ?? '',
                            style: const TextStyle(color: Colors.white, fontSize: 28),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          userProfile?.name ?? '',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userProfile?.role ?? '',
                          style: const TextStyle(color: Colors.grey),
                        ),
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
                        iconAsset:
                            'https://i.pinimg.com/736x/58/ad/be/58adbe4bf4bc3ffea359890aec774e80.jpg',
                        isBaru: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _FeatureCard(
                        title: "Koneksi",
                        iconAsset:
                            'https://img.lovepik.com/png/20231007/Cartoon-hand-drawn-men-and-women-clapping-friendship-day-illustration_117819_wh1200.png',
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
                            Text("Menjadi Tuan Rumah", style: TextStyle(fontWeight: FontWeight.bold)),
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

                // Tombol "Pindah ke mode tuan rumah"
                ElevatedButton(
                  onPressed: () async {
                    final success = await AuthService.switchToHostRole(context);
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HariIniPage()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text("Pindah ke mode tuan rumah"),
                ),

                const SizedBox(height: 16), // Tambahan jarak antar tombol

                // Tombol Logout
                ElevatedButton.icon(
                  onPressed: () async {
                    await AuthService.logout();
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 4,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/explore');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/favorit');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/perjalanan');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/pesan');
              break;
            case 4:
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Telusuri"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorit"),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "Perjalanan"),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Pesan"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}

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
