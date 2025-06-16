class Category {
  final int id;
  final String name;
  final String slug;
  final String iconUrl;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.iconUrl,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id_category'],
      name: json['name'],
      slug: json['slug'],
      iconUrl: json['icon_url'],
    );
  }
}
