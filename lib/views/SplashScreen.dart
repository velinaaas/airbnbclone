import 'dart:convert';
import 'package:airbnbclone/pages/hari_ini_page.dart';
import 'package:airbnbclone/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airbnbclone/views/explore.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginAndRedirect();
  }

  Future<void> _checkLoginAndRedirect() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final userJson = prefs.getString('user');

    if (token == null || userJson == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }

    final user = jsonDecode(userJson);
    final roles = List<String>.from(user['roles'] ?? []);

    if (roles.contains('host')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HariIniPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ExplorePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
  return const Scaffold(
    backgroundColor: Colors.white,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            image: AssetImage('assets/images/airbnb-seeklogo.png'),
            width: 120,
            height: 120,
          ),
          SizedBox(height: 24),
          CircularProgressIndicator(color: Color(0xFFFF2D87)), // warna pink Airbnb
        ],
      ),
    ),
  );
}
}