import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  // Convertir fecha en formato legible
  static String formatDate(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('EEEE, d MMM', 'es').format(dateTime);
  }

  // Convertir fecha corta
  static String formatShortDate(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('E, d', 'es').format(dateTime);
  }

  // Obtener hora del día
  static String formatHour(String dateTimeStr) {
    final dateTime = DateTime.parse(dateTimeStr);
    return DateFormat('HH:mm').format(dateTime);
  }

  // Obtener icono del clima
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.grain;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
      case 'haze':
        return Icons.cloud;
      default:
        return Icons.cloud;
    }
  }

  // Obtener color basado en temperatura
  static Color getTemperatureColor(double temperature) {
    if (temperature > 30) {
      return Colors.red;
    } else if (temperature > 20) {
      return Colors.orange;
    } else if (temperature > 10) {
      return Colors.yellow.shade700;
    } else if (temperature > 0) {
      return Colors.blue;
    } else {
      return Colors.indigo;
    }
  }

  // Obtener URL del icono de OpenWeatherMap
  static String getWeatherIconUrl(String iconCode) {
    return 'https://openweathermap.org/img/wn/$iconCode@2x.png';
  }

  // Obtener descripción en español para la condición del clima
  static String getWeatherDescription(String condition) {
    Map<String, String> descriptions = {
      'clear': 'Despejado',
      'clouds': 'Nublado',
      'rain': 'Lluvia',
      'drizzle': 'Llovizna',
      'thunderstorm': 'Tormenta',
      'snow': 'Nieve',
      'mist': 'Neblina',
      'fog': 'Niebla',
      'haze': 'Bruma',
    };

    return descriptions[condition.toLowerCase()] ?? 'Desconocido';
  }
}
