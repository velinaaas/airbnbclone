import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geocoding/geocoding.dart';

class CreatePropertyPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData;
  final dynamic existingProperty;

  const CreatePropertyPage({
    super.key,
    this.existingProperty,
    this.initialData,
    this.isEdit = false,
  });

  @override
  _CreatePropertyPageState createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  List<File> _photos = [];

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final addressController = TextEditingController();
  final latitudeController = TextEditingController();
  final longitudeController = TextEditingController();
  final bedroomsController = TextEditingController();
  final bathroomsController = TextEditingController();
  final maxGuestsController = TextEditingController();
  final categoryIdController = TextEditingController();

  bool _isSubmitting = false;

  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'label': 'Villa', 'icon': Icons.villa},
    {'id': 2, 'label': 'Apartemen', 'icon': Icons.apartment},
    {'id': 3, 'label': 'Kontrakan', 'icon': Icons.domain},
    {'id': 4, 'label': 'Homestay', 'icon': Icons.home},
    {'id': 5, 'label': 'Cottage', 'icon': Icons.cabin},
  ];

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.initialData != null) {
      titleController.text = widget.initialData!['title'] ?? '';
      descriptionController.text = widget.initialData!['description'] ?? '';
      priceController.text = widget.initialData!['price_per_night']?.toString() ?? '';
      addressController.text = widget.initialData!['address'] ?? '';
      latitudeController.text = widget.initialData!['latitude']?.toString() ?? '';
      longitudeController.text = widget.initialData!['longitude']?.toString() ?? '';
      bedroomsController.text = widget.initialData!['bedrooms']?.toString() ?? '';
      bathroomsController.text = widget.initialData!['bathrooms']?.toString() ?? '';
      maxGuestsController.text = widget.initialData!['max_guests']?.toString() ?? '';
      categoryIdController.text = widget.initialData!['category_id']?.toString() ?? '';
    }
  }

  Future<void> pickImages() async {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Text(
                      'Pilih Foto',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    _buildPhotoOption(
                      icon: Icons.camera_alt_outlined,
                      title: 'Ambil dari Kamera',
                      onTap: () async {
                        Navigator.pop(context);
                        final picked = await picker.pickImage(source: ImageSource.camera);
                        if (picked != null) {
                          setState(() {
                            _photos.add(File(picked.path));
                          });
                        }
                      },
                    ),
                    SizedBox(height: 16),
                    _buildPhotoOption(
                      icon: Icons.photo_library_outlined,
                      title: 'Pilih dari Galeri',
                      onTap: () async {
                        Navigator.pop(context);
                        final pickedFiles = await picker.pickMultiImage();
                        if (pickedFiles.isNotEmpty) {
                          setState(() {
                            _photos.addAll(pickedFiles.map((e) => File(e.path)));
                          });
                        }
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPhotoOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFF5A5F).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Color(0xFFFF5A5F)),
            ),
            SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        latitudeController.text = position.latitude.toString();
        longitudeController.text = position.longitude.toString();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lokasi berhasil ditemukan'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mendapatkan lokasi'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> updateLocationFromAddress() async {
    try {
      final address = addressController.text;
      if (address.isEmpty) return;

      List<Location> locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        final location = locations.first;
        setState(() {
          latitudeController.text = location.latitude.toString();
          longitudeController.text = location.longitude.toString();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Koordinat berhasil ditemukan'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menemukan lokasi dari alamat'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  Future<void> submitProperty() async {
    if (_isSubmitting) return;
    
    setState(() {
      _isSubmitting = true;
    });

    try {
      final propertyId = widget.initialData?['id_property'];
      final uri = widget.isEdit
          ? Uri.parse('https://apiairbnb-production.up.railway.app/api/properties/update/$propertyId')
          : Uri.parse('https://apiairbnb-production.up.railway.app/api/properties/add');

      var request = http.MultipartRequest(widget.isEdit ? 'PUT' : 'POST', uri);

      request.fields['title'] = titleController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['price_per_night'] = priceController.text;
      request.fields['address'] = addressController.text;
      request.fields['latitude'] = latitudeController.text;
      request.fields['longitude'] = longitudeController.text;
      request.fields['bedrooms'] = bedroomsController.text;
      request.fields['bathrooms'] = bathroomsController.text;
      request.fields['max_guests'] = maxGuestsController.text;
      request.fields['category_id'] = categoryIdController.text;

      if (!widget.isEdit) {
        for (var photo in _photos) {
          request.files.add(await http.MultipartFile.fromPath(
            'photos',
            photo.path,
            contentType: MediaType('image', 'jpeg'),
          ));
        }
      }

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');
      print('Token used: $token');

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.isEdit ? 'Properti berhasil diupdate' : 'Properti berhasil dibuat'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to submit property');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memproses property'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    bool isNumber = false,
    int maxLines = 1,
    IconData? prefixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 8),
          TextFormField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            maxLines: maxLines,
            decoration: InputDecoration(
              hintText: hint,
              prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: Colors.grey[600]) : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Color(0xFFFF5A5F), width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '$label tidak boleh kosong';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildCounterField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Color(0xFFFF5A5F).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFFFF5A5F), size: 20),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  int current = int.tryParse(controller.text) ?? 0;
                  if (current > 0) {
                    controller.text = (current - 1).toString();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.remove, size: 16),
                ),
              ),
              Container(
                width: 50,
                child: TextFormField(
                  controller: controller,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '';
                    }
                    return null;
                  },
                ),
              ),
              GestureDetector(
                onTap: () {
                  int current = int.tryParse(controller.text) ?? 0;
                  controller.text = (current + 1).toString();
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.add, size: 16),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    LatLng initialPosition = LatLng(
      double.tryParse(latitudeController.text) ?? -7.797068,
      double.tryParse(longitudeController.text) ?? 110.370529,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEdit ? 'Edit Properti' : 'Tambah Properti',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Basic Information Section
            _buildSectionTitle('Informasi Dasar'),
            _buildTextField(
              controller: titleController,
              label: 'Judul Properti',
              hint: 'Masukkan judul menarik untuk properti Anda',
              prefixIcon: Icons.home_outlined,
            ),
            _buildTextField(
              controller: descriptionController,
              label: 'Deskripsi',
              hint: 'Ceritakan tentang properti Anda',
              maxLines: 4,
              prefixIcon: Icons.description_outlined,
            ),
            _buildTextField(
              controller: priceController,
              label: 'Harga per Malam (Rp)',
              hint: '0',
              isNumber: true,
              prefixIcon: Icons.attach_money,
            ),

            // Category Section
            _buildSectionTitle('Kategori'),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: List.generate(categories.length, (index) {
                final cat = categories[index];
                final selected = categoryIdController.text == cat['id'].toString();
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      categoryIdController.text = cat['id'].toString();
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? Color(0xFFFF5A5F) : Colors.white,
                      border: Border.all(
                        color: selected ? Color(0xFFFF5A5F) : Colors.grey[300]!,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          cat['icon'],
                          size: 18,
                          color: selected ? Colors.white : Colors.grey[600],
                        ),
                        SizedBox(width: 8),
                        Text(
                          cat['label'],
                          style: TextStyle(
                            color: selected ? Colors.white : Colors.grey[700],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),

            // Location Section
            _buildSectionTitle('Lokasi'),
            _buildTextField(
              controller: addressController,
              label: 'Alamat Lengkap',
              hint: 'Masukkan alamat properti',
              prefixIcon: Icons.location_on_outlined,
            ),
            
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: updateLocationFromAddress,
                      icon: Icon(Icons.search, size: 18),
                      label: Text('Cari Lokasi'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.grey[700],
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: getCurrentLocation,
                      icon: Icon(Icons.my_location, size: 18),
                      label: Text('Lokasi Saya'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFF5A5F).withOpacity(0.1),
                        foregroundColor: Color(0xFFFF5A5F),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Map
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: FlutterMap(
                  options: MapOptions(
                    center: initialPosition,
                    zoom: 13.0,
                    onTap: (tapPosition, point) {
                      setState(() {
                        latitudeController.text = point.latitude.toString();
                        longitudeController.text = point.longitude.toString();
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(
                            double.tryParse(latitudeController.text) ?? -7.797,
                            double.tryParse(longitudeController.text) ?? 110.370,
                          ),
                          width: 40,
                          height: 40,
                          child: Icon(Icons.location_pin, color: Color(0xFFFF5A5F), size: 40),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Property Details Section
            _buildSectionTitle('Detail Properti'),
            _buildCounterField(
              controller: bedroomsController,
              label: 'Kamar Tidur',
              icon: Icons.bed_outlined,
            ),
            SizedBox(height: 16),
            _buildCounterField(
              controller: bathroomsController,
              label: 'Kamar Mandi',
              icon: Icons.bathroom_outlined,
            ),
            SizedBox(height: 16),
            _buildCounterField(
              controller: maxGuestsController,
              label: 'Maksimal Tamu',
              icon: Icons.people_outline,
            ),

            // Photos Section (only for new properties)
            if (!widget.isEdit) ...[
              _buildSectionTitle('Foto Properti'),
              GestureDetector(
                onTap: pickImages,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey[50],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFFF5A5F).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Icon(
                          Icons.add_photo_alternate_outlined,
                          size: 32,
                          color: Color(0xFFFF5A5F),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Tambah Foto',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '${_photos.length} foto dipilih',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_photos.isNotEmpty) ...[
                SizedBox(height: 16),
                Container(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: 12),
                        child: Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(_photos[index]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 8,
                              right: 8,
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _photos.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ] else ...[
              _buildSectionTitle('Foto Properti'),
              Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.orange[600]),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Foto tidak dapat diubah saat mengedit properti.',
                        style: TextStyle(
                          color: Colors.orange[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: 32),
            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _isSubmitting
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          submitProperty();
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFFF5A5F),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        widget.isEdit ? 'Simpan Perubahan' : 'Buat Properti',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}