// search_page.dart
import 'dart:convert';
import 'package:airbnbclone/views/detail_property.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  // ────────────────────────── Shared ──────────────────────────
  late final TabController _tab;
  bool _isLoading = false;
  String _error = '';
  List<Map<String, dynamic>> _results = [];

  void _resetState() {
    setState(() {
      _isLoading = true;
      _error = '';
      _results.clear();
    });
  }

  // ─────────────────────── Mode 1: Kategori ───────────────────
  final TextEditingController _searchController = TextEditingController();
  Future<void> _performCategorySearch() async {
    final keyword = _searchController.text.trim().toLowerCase();
    if (keyword.isEmpty) return;

    _resetState();
    final url = Uri.parse(
        'https://apiairbnb-production.up.railway.app/api/guest/properties/category/$keyword');

    try {
      final r = await http.get(url);
      if (r.statusCode == 200) {
        final List data = jsonDecode(r.body);
        setState(() => _results = List<Map<String, dynamic>>.from(data));
      } else {
        setState(() => _error = 'Gagal mengambil data (${r.statusCode})');
      }
    } catch (e) {
      setState(() => _error = 'Terjadi kesalahan: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  final List<Map<String, String>> _suggestedCategories = [
    {"icon": "🏡", "name": "villa"},
    {"icon": "🏙️", "name": "apartment"},
    {"icon": "🛖", "name": "cabin"},
    {"icon": "🏕️", "name": "camp"},
    {"icon": "🏠", "name": "house"},
  ];

  // ─────────────────────── Mode 2: Filter ─────────────────────
  final TextEditingController _locationController = TextEditingController();
  final MapController _map = MapController();
  LatLng? _selectedLatLng;
  String? _selectedAddress;
  DateTimeRange? _dateRange;
  int _guests = 1;

  Future<void> _initMyLocation() async {
    final perm = await Geolocator.requestPermission();
    if (perm == LocationPermission.denied ||
        perm == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    _map.move(LatLng(pos.latitude, pos.longitude), 12);
  }

  Future<void> _pickDateRange() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange:
          _dateRange ?? DateTimeRange(start: now, end: now.add(const Duration(days: 1))),
    );
    if (picked != null) setState(() => _dateRange = picked);
  }

  Future<void> _performFilterSearch() async {
  if (_locationController.text.isEmpty || _dateRange == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Lengkapi lokasi dan tanggal terlebih dahulu.")),
    );
    return;
  }

  final url = Uri.parse(
    'https://apiairbnb-production.up.railway.app/api/guest/properties/filter'
    '?location=${Uri.encodeComponent(_locationController.text.trim())}'
    '&check_in=${_dateRange!.start.toIso8601String().split("T").first}'
    '&check_out=${_dateRange!.end.toIso8601String().split("T").first}'
    '&guests=$_guests'
  );

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
      setState(() => _error = 'Gagal mencari properti: ${response.body}');
    }
  } catch (e) {
    setState(() => _error = 'Terjadi kesalahan: $e');
  } finally {
    setState(() => _isLoading = false);
  }
}

  Future<void> _searchLocation(String query) async {
  if (query.isEmpty) return;

  final url = Uri.parse(
    'https://nominatim.openstreetmap.org/search?q=$query&format=json&limit=1',
  );

  final response = await http.get(url, headers: {
    'User-Agent': 'airbnbclone-app', // penting untuk Nominatim API
  });

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      final point = LatLng(lat, lon);
      setState(() {
        _selectedLatLng = point;
        _map.move(point, 14.0);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lokasi tidak ditemukan.")),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal mengambil lokasi (kode: ${response.statusCode})")),
    );
  }
}


  // ────────────────────────── Init ────────────────────────────
  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _initMyLocation();
  }

  // ────────────────────────── UI ──────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        toolbarHeight: 100,
        automaticallyImplyLeading: false,
        title: Row(children: [
          Expanded(
            child: TabBar(
              controller: _tab,
              indicatorColor:const Color(0xFFFF5A5F),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(icon: Icon(Icons.house), text: 'Kategori'),
                Tab(icon: Icon(Icons.filter_alt), text: 'Filter'),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Tutup',
          ),
        ]),
      ),
      body: TabBarView(
        controller: _tab,
        children: [
          _buildCategoryTab(),
          _buildFilterTab(),
        ],
      ),
    );
  }

  // ──────────────────── Widget: Kategori ──────────────────────
  Widget _buildCategoryTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      children: [
        const Text("Cari berdasarkan kategori",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        _buildSearchBox(_searchController, hint: "Contoh: villa, apartment, ..."),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _performCategorySearch,
          icon: const Icon(Icons.search),
          label: const Text('Cari'),
          style: _pinkButtonStyle,
        ),
        const Divider(height: 32),
        if (_results.isEmpty)
          _buildSuggestedCategories()
        else
          _buildResults(),
      ],
    );
  }

  Widget _buildSuggestedCategories() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Kategori Populer",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          ..._suggestedCategories.map((item) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  child: Text(item['icon']!, style: const TextStyle(fontSize: 18)),
                ),
                title: Text(item['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                onTap: () {
                  _searchController.text = item['name']!;
                  _performCategorySearch();
                },
              )),
        ],
      );

  // ───────────────────── Widget: Filter ───────────────────────
  Widget _buildFilterTab() {
  return ListView(
    padding: const EdgeInsets.all(20),
    children: [
      const Text("Pencarian dengan filter",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      const SizedBox(height: 12),

      // 🔍 Input cari lokasi
      Row(
        children: [
          Expanded(
            child: TextField(
              controller: _locationController,
              decoration: InputDecoration(
                hintText: 'Cari lokasi (misal: Surabaya)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _searchLocation(_locationController.text.trim()),
          ),
        ],
      ),
      const SizedBox(height: 12),

      // 🗺️ Map picker
      SizedBox(
        height: 250,
        child: Stack(
          children: [
            FlutterMap(
              mapController: _map,
              options: MapOptions(
                initialCenter: const LatLng(-7.250445, 112.768845), // Surabaya
                initialZoom: 12,
                onTap: (_, point) => setState(() => _selectedLatLng = point),
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                  userAgentPackageName: 'com.example.app',
                ),
                if (_selectedLatLng != null)
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: _selectedLatLng!,
                        width: 40,
                        height: 40,
                        child: const Icon(Icons.location_pin, size: 40, color: Colors.red),
                      ),
                    ],
                  )
              ],
            ),
            Positioned(
              right: 8,
              bottom: 8,
              child: FloatingActionButton(
                mini: true,
                tooltip: 'Lokasi saya',
                child: const Icon(Icons.my_location),
                onPressed: _initMyLocation,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 12),
      if (_selectedLatLng != null)
        Text('Lokasi dipilih: ${_selectedLatLng!.latitude.toStringAsFixed(5)}, '
            '${_selectedLatLng!.longitude.toStringAsFixed(5)}'),

      const SizedBox(height: 20),

      // 📅 Date range
      ListTile(
        leading: const Icon(Icons.date_range),
        title: Text(_dateRange == null
            ? 'Pilih tanggal check‑in & out'
            : '${_dateRange!.start.toString().split(' ').first} → '
              '${_dateRange!.end.toString().split(' ').first}'),
        onTap: _pickDateRange,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        tileColor: Colors.grey[100],
      ),
      const SizedBox(height: 12),

      // 👥 Guests
      Row(
        children: [
          const Icon(Icons.group),
          const SizedBox(width: 12),
          const Text('Tamu:'),
          const Spacer(),
          IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: _guests > 1
                  ? () => setState(() => _guests--)
                  : null),
          Text(_guests.toString(),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => setState(() => _guests++)),
        ],
      ),
      const SizedBox(height: 16),

      ElevatedButton.icon(
        icon: const Icon(Icons.search),
        label: const Text('Cari'),
        onPressed: _performFilterSearch,
        style: _pinkButtonStyle,
      ),

      const Divider(height: 32),
      _buildResults(),
    ],
  );
}


  // ─────────────────── Hasil Pencarian ────────────────────────
  Widget _buildResults() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error.isNotEmpty) {
      return Text(_error, style: const TextStyle(color: Colors.red));
    }
    if (_results.isEmpty) {
      return const Text('Belum ada hasil', textAlign: TextAlign.center);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Hasil Pencarian",
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ..._results.map(_buildPropertyCard),
      ],
    );
  }

  Widget _buildPropertyCard(Map<String, dynamic> item) {
  final id = item['id_property']; // Ambil ID properti
  final title = item['title'] ?? 'Tanpa Judul';
  final price = item['price_per_night']?.toString() ?? '-';
  final rating = item['avg_rating']?.toString() ?? '-';
  final image = item['cover_photo'] ?? item['cover_img'] ?? 'https://via.placeholder.com/300';

  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => DetailPropertyPage(propertyId: id),
        ),
      );
    },
    child: Container(
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
                    const Icon(Icons.star, size: 16, color: Colors.orange),
                    const SizedBox(width: 4),
                    Text(rating,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 4),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text('Rp $price / malam',
                    style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}


  // ────────────────────── Helpers ─────────────────────────────
  Widget _buildSearchBox(TextEditingController c, {String? hint}) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
        ),
        child: TextField(
          controller: c,
          decoration: InputDecoration(
            hintText: hint,
            border: InputBorder.none,
            icon: const Icon(Icons.search),
          ),
        ),
      );

  ButtonStyle get _pinkButtonStyle => ElevatedButton.styleFrom(
        backgroundColor:const Color(0xFFFF5A5F),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      );
}
