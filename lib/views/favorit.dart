import 'package:flutter/material.dart';
// import 'explore.dart';
// import 'profil.dart';

class FavoritPage extends StatelessWidget {
  const FavoritPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> gridItems = [
      _buildGridItem(
        title: 'Terakhir dilihat',
        subtitle: 'Kemarin',
        images: [
          'https://th.bing.com/th/id/OIP.Og_Ior9WTzqn_nj94EA8yAHaD4?w=331&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
          'https://cdn.idntimes.com/content-images/community/2023/05/ions-culinary-college-yogyakarta-34ad38a2ffe93ff890d5524b702be458-abd98f4742f5dcb57852159e446d703d.jpg',
          'https://th.bing.com/th/id/OIP.dZSre7skbvrJQtWjd4kAXAHaE7?w=283&h=188&c=7&r=0&o=5&dpr=1.3&pid=1.7',
          'https://th.bing.com/th/id/OIP.eCIHw9z2_-3p4bJvQa1N8wHaE8?w=294&h=197&c=7&r=0&o=5&dpr=1.3&pid=1.7',
        ],
      ),
      _buildSingleImageItem(
        title: 'Bandung',
        subtitle: '1 tersimpan',
        image: 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
      ),
      _buildSingleImageItem(
        title: 'Services',
        subtitle: '1 tersimpan',
        image: 'https://th.bing.com/th/id/OIP.VlqifzhuRaGJrjXBaJnsxQHaE8?w=237&h=180&c=7&r=0&o=5&dpr=1.3&pid=1.7',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorit', style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Edit', style: TextStyle(color: Colors.black)),
          )
        ],
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          itemCount: gridItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 24,
            mainAxisExtent: 200, // atur tinggi item
          ),
          itemBuilder: (context, index) => gridItems[index],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor:const Color(0xFFFF5A5F),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/explore');
              break;
            case 1:
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
          // BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: "Pesan"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }

  static Widget _buildGridItem({
    required String title,
    required String subtitle,
    required List<String> images,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 130,
          child: GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 2,
            crossAxisSpacing: 2,
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            childAspectRatio: 1.5,
            children: images
                .map((url) => Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(url, fit: BoxFit.cover),
                      ),
                    ))
                .toList(),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  static Widget _buildSingleImageItem({
    required String title,
    required String subtitle,
    required String image,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 130,
          width: double.infinity,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(image, fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }
}
