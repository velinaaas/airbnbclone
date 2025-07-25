import 'package:airbnbclone/pages/hari_ini_page.dart' as hari_ini hide MenuPage;
import 'package:airbnbclone/pages/hari_ini_page.dart' hide MenuPage;
import 'package:airbnbclone/pages/pesan_page.dart' as pesan;
import 'package:airbnbclone/pages/tempat_page.dart';
import 'package:airbnbclone/views/SplashScreen.dart';
import 'package:airbnbclone/views/detail_property.dart';
import 'package:airbnbclone/views/experience.dart';
import 'package:airbnbclone/views/favorit.dart';
import 'package:airbnbclone/views/perjalanan.dart';
import 'package:airbnbclone/views/profil.dart';
import 'package:airbnbclone/views/review.dart';
import 'package:airbnbclone/views/search.dart';
import 'package:airbnbclone/views/service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:airbnbclone/views/login.dart';
import 'package:airbnbclone/views/register.dart';
import 'package:airbnbclone/views/explore.dart'; // contoh home setelah login
import 'package:airbnbclone/pages/menu_page.dart';
 // jika ingin ke menu langsung

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
        colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 255, 255, 255)),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // ini diarahkan ke splash screen
      routes: {
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/explore': (context) => ExplorePage(),
        '/search': (context) => SearchPage(),
        '/detail': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as int;
          return DetailPropertyPage(propertyId: args);
        },
        '/profil': (context) => ProfilPage(),
        '/experience': (context) => ExperiencePage(),
        '/service': (context) => ServicePage(),
        '/favorit': (context) => FavoritPage(),
        '/perjalanan': (context) => PerjalananPage(),
        '/pesan': (context) => pesan.PesanPage(),
        '/hari_ini': (context) => hari_ini.HariIniPage(),
        '/tempat': (context) => TempatPage(),
        '/menu': (context) => MenuPage(),
        '/tulis-ulasan': (context) => const WriteReviewPage(),
      },
    );
  }
}