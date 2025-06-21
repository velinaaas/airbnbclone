import 'dart:async';
import 'package:airbnbclone/views/explore.dart';
import 'package:airbnbclone/views/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    await Future.delayed(const Duration(seconds: 2));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // Belum login → arahkan ke LoginPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      // Sudah login → arahkan ke ExplorePage SELALU
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
