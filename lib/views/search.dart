import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _results = [];
  bool _isLoading = false;
  String _error = '';

  Future<void> _performSearch() async {
    final keyword = _searchController.text.trim().toLowerCase();
    if (keyword.isEmpty) return;

    final url = Uri.parse(
        'https://apiairbnb-production.up.railway.app/api/guest/properties/category/$keyword');

    setState(() {
      _isLoading = true;
      _error = '';
      _results.clear();
    });

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        setState(() => _results = List<Map<String, dynamic>>.from(data));
      } else {
        setState(() => _error = 'Gagal mengambil data (${response.statusCode})');
      }
    } catch (e) {
      setState(() => _error = 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  final List<Map<String, String>> suggestedCategories = [
    {"icon": "🏡", "name": "villa"},
    {"icon": "🏙️", "name": "apartment"},
    {"icon": "🛖", "name": "cabin"},
    {"icon": "🏕️", "name": "camp"},
    {"icon": "🏠", "name": "house"},
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
                children: const [
                  _TabItem(icon: Icons.house, label: 'Homes', selected: true),
                  _TabItem(icon: Icons.flight, label: 'Experiences'),
                  _TabItem(icon: Icons.notifications, label: 'Services'),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          const Text("Kategori",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: "Contoh: villa, apartment, cabin",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _performSearch,
            icon: const Icon(Icons.search),
            label: const Text("Cari"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pink,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            ),
          ),
          const SizedBox(height: 20),
          if (_isLoading)
            const Center(child: CircularProgressIndicator())
          else if (_error.isNotEmpty)
            Text(_error, style: const TextStyle(color: Colors.red))
          else if (_results.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Hasil Pencarian",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ..._results.map((item) {
                  
                  final title = item['title'] ?? 'Tanpa Judul';
                  final price = item['price_per_night']?.toString() ?? '-';
                  final rating = item['avg_rating']?.toString() ?? '-';
                  final image = item['cover_img'] ??
                      'https://via.placeholder.com/300';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.grey[100],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16)),
                              child: Image.network(
                                image,
                                height: 200,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: const Icon(Icons.favorite_border,
                                    size: 20, color: Colors.black),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 16, color: Colors.orange),
                                  const SizedBox(width: 4),
                                  Text(rating,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                title,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Rp $price / malam",
                                style: const TextStyle(
                                    fontSize: 14, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            )
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Kategori Populer",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                ...suggestedCategories.map((item) => ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.grey[200],
                        child: Text(
                          item['icon']!,
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      title: Text(item['name']!,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      onTap: () {
                        _searchController.text = item['name']!;
                        _performSearch();
                      },
                    )),
              ],
            ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;

  const _TabItem({
    required this.icon,
    required this.label,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: selected ? Colors.black : Colors.grey),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: selected ? Colors.black : Colors.grey,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
