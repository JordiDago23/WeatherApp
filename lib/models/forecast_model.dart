class Forecast {
  final String dateTime;
  final double temperature;
  final String mainCondition;
  final String icon;

  Forecast({
    required this.dateTime,
    required this.temperature,
    required this.mainCondition,
    required this.icon,
  });

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      dateTime: json['dt_txt'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      icon: json['weather'][0]['icon'],
    );
  }
}
