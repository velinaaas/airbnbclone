import 'package:flutter/material.dart';
import 'favorit.dart'; // Import halaman favorit

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedTopTabIndex = 0;

  final List<Map<String, dynamic>> popularInBandung = [
    {
      'imageUrl': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      'title': 'Rumah di Kecamatan Cibeunying Kaler',
      'price': 'Rp2.106.308 untuk 1 malam',
      'rating': '4,91'
    },
    {
      'imageUrl': 'https://ts4.mm.bing.net/th?id=OIP.R6df8KonaAoRMhP1oV_5NAHaD4&pid=15.1',
      'title': 'Rumah di Kecamatan Lembang',
      'price': 'Rp4.187.278 untuk 3 malam',
      'rating': '4,96'
    },
  ];

  final List<Map<String, dynamic>> kualaLumpurNextMonth = [
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.dEIX3owbJZDCP2uxzJVPGQHaE8?w=309&h=180&c=7&r=0&o=5&cb=iwc2&dpr=1.3&pid=1.7',
      'title': 'Kondominium di Setiawangsa',
      'price': 'Rp6.367.278 untuk 2 malam',
      'rating': '4,87'
    },
    {
      'imageUrl': 'https://th.bing.com/th/id/OIP.27onQRg5LzalYccvQx3e3QHaFj?w=220&h=180&c=7&r=0&o=5&cb=iwc2&dpr=1.3&pid=1.7',
      'title': 'Apartemen di Bukit Bintang',
      'price': 'Rp1.098.223 untuk 1 malam',
      'rating': '4,90'
    },
  ];

  void onTopTabTap(int index) {
    setState(() {
      selectedTopTabIndex = index;
    });

    if (index == 1) {
      Navigator.pushNamed(context, '/experience');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/service');
    }
  }

  Widget buildCard(Map<String, dynamic> data, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/detail');
      },
      child: Container(
        width: 180,
        margin: EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    data['imageUrl'],
                    width: 180,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Pilihan tamu',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(Icons.favorite_border, color: Colors.white),
                )
              ],
            ),
            SizedBox(height: 8),
            Text(
              data['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              data['price'],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (data['rating'] != '')
              Text(
                '★ ${data['rating']}',
                style: TextStyle(color: Colors.black54),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400), // bebas ubah lebar di sini
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: _buildSearchBar(context),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () => onTopTabTap(0),
                child: _TabIcon(
                  icon: Icons.house,
                  label: 'Homes',
                  isSelected: selectedTopTabIndex == 0,
                ),
              ),
              GestureDetector(
                onTap: () => onTopTabTap(1),
                child: _TabIcon(
                  icon: Icons.flight,
                  label: 'Experiences',
                  isSelected: selectedTopTabIndex == 1,
                ),
              ),
              GestureDetector(
                onTap: () => onTopTabTap(2),
                child: _TabIcon(
                  icon: Icons.notifications,
                  label: 'Services',
                  isSelected: selectedTopTabIndex == 2,
                ),
              ),
            ],
          ),
          SizedBox(height: 24),
          Text('Penginapan populer di Bandung',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children:
                  popularInBandung.map((data) => buildCard(data, context)).toList(),
            ),
          ),
          SizedBox(height: 24),
          Text('Tersedia bulan depan di Kuala Lumpur',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),
          SizedBox(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: kualaLumpurNextMonth
                  .map((data) => buildCard(data, context))
                  .toList(),
            ),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text("Harga sudah mencakup semua biaya",
                style: TextStyle(color: Colors.pink)),
          ),
          SizedBox(height: 40),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FavoritPage()),
              );
              break;
            case 2:
              Navigator.pushNamed(context, '/perjalanan');
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
