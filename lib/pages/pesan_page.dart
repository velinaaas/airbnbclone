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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 8,
              children: [
                _FilterChip(label: 'Semua', selected: true),
                _FilterChip(label: 'Mode Tuan Rumah'),
                _FilterChip(label: 'Bepergian'),
                _FilterChip(label: 'Dukungan'),
              ],
            ),
          ),
          SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
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
                          Icon(Icons.circle, size: 8, color: Colors.red, semanticLabel: 'status'),
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
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: OutlinedButton(
              onPressed: () {},
              child: Text('Rampungkan pemesanan'),
              style: OutlinedButton.styleFrom(
                minimumSize: Size(double.infinity, 44),
                side: BorderSide(color: Colors.black),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;

  const _FilterChip({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {},
      selectedColor: Colors.black,
      labelStyle: TextStyle(color: selected ? Colors.white : Colors.black),
      backgroundColor: Colors.grey[200],
    );
  }
}
