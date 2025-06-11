class Property {
  final String title;
  final String type;
  final String location;

  Property({required this.title, required this.type, required this.location});
}

List<Property> dummyProperties = [
  Property(title: "Villa Mawar", type: "Rumah", location: "Bali"),
  Property(title: "Apartemen Cendana", type: "Apartemen", location: "Jakarta"),
];
