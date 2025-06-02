import 'package:flutter/material.dart';

class PerjalananPage extends StatelessWidget {
  const PerjalananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Perjalanan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        automaticallyImplyLeading: false, // Menghilangkan icon back
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: Center(
                child: Column(
                  children: [
                    _buildDummyTrip(),
                    const SizedBox(height: 32),
                    const Text(
                      "Rancang perjalanan yang sempurna",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Telusuri penginapan, pengalaman, dan layanan. "
                      "Ketika Anda memesan, reservasi Anda akan terlihat di sini.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: Colors.black54),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/explore');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        backgroundColor: Colors.pinkAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Mulai sekarang',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2, // Indeks untuk halaman Perjalanan
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/explore');
              break;
            case 1:
              Navigator.pushNamed(context, '/favorit');
              break;
            case 2:
              break;
            case 3:
              Navigator.pushNamed(context, '/pesan');
              break;
            case 4:
              Navigator.pushNamed(context, '/profil');
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

  Widget _buildDummyTrip() {
    final dummyImages = [
      'https://ts4.mm.bing.net/th?id=OIP.R6df8KonaAoRMhP1oV_5NAHaD4&pid=15.1',
      'https://th.bing.com/th/id/OIP.dZSre7skbvrJQtWjd4kAXAHaE7?w=283&h=188&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'https://th.bing.com/th/id/OIP.LCzgP22hKlDFPkuwfw_CVgHaE3?w=268&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
    ];

    return Column(
      children: dummyImages.map((url) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade200,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(
                  url,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(height: 10, width: 120, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Container(height: 10, width: 80, color: Colors.grey.shade300),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
