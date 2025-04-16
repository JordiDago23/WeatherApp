class WeatherAlert {
  final String description;
  final String event;
  final String startTime;
  final String endTime;

  WeatherAlert({
    required this.description,
    required this.event,
    required this.startTime,
    required this.endTime,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      description: json['description'] ?? '',
      event: json['event'] ?? '',
      startTime:
          json['start'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                json['start'] * 1000,
              ).toString()
              : '',
      endTime:
          json['end'] != null
              ? DateTime.fromMillisecondsSinceEpoch(
                json['end'] * 1000,
              ).toString()
              : '',
    );
  }

  // Crear alerta de prueba para testeo
  static WeatherAlert createTestAlert() {
    return WeatherAlert(
      description:
          'Esta es una alerta meteorológica de prueba. Se está simulando una situación de emergencia para fines de testeo de la aplicación. En caso de una alerta real, siga las instrucciones de las autoridades locales.',
      event: 'ALERTA DE PRUEBA',
      startTime: DateTime.now().toString(),
      endTime: 'Hasta nuevo aviso',
    );
  }
}
