class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final List<String> roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roles,
  });

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'roles': roles,
    };
  }
}
