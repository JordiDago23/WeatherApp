class Forecast {
  final DateTime date;
  final double temperature;
  final String description;
  final String icon;

  Forecast({
    required this.date,
    required this.temperature,
    required this.description,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      date: DateTime.parse(json['dt_txt']),
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      icon: json['weather'][0]['icon'],
    );
  }
}
