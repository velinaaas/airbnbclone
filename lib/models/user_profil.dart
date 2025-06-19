class UserProfile {
  final String name;
  final String role;
  final String? image;

  UserProfile({
    required this.name,
    required this.role,
    this.image,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      image: json['image'], // jika ada field foto
    );
  }
}
