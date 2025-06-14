import 'package:flutter/material.dart';

class ServicePage extends StatelessWidget {
  const ServicePage({super.key});

  final List<Map<String, String>> serviceCategories = const [
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.dZSre7skbvrJQtWjd4kAXAHaE7?w=283&h=188&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Fotografi',
      'available': '41 tersedia',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.LCzgP22hKlDFPkuwfw_CVgHaE3?w=268&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Chef',
      'available': '1 tersedia',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.HjoWpPgSUoofji7skM7aQwHaE7?w=300&h=200&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Pijat',
      'available': '5 tersedia',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.-Wt5203W0J3H9V76l6oc3gHaFj?w=224&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Make-up',
      'available': '2 tersedia',
    },
  ];

  final List<Map<String, String>> photoTours = const [
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.eCIHw9z2_-3p4bJvQa1N8wHaE8?w=294&h=197&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Tur pribadi khusus foto & pemotretan video di Bali',
      'price': 'Mulai Rp370.000 / tamu',
      'min': 'Minimum Rp700.000',
      'rating': '★ 4.97',
      'label': 'Populer',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.VlqifzhuRaGJrjXBaJnsxQHaE8?w=237&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      'title': 'Tur dan fotografi pribadi di Ubud',
      'price': 'Mulai Rp825.000 / tamu',
      'min': 'Minimum Rp1.250.000',
      'rating': '★ 4.96',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.83DHWtVLDTx0A78JQVcR4gHaEa?w=303&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Tur dan fotografi bromo',
      'price': 'Mulai Rp500.000 / tamu',
      'min': 'Minimum Rp1.500.000',
      'rating': '★ 4.97',
    },
    {
      'imageUrl':
          'https://th.bing.com/th/id/OIP.rxPUt5agMfCsG0N796tfgAHaFj?w=225&h=180&c=7&r=0&o=7&dpr=1.3&pid=1.7&rm=3',
      'title': 'Tur semeru',
      'price': 'Mulai Rp478.000 / tamu',
      'min': 'Minimum Rp1.350.000',
      'rating': '★ 4.97',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            const SizedBox(height: 16),
            _buildSearchBar(context),
            const SizedBox(height: 12),
            _buildTopTab(context),
            const SizedBox(height: 24),
            _buildSectionTitle("Layanan di South East Asia"),
            const SizedBox(height: 12),
            _buildServiceCategoryList(),
            const SizedBox(height: 24),
            _buildSectionTitle("Fotografi"),
            const SizedBox(height: 12),
            _buildPhotoTourList(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
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

  Widget _buildTopTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/explore'),
            child: const _TabIcon(icon: Icons.house, label: 'Homes'),
          ),
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/experience'),
            child: const _TabIcon(icon: Icons.flight, label: 'Experiences'),
          ),
          const _TabIcon(icon: Icons.room_service, label: 'Services', isSelected: true),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildServiceCategoryList() {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // ✅ Tambahan di sini
        itemCount: serviceCategories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemBuilder: (context, index) {
          final item = serviceCategories[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.network(
                        item['imageUrl']!,
                        width: 140,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.favorite_border, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  item['available']!,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPhotoTourList() {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), // ✅ Tambahan di sini
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: photoTours.length,
        itemBuilder: (context, index) {
          final item = photoTours[index];
          return Container(
            width: 140,
            margin: const EdgeInsets.only(right: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        item['imageUrl']!,
                        width: 140,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (item.containsKey('label'))
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            item['label']!,
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: Icon(Icons.favorite_border, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['title']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(item['price']!, style: const TextStyle(fontSize: 12)),
                Text(item['min']!, style: const TextStyle(fontSize: 12)),
                Text(item['rating']!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.pink,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            break;
          case 1:
            Navigator.pushReplacementNamed(context, '/favorite');
            break;
          case 2:
            Navigator.pushReplacementNamed(context, '/travel');
            break;
          case 3:
            Navigator.pushReplacementNamed(context, '/message');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/profil');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Telusuri"),
        BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorit"),
        BottomNavigationBarItem(icon: Icon(Icons.room_service), label: "Layanan"),
        BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Pesan"),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
      ],
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
        ),
      ],
    );
  }
}
