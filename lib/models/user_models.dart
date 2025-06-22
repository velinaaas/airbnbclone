class User {
  final int id;
  final String name;
  final String email;
  final String phone_number;
  final List<String> roles;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone_number,
    required this.roles,
  });

    factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone_number: json['phone'] ?? '',
      roles: List<String>.from(json['roles'] ?? []),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone_number,
      'roles': roles,
    };
  }
}
