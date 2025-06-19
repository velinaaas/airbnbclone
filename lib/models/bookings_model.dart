class Booking {
  final int id;
  final DateTime startDate;
  final DateTime endDate;
  final String totalPrice;
  final String status;
  final Property property;
  final dynamic payment;

  Booking({
    required this.id,
    required this.startDate,
    required this.endDate,
    required this.totalPrice,
    required this.status,
    required this.property,
    this.payment,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'],
      startDate: DateTime.parse(json['start_date']),
      endDate: DateTime.parse(json['end_date']),
      totalPrice: json['total_price'],
      status: json['status'],
      property: Property.fromJson(json['property']),
      payment: json['payment'],
    );
  }
}

class Property {
  final int id;
  final String title;
  final String address;
  final String coverImage;

  Property({
    required this.id,
    required this.title,
    required this.address,
    required this.coverImage,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      id: json['id'],
      title: json['title'] ?? 'Tanpa Judul',
      address: json['address'] ?? 'Tanpa Alamat',
      coverImage: json['cover_image'] ?? 'https://via.placeholder.com/300',
    );
  }
}
