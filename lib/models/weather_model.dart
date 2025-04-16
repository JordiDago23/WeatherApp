class Weather {
  final String cityName;
  final double temperature;
  final String mainCondition;
  final String description;
  final double feelsLike;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String icon;
  final DateTime date;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.mainCondition,
    required this.description,
    required this.feelsLike,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      feelsLike: json['main']['feels_like'].toDouble(),
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      icon: json['weather'][0]['icon'],
      date: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
    );
  }
}
