class CiudadSugerida {
  final String nombre;
  final String pais;
  final String estado;
  final double latitud;
  final double longitud;

  CiudadSugerida({
    required this.nombre,
    required this.pais,
    required this.estado,
    required this.latitud,
    required this.longitud,
  });

  factory CiudadSugerida.fromJson(Map<String, dynamic> json) {
    return CiudadSugerida(
      nombre: json['name'] ?? '',
      pais: json['country'] ?? '',
      estado: json['state'] ?? '',
      latitud: (json['lat'] as num).toDouble(),
      longitud: (json['lon'] as num).toDouble(),
    );
  }

  String get nombreCompleto {
    if (estado.isNotEmpty) {
      return '$nombre, $estado, $pais';
    }
    return '$nombre, $pais';
  }
}
