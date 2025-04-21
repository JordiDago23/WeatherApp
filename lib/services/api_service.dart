import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/alert_model.dart';

class ApiService {
  // Obtener la clave API desde el archivo .env
  static final String _apiKey = dotenv.env['OPENWEATHERAPIKEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Método unificado para obtener clima y pronóstico por ciudad
  Future<Map<String, dynamic>> getWeatherAndForecastByCity(String city) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?q=$city&units=metric&appid=$_apiKey&lang=es',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      final Map<String, dynamic> cityData = data['city'];

      // Obtener pronóstico para 5 días
      List<Forecast> forecasts = [];
      String currentDate = "";

      for (var item in forecastList) {
        String date = item['dt_txt'].toString().split(' ')[0];
        if (date != currentDate) {
          currentDate = date;
          forecasts.add(Forecast.fromJson(item));
        }
        if (forecasts.length >= 5) break;
      }

      // Crear objeto Weather con datos del primer pronóstico
      final firstForecastData = forecastList[0];
      final weather = Weather(
        cityName: cityData['name'],
        temperature: firstForecastData['main']['temp'].toDouble(),
        description: firstForecastData['weather'][0]['description'],
        tempMin: firstForecastData['main']['temp_min'].toDouble(),
        tempMax: firstForecastData['main']['temp_max'].toDouble(),
        humidity: firstForecastData['main']['humidity'],
        windSpeed: firstForecastData['wind']['speed'].toDouble(),
        icon: firstForecastData['weather'][0]['icon'],
        date: DateTime.parse(firstForecastData['dt_txt']),
      );

      return {'weather': weather, 'forecasts': forecasts};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${response.statusCode}',
      );
    }
  }

  // Método unificado para obtener clima y pronóstico por ubicación
  Future<Map<String, dynamic>> getWeatherAndForecastByLocation(
    double lat,
    double lon,
  ) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$_apiKey&lang=es',
      ),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List<dynamic> forecastList = data['list'];
      final Map<String, dynamic> cityData = data['city'];

      // Obtener pronóstico para 5 días
      List<Forecast> forecasts = [];
      String currentDate = "";

      for (var item in forecastList) {
        String date = item['dt_txt'].toString().split(' ')[0];
        if (date != currentDate) {
          currentDate = date;
          forecasts.add(Forecast.fromJson(item));
        }
        if (forecasts.length >= 5) break;
      }

      // Crear objeto Weather con datos del primer pronóstico
      final firstForecastData = forecastList[0];
      final weather = Weather(
        cityName: cityData['name'],
        temperature: firstForecastData['main']['temp'].toDouble(),
        description: firstForecastData['weather'][0]['description'],
        tempMin: firstForecastData['main']['temp_min'].toDouble(),
        tempMax: firstForecastData['main']['temp_max'].toDouble(),
        humidity: firstForecastData['main']['humidity'],
        windSpeed: firstForecastData['wind']['speed'].toDouble(),
        icon: firstForecastData['weather'][0]['icon'],
        date: DateTime.parse(firstForecastData['dt_txt']),
      );

      return {'weather': weather, 'forecasts': forecasts};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${response.statusCode}',
      );
    }
  }

  // Los métodos separados para compatibilidad
  Future<Weather> getWeatherByCity(String city) async {
    final result = await getWeatherAndForecastByCity(city);
    return result['weather'];
  }

  Future<List<Forecast>> getForecastByCity(String city) async {
    final result = await getWeatherAndForecastByCity(city);
    return result['forecasts'];
  }

  Future<Weather> getWeatherByLocation(double lat, double lon) async {
    final result = await getWeatherAndForecastByLocation(lat, lon);
    return result['weather'];
  }

  Future<List<Forecast>> getForecastByLocation(double lat, double lon) async {
    final result = await getWeatherAndForecastByLocation(lat, lon);
    return result['forecasts'];
  }

  // Obtener alertas meteorológicas
  Future<List<WeatherAlert>> getWeatherAlerts(double lat, double lon) async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/3.0/onecall?lat=$lat&lon=$lon&exclude=current,minutely,hourly,daily&appid=$_apiKey&lang=es',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        List<WeatherAlert> alerts = [];

        if (data.containsKey('alerts')) {
          final List<dynamic> alertsList = data['alerts'];
          for (var alert in alertsList) {
            alerts.add(WeatherAlert.fromJson(alert));
          }
        }

        return alerts;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  // Obtener ubicación actual
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Servicios de ubicación desactivados');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permisos de ubicación denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permisos de ubicación permanentemente denegados');
    }

    return await Geolocator.getCurrentPosition();
  }
}
