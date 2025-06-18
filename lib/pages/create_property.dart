import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class CreatePropertyPage extends StatefulWidget {
  final bool isEdit;
  final Map<String, dynamic>? initialData;

  CreatePropertyPage({this.isEdit = false, this.initialData});

  @override
  _CreatePropertyPageState createState() => _CreatePropertyPageState();
}

class _CreatePropertyPageState extends State<CreatePropertyPage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  List<File> _photos = [];

  // Form fields
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Ambil dari Kamera'),
                onTap: () async {
                  Navigator.pop(context);
                  final pickedFile = await picker.pickImage(source: ImageSource.camera);
                  if (pickedFile != null) {
                    setState(() {
                      _photos.add(File(pickedFile.path));
                    });
                  }
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Pilih dari Galeri'),
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
            ],
          ),
        );
      },
    );
  }

  Future<void> submitProperty() async {
    final propertyId = widget.initialData?['id_property'];
    final uri = widget.isEdit
        ? Uri.parse('https://yourapi.com/api/properties/$propertyId')
        : Uri.parse('https://yourapi.com/api/properties');

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
        SnackBar(content: Text(widget.isEdit ? 'Property berhasil disimpan' : 'Property berhasil dibuat')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal memproses property')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              buildTextField(latitudeController, 'Latitude', isNumber: true),
              buildTextField(longitudeController, 'Longitude', isNumber: true),
              buildTextField(bedroomsController, 'Bedrooms', isNumber: true),
              buildTextField(bathroomsController, 'Bathrooms', isNumber: true),
              buildTextField(maxGuestsController, 'Max Guests', isNumber: true),
              buildTextField(categoryIdController, 'Category ID', isNumber: true),
              SizedBox(height: 10),
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
}
