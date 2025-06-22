import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

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

  final List<Map<String, dynamic>> categories = [
    {'id': 1, 'label': 'Villa', 'icon': Icons.house},
    {'id': 2, 'label': 'Apartemen', 'icon': Icons.apartment},
    {'id': 3, 'label': 'Rumah', 'icon': Icons.home},
    {'id': 4, 'label': 'Kontrakan', 'icon': Icons.domain},
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
    final pickedFiles = await picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      setState(() {
        _photos.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }

  Future<void> getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      latitudeController.text = position.latitude.toString();
      longitudeController.text = position.longitude.toString();
    });
  }

  Future<void> submitProperty() async {
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

    for (var photo in _photos) {
      request.files.add(await http.MultipartFile.fromPath(
        'photos',
        photo.path,
        contentType: MediaType('image', 'jpeg'),
      ));
    }

    final response = await request.send();
    if (response.statusCode == 200 || response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.isEdit ? 'Property berhasil diupdate' : 'Property berhasil dibuat')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses property')),
      );
    }
  }

  Widget buildTextField(TextEditingController controller, String label, {bool isNumber = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label tidak boleh kosong';
          }
          return null;
        },
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
      appBar: AppBar(title: Text(widget.isEdit ? 'Edit Property' : 'Create Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField(titleController, 'Title'),
              buildTextField(descriptionController, 'Description'),
              buildTextField(priceController, 'Price per Night', isNumber: true),
              buildTextField(addressController, 'Address'),
              Text('Pilih Lokasi:', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 250,
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
                  children: [ // ✅ Gunakan children, bukan builder
                    TileLayer(
                      urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                      subdomains: ['a', 'b', 'c'],
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
                        child: Icon(Icons.location_pin, color: Colors.red, size: 40),
                      ),
                      ],
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                icon: Icon(Icons.my_location),
                label: Text('Gunakan Lokasi Saya'),
                onPressed: getCurrentLocation,
              ),
              buildTextField(latitudeController, 'Latitude', isNumber: true),
              buildTextField(longitudeController, 'Longitude', isNumber: true),
              buildTextField(bedroomsController, 'Bedrooms', isNumber: true),
              buildTextField(bathroomsController, 'Bathrooms', isNumber: true),
              buildTextField(maxGuestsController, 'Max Guests', isNumber: true),
              SizedBox(height: 16),
              Text('Kategori', style: TextStyle(fontWeight: FontWeight.bold)),
              Wrap(
                spacing: 10,
                children: List.generate(categories.length, (index) {
                  final cat = categories[index];
                  final selected = categoryIdController.text == cat['id'].toString();
                  return ChoiceChip(
                    label: Text(cat['label']),
                    avatar: Icon(cat['icon'], size: 20),
                    selected: selected,
                    onSelected: (_) {
                      setState(() {
                        categoryIdController.text = cat['id'].toString();
                      });
                    },
                  );
                }),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: pickImages,
                child: Text('Pilih Foto (${_photos.length})'),
              ),
              if (_photos.isNotEmpty)
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _photos.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(8),
                            width: 100,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: FileImage(_photos[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _photos.removeAt(index);
                                });
                              },
                              child: CircleAvatar(
                                radius: 12,
                                backgroundColor: Colors.red,
                                child: Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    submitProperty();
                  }
                },
                child: Text(widget.isEdit ? 'Simpan' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
