import 'category.dart';

class Property {
  final int idProperty;
  final int userId;
  final String title;
  final String description;
  final int pricePerNight;
  final String address;
  final double latitude;
  final double longitude;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Category? category; // ubah jadi nullable

  Property({
    required this.idProperty,
    required this.userId,
    required this.title,
    required this.description,
    required this.pricePerNight,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.bedrooms,
    required this.bathrooms,
    required this.maxGuests,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.category,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      idProperty: json['id_property'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pricePerNight: json['price_per_night'] ?? 0,
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      maxGuests: json['max_guests'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['update_at'] ?? '',
      category: json['category'] != null
          ? Category.fromJson(json['category'])
          : null,
    );
  }
}
