import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weather_app_jml/models/city_model.dart';

class StorageService {
  static const String _recentCitiesKey = 'recent_cities';

  Future<void> addRecentCity(String cityName) async {
    final prefs = await SharedPreferences.getInstance();
    List<City> cities = await getRecentCities();

    if (!cities.any((city) => city.name == cityName)) {
      cities.add(City(name: cityName));

      if (cities.length > 5) {
        cities.removeAt(0);
      }

      List<String> citiesJson =
          cities.map((city) => jsonEncode(city.toJson())).toList();
      await prefs.setStringList(_recentCitiesKey, citiesJson);
    }
  }

  Future<List<City>> getRecentCities() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? citiesJson = prefs.getStringList(_recentCitiesKey);

    if (citiesJson == null || citiesJson.isEmpty) {
      return [];
    }

    return citiesJson.map((json) => City.fromJson(jsonDecode(json))).toList();
  }
}
