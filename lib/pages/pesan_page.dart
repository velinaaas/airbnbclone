import 'package:flutter/material.dart';

class PesanPage extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {
      'name': 'Philip',
      'message': 'Anda: Pertanyaan terkirim',
      'time': '01.28',
      'status': 'Pertanyaan terkirim · 24–25 Jun · Samping...',
      'image':
          'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?w=400',
      'avatar':
          'https://images.unsplash.com/photo-1607746882042-944635dfe10e?w=100',
    },
  ];

  PesanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pesan'),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
          IconButton(onPressed: () {}, icon: Icon(Icons.settings)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          return ListTile(
            contentPadding: EdgeInsets.symmetric(vertical: 8),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                msg['image']!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(msg['name']!, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(msg['time']!, style: TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(msg['message']!),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Colors.red),
                    SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        msg['status']!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: CircleAvatar(
              backgroundImage: NetworkImage(msg['avatar']!),
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}
