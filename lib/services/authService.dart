// ignore: file_names
import 'dart:convert';
import 'package:airbnbclone/models/user_models.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_models.dart';

class AuthService {
  static const String _baseUrl = 'https://apiairbnb-production.up.railway.app/api/auth';

  // REGISTER
  static Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$_baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name,
          "email": email,
          "phone": phone,
          "password": password,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrasi berhasil!')),
        );
        return true;
      } else {
        final resBody = jsonDecode(response.body);
        String message = resBody['message'] ?? 'Gagal mendaftar';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      return false;
    }
  }

  // LOGIN
  static Future<bool> login({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    final url = Uri.parse('$_baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'];
        final userData = data['user'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(userData));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
        return true;
      } else {
        final resBody = jsonDecode(response.body);
        String message = resBody['message'] ?? 'Login gagal';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $message')),
        );
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      return false;
    }
  }

  // Ambil data user dari shared preferences
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // Logout: hapus token dan user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
  }
  
static Future<bool> switchToHostRole(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final userJson = prefs.getString('user');

  if (token == null || userJson == null || userJson.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Data user rusak, silakan login ulang.')),
    );
    return false;
  }

  try {
    // Parse user data dengan null safety
    Map<String, dynamic>? userData;
    try {
      userData = jsonDecode(userJson) as Map<String, dynamic>?;
    } catch (e) {
      print('Error parsing user JSON: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data user tidak valid, silakan login ulang.')),
      );
      return false;
    }

    if (userData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data user kosong, silakan login ulang.')),
      );
      return false;
    }

    final user = User.fromJson(userData);
    final url = Uri.parse('https://apiairbnb-production.up.railway.app/api/users/switch-role');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role_id': 2}),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: "${response.body}"');
    print('Response headers: ${response.headers}');

    if (response.statusCode == 200) {
      // Success case
      final updatedUser = user.toJson();
      
      // Pastikan roles ada dan merupakan List
      if (updatedUser['roles'] == null) {
        updatedUser['roles'] = <String>[];
      }
      
      // Convert ke List<String> jika perlu
      List<String> roles = [];
      if (updatedUser['roles'] is List) {
        roles = List<String>.from(updatedUser['roles']);
      }
      
      if (!roles.contains('host')) {
        roles.add('host');
      }
      
      updatedUser['roles'] = roles;
      
      await prefs.setString('user', jsonEncode(updatedUser));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sekarang kamu adalah Tuan Rumah!')),
      );
      return true;
    } else {
      // Error case - handle response body safely
      String errorMessage = 'Perubahan role gagal';
      
      // Check if response body exists and is not empty
      if (response.body.isNotEmpty) {
        try {
          // Try to parse as JSON
          final responseData = jsonDecode(response.body);
          
          if (responseData != null) {
            // Safe casting with null check
            if (responseData is Map<String, dynamic>) {
              errorMessage = responseData['message']?.toString() ?? errorMessage;
            } else if (responseData is String) {
              errorMessage = responseData;
            }
          }
        } catch (jsonError) {
          // If JSON parsing fails, use raw response or default message
          print('JSON decode error: $jsonError');
          if (response.body.length < 200) {
            // Only use raw response if it's reasonably short
            errorMessage = response.body;
          }
        }
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $errorMessage')),
      );
      return false;
    }
  } catch (e, stackTrace) {
    print('Exception in switchToHostRole: $e');
    print('Stack trace: $stackTrace');
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
    );
    return false;
  }
}
}
