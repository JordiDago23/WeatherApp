import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_jml/models/ciudad_model.dart';

class SharedPreferencesService {
  static const String _ciudadesRecientesKey = 'recent_cities';

  Future<void> addCiudadesRecientes(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<Ciudad> ciudades = await getCiudadesRecientes();

    ciudades.removeWhere((ciudad) => ciudad.nombre == cityName);
    ciudades.insert(0, Ciudad(nombre: cityName));

    if (ciudades.length > 5) {
      ciudades = ciudades.sublist(0, 5);
    }

    List<String> citiesJson =
        ciudades.map((ciudad) => jsonEncode(ciudad.toJson())).toList();
    await prefs.setStringList(_ciudadesRecientesKey, citiesJson);
  }

  Future<List<Ciudad>> getCiudadesRecientes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? citiesJson = prefs.getStringList(_ciudadesRecientesKey);

    if (citiesJson == null || citiesJson.isEmpty) {
      return [];
    }

    return citiesJson.map((json) => Ciudad.fromJson(jsonDecode(json))).toList();
  }
}
