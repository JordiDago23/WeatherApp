class Pronostico {
  final DateTime fecha;
  final double temperatura;
  final String descripcion;
  final String icono;
  final double temperaturaMinima;
  final double temperaturaMaxima;
  final int humedad;
  final double velocidadViento;

  Pronostico({
    required this.fecha,
    required this.temperatura,
    required this.descripcion,
    required this.icono,
    required this.temperaturaMinima,
    required this.temperaturaMaxima,
    required this.humedad,
    required this.velocidadViento,
  });

  factory Pronostico.fromJson(Map<String, dynamic> json) {
    return Pronostico(
      fecha: DateTime.parse(json['dt_txt']),
      temperatura: json['main']['temp'].toDouble(),
      descripcion: json['weather'][0]['description'],
      icono: json['weather'][0]['icon'],
      temperaturaMinima: json['main']['temp_min'].toDouble(),
      temperaturaMaxima: json['main']['temp_max'].toDouble(),
      humedad: json['main']['humidity'],
      velocidadViento: json['wind']['speed'].toDouble(),
    );
  }

  factory Pronostico.fromDailyForecasts(List<Map<String, dynamic>> forecasts) {
    double tempMin = double.infinity;
    double tempMax = double.negativeInfinity;
    double tempPromedio = 0;
    String descripcion = '';
    String icono = '';
    int humedad = 0;
    double velocidadViento = 0;

    for (var forecast in forecasts) {
      double temp = forecast['main']['temp'].toDouble();
      if (temp < tempMin) {
        tempMin = temp;
      }
      if (temp > tempMax) {
        tempMax = temp;
      }
      tempPromedio += temp;
      descripcion = forecast['weather'][0]['description'];
      icono = forecast['weather'][0]['icon'];
      humedad = forecast['main']['humidity'];
      velocidadViento = forecast['wind']['speed'].toDouble();
    }

    tempPromedio /= forecasts.length;

    return Pronostico(
      fecha: DateTime.parse(forecasts[0]['dt_txt']),
      temperatura: tempPromedio,
      descripcion: descripcion,
      icono: icono,
      temperaturaMinima: tempMin,
      temperaturaMaxima: tempMax,
      humedad: humedad,
      velocidadViento: velocidadViento,
    );
  }
}
