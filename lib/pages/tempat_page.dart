import 'package:flutter/material.dart';

class TempatPage extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {
      'name': 'Rumah Asri',
      'location': 'Sumbersari, Jember',
      'image':
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600',
    },
    {
      'name': 'Villa Indah',
      'location': 'Kaliurang, Yogyakarta',
      'image':
          'https://images.unsplash.com/photo-1568605114967-8130f3a36994?w=600',
    },
    {
      'name': 'Rumah Harian',
      'location': 'Banyuwangi, Jawa Timur',
      'image':
          'https://images.unsplash.com/photo-1599423300746-b62533397364?w=600',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iklan Anda'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Text(
            'Sedang diproses',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          Column(
            children: properties.map((property) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: Image.network(
                    property['image']!,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                  title: Text(property['name']!),
                  subtitle: Text(property['location']!),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}
