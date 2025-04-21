class AlertaMetereologica {
  final String evento;
  final String descripcion;
  final String inicio;
  final String fin;
  final String remitente;
  final String tipo;

  AlertaMetereologica({
    required this.evento,
    required this.descripcion,
    required this.inicio,
    required this.fin,
    required this.remitente,
    required this.tipo,
  });

  factory AlertaMetereologica.fromJson(Map<String, dynamic> json) {
    return AlertaMetereologica(
      evento: json['event'] ?? 'Desconocido',
      descripcion: json['description'] ?? 'Sin descripción',
      inicio: json['start']?.toString() ?? 'Desconocido',
      fin: json['end']?.toString() ?? 'Desconocido',
      remitente: json['sender_name'] ?? 'Desconocido',
      tipo: json['tags']?.isNotEmpty == true ? json['tags'][0] : 'Otro',
    );
  }

  static AlertaMetereologica crearAlertaPrueba() {
    return AlertaMetereologica(
      evento: 'Alerta de lluvia',
      descripcion: 'Se esperan lluvias intensas en las próximas horas',
      inicio: DateTime.now().toString(),
      fin: DateTime.now().add(const Duration(hours: 6)).toString(),
      remitente: 'Servicio Meteorológico',
      tipo: 'Lluvia',
    );
  }
}
