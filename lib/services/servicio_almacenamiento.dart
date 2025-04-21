import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_jml/models/ciudad_model.dart';

class ServicioAlmacenamiento {
  static const String _ciudadesRecientesKey = 'recent_cities';

  Future<void> addRecentCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<Ciudad> ciudades = await getRecentCities();

    if (!ciudades.any((ciudad) => ciudad.nombre == cityName)) {
      ciudades.add(Ciudad(nombre: cityName));

      if (ciudades.length > 5) {
        ciudades.removeAt(0);
      }

      List<String> citiesJson =
          ciudades.map((ciudad) => jsonEncode(ciudad.toJson())).toList();
      await prefs.setStringList(_ciudadesRecientesKey, citiesJson);
    }
  }

  Future<List<Ciudad>> getRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? citiesJson = prefs.getStringList(_ciudadesRecientesKey);

    if (citiesJson == null || citiesJson.isEmpty) {
      return [];
    }

    return citiesJson.map((json) => Ciudad.fromJson(jsonDecode(json))).toList();
  }
}
