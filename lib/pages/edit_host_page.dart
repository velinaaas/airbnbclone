import 'package:flutter/material.dart';

class EditHostPage extends StatefulWidget {
  const EditHostPage({super.key});

  @override
  State<EditHostPage> createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditHostPage> {
  final _formKey = GlobalKey<FormState>();
  String _nama = 'Titis';
  String _email = 'titis@email.com';
  String _telepon = '081234567890';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profil Host"),
        backgroundColor: Color(0xFFFF2D87),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _nama,
                decoration: const InputDecoration(
                  labelText: "Nama",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _nama = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Nama tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => _email = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "Email tidak boleh kosong" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                initialValue: _telepon,
                decoration: const InputDecoration(
                  labelText: "No Telepon",
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) => _telepon = value,
                validator: (value) =>
                    value == null || value.isEmpty ? "No telepon tidak boleh kosong" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Di sini kamu bisa simpan ke database atau API
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Profil berhasil diperbarui")),
                    );
                    Navigator.pop(context); // Kembali ke halaman sebelumnya
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF2D87),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
