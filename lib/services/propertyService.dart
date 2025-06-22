import 'dart:convert';
import 'package:airbnbclone/models/property.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PropertyService {
  final String baseUrl = 'https://apiairbnb-production.up.railway.app/api';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<List<Property>> getHostProperties() async {
  final token = await _getToken();                 // atau cara ambil token-mu
  final response = await http.get(
    Uri.parse('https://apiairbnb-production.up.railway.app/api/properties/get-host'),
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> json = jsonDecode(response.body);

    // ambil list di dalam key "properties"
    final List<dynamic> list = json['properties'] ?? [];

    return list.map<Property>((item) => Property.fromJson(item)).toList();
  } else {
    throw Exception('Gagal memuat properti host');
  }
}


  Future<bool> deleteProperty(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl/properties/delete/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return response.statusCode == 200;
  }
}
