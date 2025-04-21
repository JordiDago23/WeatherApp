class Ciudad {
  final String nombre;

  Ciudad({required this.nombre});

  factory Ciudad.fromJson(Map<String, dynamic> json) {
    return Ciudad(nombre: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'name': nombre};
  }
}
