class City {
  final String name;
  final DateTime lastSearched;

  City({required this.name, required this.lastSearched});

  Map<String, dynamic> toJson() {
    return {'name': name, 'lastSearched': lastSearched.toIso8601String()};
  }

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      name: json['name'],
      lastSearched: DateTime.parse(json['lastSearched']),
    );
  }
}
