import 'package:flutter/material.dart';

class DetailPropertyPage extends StatelessWidget {
  const DetailPropertyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // 🖼️ Gambar Utama + Navigasi
          Stack(
            children: [
              Image.network(
                'https://images.unsplash.com/photo-1600585154340-be6161a56a0c',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Positioned(
                top: 40,
                left: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.share),
                        onPressed: () {},
                      ),
                    ),
                    SizedBox(width: 8),
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: Icon(Icons.favorite_border),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 10,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '1 / 25',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
          ),

          // 📄 Detail Properti
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Casa De Arumanis by Kava Stay',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  'Seluruh rumah di Kecamatan Cibeunying Kaler, Indonesia',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 8),
                Text(
                  '10 tamu · 3 kamar tidur · 5 tempat tidur · 3,5 kamar mandi',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('4.91', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('★★★★★', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(Icons.verified, size: 20),
                        SizedBox(height: 4),
                        Text('Pilihan tamu', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                    Column(
                      children: [
                        Text('67', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Ulasan', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                Divider(height: 32),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://tse2.mm.bing.net/th/id/OIP.34dslCyrK7Nh4zqQf9lxwAHaE8?cb=iwc2&rs=1&pid=ImgDetMain',
                    ),
                  ),
                  title: Text('Tuan rumah: Rafif'),
                  subtitle: Text('HosTeladan · Tuan rumah selama 3 tahun'),
                ),

                // 🛎️ Fasilitas
                SizedBox(height: 16),
                Text(
                  'Fasilitas yang ditawarkan',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                fasilitasItem(Icons.kitchen, 'Dapur'),
                fasilitasItem(Icons.wifi, 'Wifi'),
                fasilitasItem(Icons.work, 'Area kerja khusus'),
                fasilitasItem(Icons.local_parking, 'Parkir gratis di areal properti'),
                fasilitasItem(Icons.hot_tub, 'Bak mandi air panas'),
                fasilitasItem(Icons.warning, 'Alarm karbon monoksida', isAvailable: false),
                fasilitasItem(Icons.smoke_free, 'Alarm asap', isAvailable: false),

                SizedBox(height: 100), // agar tidak tertutup bottomNavigationBar
              ],
            ),
          ),
        ],
      ),

      // 🔘 Bawah: Harga & Tombol Pesan
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rp4.337.650',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('Untuk 2 malam · 18–20 Jul', style: TextStyle(fontSize: 12)),
                  SizedBox(height: 4),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('💎 Jarang ada', style: TextStyle(fontSize: 12)),
                  )
                ],
              ),
            ),
            SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                // Tambahkan aksi booking di sini
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.pink,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text('Pesan'),
            )
          ],
        ),
      ),
    );
  }

  // Widget Fasilitas dengan opsi dicoret
  Widget fasilitasItem(IconData icon, String label, {bool isAvailable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: isAvailable ? Colors.black : Colors.grey),
          SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              decoration: isAvailable ? null : TextDecoration.lineThrough,
              color: isAvailable ? Colors.black : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
