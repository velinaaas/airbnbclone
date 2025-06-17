import 'package:flutter/material.dart';

class ExperiencePage extends StatefulWidget {
  const ExperiencePage({super.key});

  @override
  State<ExperiencePage> createState() => _ExperiencePageState();
}

class _ExperiencePageState extends State<ExperiencePage> {
  int _selectedIndex = 0; // BottomNavigationBar index

  final List<Map<String, String>> airbnbOriginals = const [
    {
      'imageUrl': 'https://cdn.idntimes.com/content-images/community/2023/05/ions-culinary-college-yogyakarta-34ad38a2ffe93ff890d5524b702be458-abd98f4742f5dcb57852159e446d703d.jpg',
      'title': 'Belajar memasak laab nuea',
      'location': 'San Phi Suea, Thailand',
      'price': 'Mulai Rp446.752 / tamu',
    },
    {
      'imageUrl': 'https://media.istockphoto.com/id/641016624/id/foto/latihan-muay-thai-pelatihan-motivasi-di-fasilitas-gym.jpg?s=170667a&w=0&k=20&c=9k-XiM8XcOYPPGfk_0wTs9gAfq8ezTCgxH5Mdm_97xM=',
      'title': 'Latih Muay Thai dengan profesional',
      'location': 'Chang Phueak, Thailand',
      'price': 'Mulai Rp496.391 / tamu',
    },
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.VyxaqEl5sUWv-AYdCwbCOwHaE8?w=298&h=199&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Jelajah kuil tua di Ayutthaya',
      'location': 'Ayutthaya, Thailand',
      'price': 'Mulai Rp350.000 / tamu',
    },
  ];

  final List<Map<String, String>> todayExperiences = const [
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.Og_Ior9WTzqn_nj94EA8yAHaD4?w=331&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Kelas lentera tradisional di Kota Tua',
      'location': 'Jakarta',
      'price': 'Mulai Rp306.225 / tamu',
    },
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.68raG8yG5jjK7hRGBTeJCgHaFj?w=222&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Cicipi makanan jalanan Vietnam',
      'location': 'Ho Chi Minh',
      'price': 'Mulai Rp216.545 / tamu',
    },
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.SMvEWGO36Pmsn9xmuidoEwHaEK?w=320&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Kelas membuat dream catcher',
      'location': 'Bogor',
      'price': 'Mulai Rp89.545 / tamu',
    },
  ];

  void _onBottomNavTapped(int index) {
    if (index == _selectedIndex) return;

    switch (index) {
      case 0:
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
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _searchBar(context),
            ),
            const SizedBox(height: 12),
            _topTab(context),
            const SizedBox(height: 24),
            _sectionTitle("Airbnb Originals"),
            _horizontalCardList(airbnbOriginals),
            const SizedBox(height: 24),
            _sectionTitle("Berlangsung hari ini di South East Asia"),
            _horizontalCardList(todayExperiences),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: _onBottomNavTapped,
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

  Widget _searchBar(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 370),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.black54),
                SizedBox(width: 8),
                Text("Mulai pencarian", style: TextStyle(color: Colors.black54)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _topTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/explore'),
            child: const _TabIcon(icon: Icons.house, label: 'Homes'),
          ),
          const _TabIcon(icon: Icons.flight, label: 'Experiences', isSelected: true),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/service'),
            child: const _TabIcon(icon: Icons.room_service, label: 'Services'),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  Widget _horizontalCardList(List<Map<String, String>> items) {
    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        padding: const EdgeInsets.only(left: 16, right: 8),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: _experienceCard(
              item['title']!,
              item['location']!,
              item['price']!,
              item['imageUrl']!,
            ),
          );
        },
      ),
    );
  }

  Widget _experienceCard(String title, String location, String price, String imageUrl) {
    return Container(
      width: 160,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  height: 100,
                  width: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Colors.white,
                  child: const Text(
                    "Originals",
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const Positioned(
                right: 5,
                top: 5,
                child: Icon(Icons.favorite_border, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(location, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Text(price, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}

class _TabIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;

  const _TabIcon({
    required this.icon,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: isSelected ? Colors.black : Colors.grey),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.black : Colors.grey,
          ),
        )
      ],
    );
  }
}
