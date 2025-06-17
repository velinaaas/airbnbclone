import 'package:airbnbclone/pages/hari_ini_page.dart';
import 'package:airbnbclone/pages/pesan_page.dart';
import 'package:airbnbclone/pages/tempat_page.dart';
import 'package:airbnbclone/views/detail_property.dart';
import 'package:airbnbclone/views/experience.dart';
import 'package:airbnbclone/views/favorit.dart';
import 'package:airbnbclone/views/perjalanan.dart';
import 'package:airbnbclone/views/profil.dart';
import 'package:airbnbclone/views/search.dart';
import 'package:airbnbclone/views/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airbnbclone/views/login.dart';
import 'package:airbnbclone/views/register.dart';
import 'package:airbnbclone/views/explore.dart'; // contoh home setelah login
import 'package:airbnbclone/pages/menu_page.dart'; // jika ingin ke menu langsung

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') != null;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Airbnb Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasData && snapshot.data == true) {
            return ExplorePage(); // atau MenuPage() atau halaman setelah login
          } else {
            return const LoginPage();
          }
        },
      ),
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
        '/hari_ini': (context) => HariIniPage(),  
        '/tempat': (context) => TempatPage(),
        '/menu': (context) => MenuPage(),

        // '/pesan': (context) => PesanPage(),
      },
    );
  }
}
