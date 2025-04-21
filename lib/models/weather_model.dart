class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final double tempMin;
  final double tempMax;
  final int humidity;
  final double windSpeed;
  final String icon;
  final DateTime date;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.tempMin,
    required this.tempMax,
    required this.humidity,
    required this.windSpeed,
    required this.icon,
    required this.date,
  });

  // Método para crear un objeto Weather desde JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      description: json['weather'][0]['description'],
      tempMin: json['main']['temp_min'].toDouble(),
      tempMax: json['main']['temp_max'].toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      icon: json['weather'][0]['icon'],
      date: DateTime.now(),
    );
  }
}
