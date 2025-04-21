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

  static List<AlertaMetereologica> crearAlertasPrueba() {
    return [
      AlertaMetereologica(
        evento: 'Alerta de lluvia',
        descripcion:
            'Se esperan lluvias intensas en las próximas horas con posibilidad de inundaciones en zonas bajas.',
        inicio: DateTime.now().toString(),
        fin: DateTime.now().add(const Duration(hours: 6)).toString(),
        remitente: 'Servicio Meteorológico Nacional',
        tipo: 'Lluvia',
      ),
      AlertaMetereologica(
        evento: 'Alerta de viento',
        descripcion:
            'Rachas de viento que podrían alcanzar los 80 km/h. Se recomienda asegurar objetos que puedan ser arrastrados por el viento.',
        inicio: DateTime.now().add(const Duration(hours: 2)).toString(),
        fin: DateTime.now().add(const Duration(hours: 12)).toString(),
        remitente: 'Protección Civil',
        tipo: 'Viento',
      ),
      AlertaMetereologica(
        evento: 'Alerta de tormenta eléctrica',
        descripcion:
            'Se esperan tormentas eléctricas intensas. Evite estar en espacios abiertos y cerca de árboles o estructuras metálicas.',
        inicio: DateTime.now().add(const Duration(hours: 4)).toString(),
        fin: DateTime.now().add(const Duration(hours: 8)).toString(),
        remitente: 'Centro de Prevención de Desastres',
        tipo: 'Tormenta',
      ),
      AlertaMetereologica(
        evento: 'Ola de calor',
        descripcion:
            'Temperaturas superiores a 35°C durante los próximos días. Manténgase hidratado y evite la exposición prolongada al sol.',
        inicio: DateTime.now().toString(),
        fin: DateTime.now().add(const Duration(days: 3)).toString(),
        remitente: 'Instituto Meteorológico',
        tipo: 'Calor',
      ),
    ];
  }
}
