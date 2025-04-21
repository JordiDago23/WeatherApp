class WeatherAlert {
  final String event;
  final String description;
  final DateTime start;
  final DateTime end;

  WeatherAlert({
    required this.event,
    required this.description,
    required this.start,
    required this.end,
  });

  factory WeatherAlert.fromJson(Map<String, dynamic> json) {
    return WeatherAlert(
      event: json['event'],
      description: json['description'],
      start: DateTime.fromMillisecondsSinceEpoch(json['start'] * 1000),
      end: DateTime.fromMillisecondsSinceEpoch(json['end'] * 1000),
    );
  }

  static WeatherAlert createTestAlert() {
    return WeatherAlert(
      event: 'Alerta de lluvia',
      description: 'Se esperan lluvias intensas en las próximas horas',
      start: DateTime.now(),
      end: DateTime.now().add(const Duration(hours: 6)),
    );
  }
}
