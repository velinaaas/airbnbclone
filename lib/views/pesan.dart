import 'package:flutter/material.dart';

class PesanPage extends StatefulWidget {
  @override
  _PesanPageState createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  int selectedIndex = 3;

  final List<Map<String, String>> messages = [
    {
      'name': 'Philip',
      'message': 'Anda: Pertanyaan terkirim',
      'time': '01.28',
      'status': 'Pertanyaan terkirim · 24–25 Jun · Samping...',
      'image': 'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400',
      'avatar': 'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=100',
    },
    {
      'name': 'Alicia',
      'message': 'Tolong cek jadwal tamu',
      'time': '13.02',
      'status': 'Permintaan baru · 26 Jun',
      'image': 'https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=400',
      'avatar': 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=100',
    },
  ];

  void _onItemTapped(int index) {
    if (index == selectedIndex) return; // jika sama, tidak usah berpindah

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
        // tetap di PesanPage
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profil');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pesan', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search, color: Colors.black)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings, color: Colors.black)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                msg['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(msg['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(msg['time']!, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg['message']!),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.circle, size: 8, color: Colors.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        msg['status']!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: CircleAvatar(
              backgroundImage: NetworkImage(msg['avatar']!),
            ),
            isThreeLine: true,
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Telusuri'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Favorit'),
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: 'Perjalanan'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Pesan'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profil'),
        ],
      ),
    );
  }
}
