import 'package:airbnbclone/models/category.dart';

class Property {
  final int idProperty;
  final int userId;
  final String title;
  final String description;
  final double pricePerNight;
  final String address;
  final double latitude;
  final double longitude;
  final int bedrooms;
  final int bathrooms;
  final int maxGuests;
  final bool isActive;
  final String createdAt;
  final String updatedAt;
  final Category? category;
  
  // Tambahan dari join
  final String? coverPhoto;
  final double? averageRating;

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
    this.coverPhoto,
    this.averageRating,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      idProperty: json['id_property'] ?? 0,
      userId: json['user_id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      pricePerNight: double.tryParse(json['price_per_night'].toString()) ?? 0.0,
      address: json['address'] ?? '',
      latitude: double.tryParse(json['latitude'].toString()) ?? 0.0,
      longitude: double.tryParse(json['longitude'].toString()) ?? 0.0,
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      maxGuests: json['max_guests'] ?? 0,
      isActive: json['is_active'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      category: (json['category'] != null && json['category'] is Map)
          ? Category.fromJson(json['category'])
          : null,
      coverPhoto: json['cover_photo'],
      averageRating: double.tryParse(json['average_rating']?.toString() ?? '0.0'),
    );
  }
}
