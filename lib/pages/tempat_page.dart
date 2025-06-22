import 'package:airbnbclone/services/propertyService.dart';
import 'package:flutter/material.dart';
import 'package:airbnbclone/models/property.dart';
import 'package:airbnbclone/pages/create_property.dart';

class TempatPage extends StatefulWidget {
  const TempatPage({super.key});

  @override
  State<TempatPage> createState() => _TempatPageState();
}

class _TempatPageState extends State<TempatPage> {
  final PropertyService propertyService = PropertyService();
  List<Property> properties = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchHostProperties();
  }

  Future<void> fetchHostProperties() async {
    try {
      final data = await propertyService.getHostProperties();
      setState(() {
        properties = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print('Error: $e');
    }
  }

  Future<void> deleteProperty(int id) async {
    final success = await propertyService.deleteProperty(id);
    Navigator.pop(context);

    if (success) {
      setState(() {
        properties.removeWhere((item) => item.idProperty == id);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Iklan berhasil dihapus')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus iklan')),
      );
    }
  }

  void _showPropertyDetail(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 20),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: property.coverPhoto != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.network(
                              property.coverPhoto!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(Icons.image, size: 40),
                  ),
                  SizedBox(height: 16),
                  Text(
                    property.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreatePropertyPage(
                            isEdit: true,
                            existingProperty: property,
                            initialData: {
                              'id_property': property.idProperty,
                              'title': property.title,
                              'description': property.description,
                              'price_per_night': property.pricePerNight,
                              'address': property.address,
                              'latitude': property.latitude,
                              'longitude': property.longitude,
                              'bedrooms': property.bedrooms,
                              'bathrooms': property.bathrooms,
                              'max_guests': property.maxGuests,
                              'category_id': property.category?.id ?? '',
                            },
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Edit iklan',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => deleteProperty(property.idProperty),
                    child: Text(
                      'Menghapus iklan',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 16,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
              Positioned(
                top: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, size: 28),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black, size: 32),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreatePropertyPage(isEdit: false),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : properties.isEmpty
              ? Center(child: Text('Belum ada iklan'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return GestureDetector(
                      onTap: () => _showPropertyDetail(context, property),
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: Row(
                          children: [
                            // Cover image di kiri
                            if (property.coverPhoto != null)
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(12),
                                  bottomLeft: Radius.circular(12),
                                ),
                                child: Image.network(
                                  property.coverPhoto!,
                                  width: 120,
                                  height: 120,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(12),
                                    bottomLeft: Radius.circular(12),
                                  ),
                                ),
                                child: Icon(Icons.photo, size: 40, color: Colors.grey[600]),
                              ),

                            // Informasi di kanan
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(property.title,
                                        style: TextStyle(
                                            fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 4),
                                    Text(property.address,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis),
                                    SizedBox(height: 6),
                                    Text('Rp ${property.pricePerNight.toInt()}/malam'),
                                    SizedBox(height: 4),
                                    Text(
                                        '${property.bedrooms} kamar • ${property.bathrooms} mandi • ${property.maxGuests} tamu'),
                                    if (property.categoryName != null)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 4),
                                        child: Text('Kategori: ${property.categoryName}'),
                                      ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Dibuat: ${property.createdAt.split("T").first}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
