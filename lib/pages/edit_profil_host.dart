// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// class EditProfilPage extends StatefulWidget {
//   const EditProfilPage({super.key});

//   @override
//   State<EditProfilPage> createState() => _EditProfilPageState();
// }

// class _EditProfilPageState extends State<EditProfilPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _nama = '';
//   String _email = '';
//   String _telepon = '';
//   bool _loading = true;

//   @override
//   void initState() {
//     super.initState();
//     _getProfileData();
//   }

//   Future<void> _getProfileData() async {
//     final prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token');

//     if (token == null) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("Token tidak ditemukan. Silakan login ulang.")),
//       );
//       return;
//     }

//     try {
//       final response = await http.get(
//         Uri.parse("https://apiairbnb-production.up.railway.app/api/users/profile"),
//         headers: {'Authorization': 'Bearer $token'},
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         setState(() {
//           _nama = data['name'] ?? '';
//           _email = data['email'] ?? '';
//           _telepon = data['phone'] ?? '';
//           _loading = false;
//         });
//       } else {
//         throw Exception('Gagal mengambil profil');
//       }
//     } catch (e) {
//       print("Error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Gagal memuat data profil: $e")),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Edit Profil"),
//         backgroundColor: const Color(0xFFFF2D87),
//         foregroundColor: Colors.white,
//       ),
//       body: _loading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: ListView(
//                   children: [
//                     const SizedBox(height: 20),
//                     TextFormField(
//                       initialValue: _nama,
//                       decoration: const InputDecoration(
//                         labelText: "Nama",
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) => _nama = value,
//                       validator: (value) =>
//                           value == null || value.isEmpty ? "Nama tidak boleh kosong" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue: _email,
//                       decoration: const InputDecoration(
//                         labelText: "Email",
//                         border: OutlineInputBorder(),
//                       ),
//                       onChanged: (value) => _email = value,
//                       validator: (value) =>
//                           value == null || value.isEmpty ? "Email tidak boleh kosong" : null,
//                     ),
//                     const SizedBox(height: 16),
//                     TextFormField(
//                       initialValue: _telepon,
//                       decoration: const InputDecoration(
//                         labelText: "No Telepon",
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.phone,
//                       onChanged: (value) => _telepon = value,
//                       validator: (value) => value == null || value.isEmpty
//                           ? "No telepon tidak boleh kosong"
//                           : null,
//                     ),
//                     const SizedBox(height: 30),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (_formKey.currentState!.validate()) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("Profil berhasil diperbarui (sementara)")),
//                           );
//                           Navigator.pop(context);
//                         }
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFFF2D87),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(30),
//                         ),
//                       ),
//                       child: const Text("Simpan Perubahan"),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }
// }
 