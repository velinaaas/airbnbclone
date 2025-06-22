import 'dart:convert';
import 'package:airbnbclone/views/detail_property.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/property.dart';
import 'favorit.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  int selectedTopTabIndex = 0;
  Set<int> favoriteItems = {};
  List<Property> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProperties();
  }

  Future<void> fetchProperties() async {
    final url = Uri.parse('https://apiairbnb-production.up.railway.app/api/guest/all-properties');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final List jsonData = jsonResponse['data'];
        setState(() {
          properties = jsonData.map((e) => Property.fromJson(e)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load properties');
      }
    } catch (e) {
      print('Error fetching properties: $e');
      setState(() => isLoading = false);
    }
  }

  void onTopTabTap(int index) {
    setState(() => selectedTopTabIndex = index);
    if (index == 1) Navigator.pushNamed(context, '/experience');
    if (index == 2) Navigator.pushNamed(context, '/service');
  }

  Widget buildCard(Property data, BuildContext context, int index) {
    final isFavorite = favoriteItems.contains(index);

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailPropertyPage(propertyId: data.idProperty),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PHOTO
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                  child: AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Image.network(
                      data.coverPhoto ?? 'https://via.placeholder.com/800x600.png?text=No+Image',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (data.isActive)
                  Positioned(
                    top: 14,
                    left: 14,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Active',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      setState(() {
                        isFavorite ? favoriteItems.remove(index) : favoriteItems.add(index);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    data.address,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16),
                          const SizedBox(width: 4),
                          Text((data.averageRating ?? 0).toStringAsFixed(1),
                              style: const TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(color: Colors.black),
                          children: [
                            TextSpan(
                              text: 'Rp${data.pricePerNight.toStringAsFixed(0)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const TextSpan(text: ' / malam'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 400),
        child: GestureDetector(
          onTap: () => Navigator.pushNamed(context, '/search'),
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                  GestureDetector(
                      onTap: () => onTopTabTap(0),
                      child: _TabIcon(icon: Icons.house, label: 'Homes', isSelected: selectedTopTabIndex == 0)),
                  GestureDetector(
                      onTap: () => onTopTabTap(1),
                      child: _TabIcon(icon: Icons.flight, label: 'Experiences', isSelected: selectedTopTabIndex == 1)),
                  GestureDetector(
                      onTap: () => onTopTabTap(2),
                      child: _TabIcon(icon: Icons.room_service, label: 'Services', isSelected: selectedTopTabIndex == 2)),
                ]),
                const SizedBox(height: 24),
                const Text('Stays around the world', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),
                ...properties.asMap().entries.map((e) => buildCard(e.value, context, e.key)).toList(),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Row(children: const [
                    Icon(Icons.info_outline, color: Colors.grey, size: 20),
                    SizedBox(width: 8),
                    Expanded(child: Text("Display total before taxes", style: TextStyle(color: Colors.grey, fontSize: 14))),
                  ]),
                ),
                const SizedBox(height: 40),
              ],
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor:const Color(0xFFFF5A5F),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (idx) {
          switch (idx) {
          case 0:
            // Telusuri (jika ingin aksi)
            break;
          case 1:
            Navigator.pushNamed(context, '/favorit');
            break;
          case 2:
            Navigator.pushNamed(context, '/perjalanan');
            break;
          case 3:
            Navigator.pushNamed(context, '/profil'); // ← PROFIL ADA DI INDEX 3
            break;
        }
      },
        items: const [
          // index 0
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Telusuri"),
          // index 1
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: "Favorit"),
          // index 2
          BottomNavigationBarItem(icon: Icon(Icons.card_travel), label: "Perjalanan"),
          // index 3
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
        Text(label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? Colors.black : Colors.grey,
            ))
      ],
    );
  }
}
