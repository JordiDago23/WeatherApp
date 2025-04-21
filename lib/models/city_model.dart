class City {
  final String name;

  City({required this.name});

  // Método para crear un objeto City desde JSON
  factory City.fromJson(Map<String, dynamic> json) {
    return City(name: json['name']);
  }

  // Método para convertir un objeto City a JSON
  Map<String, dynamic> toJson() {
    return {'name': name};
  }
}
