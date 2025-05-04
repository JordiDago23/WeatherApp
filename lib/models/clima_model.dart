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
}
