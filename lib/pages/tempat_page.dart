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
        SnackBar(
          content: Text('Iklan berhasil dihapus'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus iklan'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  void _showPropertyDetail(BuildContext context, Property property) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 24),
                
                // Property image
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: property.coverPhoto != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(
                            property.coverPhoto!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(Icons.home, size: 48, color: Colors.grey[400]),
                        ),
                ),
                SizedBox(height: 20),
                
                // Property title
                Text(
                  property.title,
                  style: TextStyle(
                    fontSize: 22, 
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                
                // Property details
                Text(
                  property.address,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 32),
                
                // Edit button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await Navigator.push(
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
                      fetchHostProperties();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFFF5A5F), // Airbnb pink
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Edit iklan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                
                // Delete button
                TextButton(
                  onPressed: () => deleteProperty(property.idProperty),
                  child: Text(
                    'Hapus iklan',
                    style: TextStyle(
                      color: Colors.red[400],
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Tempat Saya',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 16),
            child: IconButton(
              icon: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFFF5A5F),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add, color: Colors.white, size: 20),
              ),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreatePropertyPage(isEdit: false),
                  ),
                );
                fetchHostProperties();
              },
            ),
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF5A5F)),
              ),
            )
          : properties.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.home_outlined,
                        size: 80,
                        color: Colors.grey[300],
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Belum ada iklan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tambahkan tempat pertama Anda',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: properties.length,
                  itemBuilder: (context, index) {
                    final property = properties[index];
                    return GestureDetector(
                      onTap: () => _showPropertyDetail(context, property),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 12,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Property image
                            Container(
                              height: 200,
                              width: double.infinity,
                              child: property.coverPhoto != null
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16),
                                      ),
                                      child: Image.network(
                                        property.coverPhoto!,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.photo_camera_outlined,
                                          size: 48,
                                          color: Colors.grey[400],
                                        ),
                                      ),
                                    ),
                            ),
                            
                            // Property details
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Title and category
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          property.title,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (property.categoryName != null)
                                        Container(
                                          margin: EdgeInsets.only(left: 8),
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFF5A5F).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            property.categoryName!,
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFFFF5A5F),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  SizedBox(height: 6),
                                  
                                  // Address
                                  Text(
                                    property.address,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey[600],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 12),
                                  
                                  // Property specs
                                  Row(
                                    children: [
                                      _buildSpecItem(Icons.bed_outlined, '${property.bedrooms}'),
                                      SizedBox(width: 16),
                                      _buildSpecItem(Icons.bathroom_outlined, '${property.bathrooms}'),
                                      SizedBox(width: 16),
                                      _buildSpecItem(Icons.people_outline, '${property.maxGuests}'),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  
                                  // Price and date
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rp ${_formatPrice(property.pricePerNight.toInt())}/malam',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Text(
                                        'Dibuat ${_formatDate(property.createdAt)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
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

  Widget _buildSpecItem(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: Colors.grey[600],
        ),
        SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
        'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'
      ];
      return '${date.day} ${months[date.month - 1]} ${date.year}';
    } catch (e) {
      return dateStr.split("T").first;
    }
  }
}