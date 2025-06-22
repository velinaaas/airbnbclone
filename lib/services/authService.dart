// ignore: file_names
import 'dart:convert';
import 'package:airbnbclone/models/user_models.dart';
import 'package:airbnbclone/models/user_profil.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _baseUrl = 'https://apiairbnb-production.up.railway.app/api/auth';

  // ==================== REGISTER ====================
  static Future<bool> register({
    required String name,
    required String email,
    required String phone_number,
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
          "phone_number": phone_number,
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

  // ==================== LOGIN ====================
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
        final roles = List<String>.from(data['roles'] ?? []);

        final dummyUser = {
          "id": 0,
          "name": email.split('@')[0],
          "email": email,
          "phone_number": "",
          "roles": roles
        };

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);
        await prefs.setString('user', jsonEncode(dummyUser));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
        return true;
      } else {
        final resBody = jsonDecode(response.body);
        String message = resBody['message'] ?? resBody['error'] ?? 'Login gagal';
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

  // ==================== GET USER DUMMY ====================
  static Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('user');
    if (userJson != null) {
      try {
        final data = jsonDecode(userJson) as Map<String, dynamic>;
        return User.fromJson(data);
      } catch (e) {
        print('Gagal parsing user: $e');
      }
    }
    return null;
  }

  // ==================== LOGOUT ====================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  // ==================== SWITCH ROLE TUAN RUMAH ====================
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
      final decoded = jsonDecode(userJson);
      if (decoded == null || decoded is! Map<String, dynamic>) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User tidak valid. Silakan login ulang.')),
        );
        return false;
      }

      final user = User.fromJson(decoded);

      final response = await http.post(
        Uri.parse('https://apiairbnb-production.up.railway.app/api/users/switch-role'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'role_id': 2}),
      );

      if (response.statusCode == 200) {
        List<String> updatedRoles = List<String>.from(user.roles);
        if (!updatedRoles.contains('host')) {
          updatedRoles.add('host');
        }

        final updatedUser = User(
          id: user.id,
          name: user.name,
          email: user.email,
          phone_number: user.phone_number,
          roles: updatedRoles,
        );

        await prefs.setString('user', jsonEncode(updatedUser.toJson()));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sekarang kamu adalah Tuan Rumah!')),
        );
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal switch role: ${response.body}')),
        );
        return false;
      }
    } catch (e) {
      print('Error switchRole: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: ${e.toString()}')),
      );
      return false;
    }
  }

  // ==================== GET PROFILE ASLI dari API ====================
  static Future<UserProfile?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    final response = await http.get(
      Uri.parse('https://apiairbnb-production.up.railway.app/api/users/profile'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserProfile.fromJson(jsonData);
    } else {
      print('Gagal ambil profil: ${response.body}');
      return null;
    }
  }
}

Future<bool> switchToGuestRole(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  final userJson = prefs.getString('user');

  if (token == null || userJson == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Silakan login ulang.')),
    );
    return false;
  }

  try {
    final decoded = jsonDecode(userJson);
    final user = User.fromJson(decoded);

    final response = await http.post(
      Uri.parse('https://apiairbnb-production.up.railway.app/api/users/switch-role'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'role_id': 1}), // 1 = guest
    );

    if (response.statusCode == 200) {
      List<String> updatedRoles = List<String>.from(user.roles);
      if (!updatedRoles.contains('guest')) {
        updatedRoles.add('guest');
      }

      final updatedUser = User(
        id: user.id,
        name: user.name,
        email: user.email,
        phone_number: user.phone_number,
        roles: updatedRoles,
      );

      await prefs.setString('user', jsonEncode(updatedUser.toJson()));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sekarang kamu dalam mode Tamu.')),
      );
      return true;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal switch ke tamu: ${response.body}')),
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
