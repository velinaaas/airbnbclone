import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const baseUrl = 'https://apiairbnb-production.up.railway.app/api/host';

  final Map<String,String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer YOUR_TOKEN',
  };

  Future<List<dynamic>> fetchBookings(String status) async {
    final resp = await http.get(
      Uri.parse('$baseUrl/host/bookings?status=$status'),
      headers: headers,
    );
    if (resp.statusCode == 200) return json.decode(resp.body);
    throw Exception('Fetch $status bookings failed');
  }

  Future<void> patchBooking(String bookingId, String action) async {
    final resp = await http.patch(
      Uri.parse('$baseUrl/bookings/$bookingId/$action'),
      headers: headers,
    );
    if (resp.statusCode != 200) throw Exception('Action $action failed');
  }

  Future<List<dynamic>> fetchReviews() async {
    final resp = await http.get(
      Uri.parse('$baseUrl/host/reviews'),
      headers: headers,
    );
    if (resp.statusCode == 200) return json.decode(resp.body);
    throw Exception('Fetch reviews failed');
  }
}
