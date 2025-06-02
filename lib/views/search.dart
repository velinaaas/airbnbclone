import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final List<Map<String, String>> suggestedDestinations = [
    {
      "icon": "📍",
      "title": "Di dekat lokasi Anda",
      "subtitle": "Cari tahu apa yang ada di sekitar Anda"
    },
    {
      "icon": "🏖️",
      "title": "Kuta, Bali",
      "subtitle": "Destinasi pantai populer"
    },
    {
      "icon": "🏘️",
      "title": "Bandung, Jawa Barat",
      "subtitle": "Sangat cocok untuk liburan akhir pekan"
    },
    {
      "icon": "🌴",
      "title": "Canggu Beach",
      "subtitle": "Karena tepi lautnya yang memikat"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TabItem(icon: Icons.house, label: 'Homes', selected: true),
                  _TabItem(icon: Icons.flight, label: 'Experiences'),
                  _TabItem(icon: Icons.notifications, label: 'Services'),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const Text("Lokasi",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Cari destinasi",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text("Destinasi yang disarankan",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ...suggestedDestinations.map((item) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(
                    item['icon']!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                title: Text(item['title']!,
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['subtitle']!),
              )),
          const SizedBox(height: 24),
          _OptionTile(
              title: "Tanggal perjalanan", buttonLabel: "Tambahkan tanggal"),
          const SizedBox(height: 12),
          _OptionTile(title: "Peserta", buttonLabel: "Tambahkan tamu"),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                  onPressed: () {},
                  child: Text("Hapus semua",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold))),
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.search),
                label: Text("Cari"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
              )
            ],
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _TabItem(
      {required this.icon, required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: selected ? Colors.black : Colors.grey),
        Text(label,
            style: TextStyle(
              fontSize: 12,
              color: selected ? Colors.black : Colors.grey,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            )),
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  final String title;
  final String buttonLabel;

  const _OptionTile({required this.title, required this.buttonLabel});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(buttonLabel, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
