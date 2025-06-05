import 'package:airbnbclone/views/experience.dart';
import 'package:airbnbclone/views/favorit.dart';
import 'package:airbnbclone/views/login.dart';
import 'package:airbnbclone/views/perjalanan.dart';
import 'package:airbnbclone/views/pesan.dart';
import 'package:airbnbclone/views/service.dart';
import 'package:flutter/material.dart';
import 'package:airbnbclone/views/explore.dart';
import 'package:airbnbclone/views/search.dart';
import 'package:airbnbclone/views/detail_property.dart';
import 'package:airbnbclone/views/profil.dart';
import 'package:airbnbclone/views/register.dart'; // tambahkan ini

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/register', // ganti ke register
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/explore': (context) => ExplorePage(),
        '/search': (context) => SearchPage(),
        '/detail': (context) => DetailPropertyPage(),
        '/profil': (context) => ProfilPage(),
        '/experience': (context) => ExperiencePage(),
        '/service': (context) => ServicePage(),
        '/favorit': (context) => FavoritPage(),
        '/perjalanan': (context) => PerjalananPage(),
        '/pesan': (context) => PesanPage(),
      },
    );
  }
}
