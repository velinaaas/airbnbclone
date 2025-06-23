import 'dart:convert';
import 'package:airbnbclone/models/bookings_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PerjalananPage extends StatefulWidget {
  const PerjalananPage({Key? key}) : super(key: key);

  @override
  State<PerjalananPage> createState() => _PerjalananPageState();
}

class _PerjalananPageState extends State<PerjalananPage> {
  late Future<List<Booking>> _bookingsFuture;

  @override
  void initState() {
    super.initState();
    _bookingsFuture = fetchBookings();
  }

  Future<List<Booking>> fetchBookings() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final uri = Uri.parse("https://apiairbnb-production.up.railway.app/api/guest/bookings");

    final resp = await http.get(uri, headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    });

    if (resp.statusCode == 200) {
      final json = jsonDecode(resp.body);
      final list = (json['bookings'] as List)
          .map((e) => Booking.fromJson(e))
          .toList();
      return list;
    } else {
      throw Exception("Failed to load bookings: ${resp.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Booking'),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada riwayat booking'));
          }

          final bookings = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (ctx, i) {
              final b = bookings[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(
                      b.property.coverImage,
                      width: double.infinity,
                      height: 180,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            b.property.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            b.property.address,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${dateFormat.format(b.startDate)} - ${dateFormat.format(b.endDate)}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Rp ${b.totalPrice}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          _buildStatusRow(b.status, b.payment),
                          if (b.payment != null && b.payment['code'] != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              'Kode Pembayaran: ${b.payment['code']}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                          if (b.status == 'completed') ...[
                            const SizedBox(height: 12),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/tulis-ulasan',
                                  arguments: {
                                    'propertyId': b.property.id,
                                    'bookingId': b.id,
                                  },
                                );
                              },
                              icon: const Icon(Icons.rate_review),
                              label: const Text("Tulis Ulasan"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5A5F),
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        selectedItemColor: const Color(0xFFFF5A5F),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          const routes = ['/explore', '/favorit', '/perjalanan', '/profil'];
          if (index != 2) Navigator.pushNamed(context, routes[index]);
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: "Telusuri"),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: "Favorit"),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_travel), label: "Perjalanan"),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String status, dynamic payment) {
    final isPaid = payment != null;

    Color color;
    IconData icon;
    String text;

    if (status == 'rejected') {
      color = Colors.red;
      icon = Icons.cancel;
      text = 'Ditolak';
    } else if (isPaid) {
      color = Colors.green;
      icon = Icons.check_circle;
      text = 'Dibayar';
    } else {
      color = Colors.orange;
      icon = Icons.hourglass_bottom;
      text = 'Status: ${status[0].toUpperCase()}${status.substring(1)}';
    }

    return Row(
      children: [
        Icon(icon, color: color),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(color: color)),
      ],
    );
  }
}
