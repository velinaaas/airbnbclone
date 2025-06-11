import 'package:flutter/material.dart';
import 'tempat_page.dart';
import 'pesan_page.dart';
import 'menu_page.dart';

class KalenderPage extends StatefulWidget {
  const KalenderPage({super.key});

  @override
  State<KalenderPage> createState() => _HariIniPageState();
}

class _HariIniPageState extends State<KalenderPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    _KalenderContent(),
    KalenderPage(),
    TempatPage(),
    PesanPage(),
    MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined),
            label: 'Hari ini',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Kalender',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house),
            label: 'Tempat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Pesan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: 'Menu',
          ),
        ],
      ),
    );
  }
}

class _KalenderContent extends StatelessWidget {
  const _KalenderContent();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kalender")),
      body: Center(
        child: Text(
          'Kalender akan tersedia di sini.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
