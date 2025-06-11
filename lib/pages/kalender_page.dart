import 'package:flutter/material.dart';

class KalenderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kalender")),
      body: Center(
        child: Text(
          'Kalender akan tersedia di sini.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
