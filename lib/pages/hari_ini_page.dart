// Pastikan sudah menambahkan paket `http` dan `shared_preferences` di pubspec.yaml
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:airbnbclone/pages/tempat_page.dart';
// import 'package:airbnbclone/pages/pesan_page.dart';
import 'package:airbnbclone/pages/menu_page.dart';
import 'package:intl/intl.dart';

class HariIniPage extends StatefulWidget {
  const HariIniPage({super.key});

  @override
  State<HariIniPage> createState() => _HariIniPageState();
}

class _HariIniPageState extends State<HariIniPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const _HariIniContent(),
    TempatPage(),
    // PesanPage(),
    const MenuPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFFFF5A5F), // Airbnb pink
        unselectedItemColor: Colors.grey[600],
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        elevation: 8,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_box_outlined), 
            label: 'Hari ini'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.house_outlined), 
            label: 'Tempat'
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.chat_bubble_outline), 
          //   label: 'Pesan'
          // ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline), 
            label: 'Profil'
          ),
        ],
      ),
    );
  }
}

class _HariIniContent extends StatefulWidget {
  const _HariIniContent();

  @override
  State<_HariIniContent> createState() => _HariIniContentState();
}

class _HariIniContentState extends State<_HariIniContent> {
  String selectedTab = 'pending';
  bool _loading = false;
  List<dynamic> bookings = [];
  List<dynamic> reviews = [];
  final String baseUrl = 'https://apiairbnb-production.up.railway.app/api/host';
  String? _token;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    await fetchBookings();
  }

  Map<String, String> _headers() => {
        'Content-Type': 'application/json',
        if (_token != null) 'Authorization': 'Bearer $_token',
      };

  Future<void> fetchBookings() async {
    setState(() => _loading = true);
    final url = selectedTab == 'reviews'
        ? '$baseUrl/host/reviews'
        : '$baseUrl/host/bookings?status=$selectedTab';

    try {
      final res = await http.get(Uri.parse(url), headers: _headers());
      if (res.statusCode == 200) {
        final decoded = json.decode(res.body);
        setState(() {
          if (selectedTab == 'reviews') {
            reviews = decoded['reviews'] ?? [];
          } else {
            bookings = decoded['bookings'] ?? [];
          }
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
        debugPrint('DEBUG fetch $selectedTab statusCode: ${res.statusCode}, body: ${res.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal memuat data (${res.statusCode}).'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      debugPrint('ERROR fetchBookings: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan jaringan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> handleAction(String id, String action) async {
    final url = '$baseUrl/bookings/$id/$action';
    try {
      final res = await http.patch(Uri.parse(url), headers: _headers());
      if (res.statusCode == 200) {
        await fetchBookings();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil $action'),
            backgroundColor: Colors.green[400],
          ),
        );
      } else {
        debugPrint('DEBUG patch $action statusCode: ${res.statusCode}, body: ${res.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal $action (${res.statusCode}).'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } catch (e) {
      debugPrint('ERROR handleAction: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Terjadi kesalahan jaringan.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _tabButton(String label, String value) {
    final isSelected = selectedTab == value;
    return GestureDetector(
      onTap: () async {
        if (selectedTab != value) {
          setState(() => selectedTab = value);
          await fetchBookings();
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF5A5F) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF5A5F) : Colors.grey[300]!,
            width: 1,
          ),
          boxShadow: isSelected ? [
            BoxShadow(
              color: const Color(0xFFFF5A5F).withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  String formatDate(String date) {
    try {
      return DateFormat('dd MMM yyyy', 'id_ID').format(DateTime.parse(date));
    } catch (e) {
      return date;
    }
  }

  String formatCurrency(dynamic value) {
  if (value == null) return 'Rp0';
  try {
    final number = double.tryParse(value.toString()) ?? 0;
    return NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(number);
  } catch (_) {
    return 'Rp0';
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              color: Colors.white,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selamat datang, Tuan Rumah!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          color: Colors.grey[700],
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Tab Buttons
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _tabButton('Belum diproses', 'pending'),
                        const SizedBox(width: 12),
                        _tabButton('Terkonfirmasi', 'confirmed'),
                        const SizedBox(width: 12),
                        _tabButton('Selesai', 'completed'),
                        const SizedBox(width: 12),
                        _tabButton('Ulasan tamu', 'reviews'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            
            // Content Section
            Expanded(
              child: _loading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5A5F)),
                      ),
                    )
                  : selectedTab == 'reviews'
                      ? _buildReviewsList()
                      : _buildBookingsList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewsList() {
    if (reviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada ulasan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ulasan dari tamu akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        final review = reviews[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: const Color(0xFFFF5A5F),
                    child: Text(
                      (review['guest_name'] ?? 'T')[0].toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['user_name'] ?? 'Tamu',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (i) {
                            final rating = int.tryParse(review['rating']?.toString() ?? '0') ?? 0;
                            return Icon(
                              i < rating ? Icons.star : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (review['comment'] != null && review['comment'].toString().isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  review['comment'],
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildBookingsList() {
    if (bookings.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.event_note_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Tidak ada pemesanan',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Pemesanan dengan status ${_getStatusText(selectedTab)} akan muncul di sini',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Guest info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: const Color(0xFFFF5A5F),
                      child: Text(
                        (booking['guest_name'] ?? 'T')[0].toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            booking['guest_name'] ?? 'Tamu',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            booking['property_title'] ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Booking details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        Icons.login,
                        'Check-in',
                        formatDate(booking['start_date'] ?? ''),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.logout,
                        'Check-out',
                        formatDate(booking['end_date'] ?? ''),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        Icons.payments,
                        'Total Harga',
                        formatCurrency(booking['total_price']),
                      ),
                      if (booking['payment_code'] != null) ...[
                        const SizedBox(height: 12),
                        _buildDetailRow(
                          Icons.receipt,
                          'Kode Pembayaran',
                          booking['payment_code'],
                        ),
                      ],
                    ],
                  ),
                ),
                
                const SizedBox(height: 20),
                
                // Action buttons
                if (selectedTab == 'pending') ...[
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => handleAction(
                            booking['id_booking'].toString(),
                            'accept',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF5A5F),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Terima',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => handleAction(
                            booking['id_booking'].toString(),
                            'reject',
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFFF5A5F),
                            side: const BorderSide(color: Color(0xFFFF5A5F)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Tolak',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else if (selectedTab == 'confirmed') ...[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => handleAction(
                        booking['id_booking'].toString(),
                        'complete',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Selesaikan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 12),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'belum diproses';
      case 'confirmed':
        return 'terkonfirmasi';
      case 'completed':
        return 'selesai';
      case 'reviews':
        return 'ulasan';
      default:
        return status;
    }
  }
}