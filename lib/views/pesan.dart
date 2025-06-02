import 'package:flutter/material.dart';

class PesanPage extends StatefulWidget {
  @override
  _PesanPageState createState() => _PesanPageState();
}

class _PesanPageState extends State<PesanPage> {
  int selectedIndex = 3;

  final List<String> tabs = [
    'Semua',
    'Mode Tuan Rumah',
    'Bepergian',
    'Dukungan',
  ];

  int selectedTabIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/explore');
        break;
      case 1:
        Navigator.pushNamed(context, '/favorit');
        break;
      case 2:
        Navigator.pushNamed(context, '/perjalanan');
        break;
      case 3:
        // stay in current
        break;
      case 4:
        Navigator.pushNamed(context, '/profil');
        break;
    }
  }

  Widget buildTabButton(String text, int index) {
    bool isSelected = selectedTabIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTabIndex = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.grey[200],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  automaticallyImplyLeading: false, // Menghilangkan ikon back
  title: Text("Pesan", style: TextStyle(fontWeight: FontWeight.bold)),
  backgroundColor: Colors.white,
  elevation: 0,
  actions: [
    IconButton(
      icon: Icon(Icons.search, color: Colors.black),
      onPressed: () {},
    ),
    IconButton(
      icon: Icon(Icons.settings, color: Colors.black),
      onPressed: () {},
    ),
  ],
),
      body: Column(
        children: [
          SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: List.generate(
                tabs.length,
                (index) => buildTabButton(tabs[index], index),
              ),
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.chat_outlined, size: 48, color: Colors.black54),
                SizedBox(height: 12),
                Text(
                  "Anda tidak memiliki pesan",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  "Saat Anda menerima pesan baru, pesan akan ditampilkan di sini.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
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
