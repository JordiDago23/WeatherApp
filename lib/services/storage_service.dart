import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/city_model.dart';

class StorageService {
  static const String recentCitiesKey = 'recentCities';

  // Guardar lista de ciudades recientes
  Future<void> saveRecentCities(List<City> cities) async {
    final prefs = await SharedPreferences.getInstance();

    // Convertir la lista de ciudades a una lista de JSON
    final List<String> citiesJson =
        cities.map((city) => jsonEncode(city.toJson())).toList();

    await prefs.setStringList(recentCitiesKey, citiesJson);
  }

  // Obtener lista de ciudades recientes
  Future<List<City>> getRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> citiesJson = prefs.getStringList(recentCitiesKey) ?? [];

    // Convertir la lista de JSON a una lista de ciudades
    return citiesJson.map((json) => City.fromJson(jsonDecode(json))).toList();
  }

  // Agregar una ciudad a la lista de recientes
  Future<void> addRecentCity(String cityName) async {
    final cities = await getRecentCities();

    // Verificar si la ciudad ya existe
    final existingIndex = cities.indexWhere((city) => city.name == cityName);

    if (existingIndex >= 0) {
      // Si existe, actualizar la fecha
      cities.removeAt(existingIndex);
    }

    // Agregar la ciudad al inicio de la lista
    cities.insert(0, City(name: cityName, lastSearched: DateTime.now()));

    // Limitar a 5 ciudades
    if (cities.length > 5) {
      cities.removeLast();
    }

    // Guardar la lista actualizada
    await saveRecentCities(cities);
  }

  // Limpiar ciudades recientes
  Future<void> clearRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(recentCitiesKey);
  }
}
