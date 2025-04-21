import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_jml/models/weather_model.dart';
import 'package:weather_app_jml/models/forecast_model.dart';
import 'package:weather_app_jml/models/alert_model.dart';
import 'package:flutter/foundation.dart';

class ApiOpenWeatherMap {
  static final String _apiKey = dotenv.env['OPENWEATHERAPIKEY'] ?? '';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> getWeatherAndForecastByCity(String city) async {
    final forecastResponse = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?q=$city&units=metric&appid=$_apiKey&lang=es',
      ),
    );

    if (forecastResponse.statusCode == 200) {
      final forecastData = jsonDecode(forecastResponse.body);
      final List<dynamic> forecastList = forecastData['list'];
      final Map<String, dynamic> cityData = forecastData['city'];

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

      final firstForecastData = forecastList[0];

      final currentWeather = Weather(
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

      return {'weather': currentWeather, 'forecasts': forecasts};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${forecastResponse.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> getWeatherAndForecastByLocation(
    double latitude,
    double longitude,
  ) async {
    final forecastResponse = await http.get(
      Uri.parse(
        '$_baseUrl/forecast?lat=$latitude&lon=$longitude&units=metric&appid=$_apiKey&lang=es',
      ),
    );

    if (forecastResponse.statusCode == 200) {
      final forecastData = jsonDecode(forecastResponse.body);
      final List<dynamic> forecastList = forecastData['list'];
      final Map<String, dynamic> cityData = forecastData['city'];

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

      final firstForecastData = forecastList[0];

      final currentWeather = Weather(
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

      return {'weather': currentWeather, 'forecasts': forecasts};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${forecastResponse.statusCode}',
      );
    }
  }

  Future<List<WeatherAlert>> getWeatherAlerts(
    double latitude,
    double longitude,
  ) async {
    final response = await http.get(
      Uri.parse(
        'https://api.openweathermap.org/data/3.0/onecall?lat=$latitude&lon=$longitude&exclude=current,minutely,hourly,daily&appid=$_apiKey&lang=es',
      ),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      List<WeatherAlert> alerts = [];

      if (jsonData.containsKey('alerts')) {
        final List<dynamic> alertsList = jsonData['alerts'];
        for (var alert in alertsList) {
          alerts.add(WeatherAlert.fromJson(alert));
        }
      }

      return alerts;
    } else if (response.statusCode == 401) {
      debugPrint(
        'Error de autenticación (401) en la API One Call. Devolviendo lista vacía de alertas.',
      );
      return [];
    } else {
      debugPrint(
        'Error al obtener alertas: ${response.statusCode}. Devolviendo lista vacía.',
      );
      return [];
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Los servicios de ubicación están desactivados');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Los permisos de ubicación están permanentemente denegados',
      );
    }

    return await Geolocator.getCurrentPosition();
  }
}
