class Pronostico {
  final DateTime fecha;
  final double temperatura;
  final String descripcion;
  final String icono;

  Pronostico({
    required this.fecha,
    required this.temperatura,
    required this.descripcion,
    required this.icono,
  });

  factory Pronostico.fromJson(Map<String, dynamic> json) {
    return Pronostico(
      fecha: DateTime.parse(json['dt_txt']),
      temperatura: json['main']['temp'].toDouble(),
      descripcion: json['weather'][0]['description'],
      icono: json['weather'][0]['icon'],
    );
  }
}
