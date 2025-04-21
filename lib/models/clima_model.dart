class Clima {
  final String nombreCiudad;
  final double temperatura;
  final String descripcion;
  final double temperaturaMinima;
  final double temperaturaMaxima;
  final int humedad;
  final double velocidadViento;
  final String icono;
  final DateTime fecha;

  Clima({
    required this.nombreCiudad,
    required this.temperatura,
    required this.descripcion,
    required this.temperaturaMinima,
    required this.temperaturaMaxima,
    required this.humedad,
    required this.velocidadViento,
    required this.icono,
    required this.fecha,
  });

  factory Clima.fromJson(Map<String, dynamic> json) {
    return Clima(
      nombreCiudad: json['name'],
      temperatura: json['main']['temp'].toDouble(),
      descripcion: json['weather'][0]['description'],
      temperaturaMinima: json['main']['temp_min'].toDouble(),
      temperaturaMaxima: json['main']['temp_max'].toDouble(),
      humedad: json['main']['humidity'],
      velocidadViento: json['wind']['speed'].toDouble(),
      icono: json['weather'][0]['icon'],
      fecha: DateTime.now(),
    );
  }
}
