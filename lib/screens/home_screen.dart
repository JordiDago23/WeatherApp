import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/alert_model.dart';
import '../models/city_model.dart';
import '../services/api_open_weather_map.dart';
import '../services/storage_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/forecast_card.dart';
import '../widgets/weather_alerts.dart';
import '../widgets/city_search.dart';
import '../screens/alert_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiOpenWeatherMap _apiService = ApiOpenWeatherMap();
  final StorageService _storageService = StorageService();
  Weather? _currentWeather;
  List<Forecast> _forecasts = [];
  List<WeatherAlert> _alerts = [];
  List<City> _recentCities = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadRecentCities();
    _getCurrentLocationWeather();
  }

  // Mostrar alerta de prueba
  void _showTestAlert() {
    // Crear una alerta de prueba
    final testAlert = WeatherAlert.createTestAlert();

    // Navegar a la pantalla de alerta
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AlertScreen(
              alert: testAlert,
              onClose: () {
                // Cerrar la pantalla de alerta
                Navigator.of(context).pop();
                // Mostrar un Snackbar indicando que la alerta ha sido cerrada
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Alerta cerrada'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
      ),
    );
  }

  // Cargar ciudades recientes
  Future<void> _loadRecentCities() async {
    try {
      final cities = await _storageService.getRecentCities();
      setState(() {
        _recentCities = cities;
      });
    } catch (e) {
      // Si hay error al cargar, iniciamos con lista vacía
      setState(() {
        _recentCities = [];
      });
    }
  }

  // Obtener clima por ubicación actual
  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Obtener la ubicación actual
      final position = await _apiService.getCurrentLocation();

      // Usar el nuevo método que asegura consistencia de datos
      final weatherData = await _apiService.getWeatherAndForecastByLocation(
        position.latitude,
        position.longitude,
      );

      // Obtener el clima y pronósticos del resultado
      final weather = weatherData['weather'];
      final forecasts = weatherData['forecasts'];

      // Obtener las alertas
      final alerts = await _apiService.getWeatherAlerts(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _currentWeather = weather;
        _forecasts = forecasts;
        _alerts = alerts;
        _isLoading = false;
      });

      // Guardar la ciudad actual en recientes
      await _storageService.addRecentCity(weather.cityName);
      await _loadRecentCities(); // Recargar la lista
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _isLoading = false;
      });
    }
  }

  // Obtener clima por ciudad
  Future<void> _getCityWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      // Usar el nuevo método que asegura consistencia de datos
      final weatherData = await _apiService.getWeatherAndForecastByCity(city);

      // Obtener el clima y pronósticos del resultado
      final weather = weatherData['weather'];
      final forecasts = weatherData['forecasts'];

      setState(() {
        _currentWeather = weather;
        _forecasts = forecasts;
        _isLoading = false;
      });

      // Guardar la ciudad en recientes
      await _storageService.addRecentCity(city);
      await _loadRecentCities(); // Recargar la lista
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherApp'),
        actions: [
          // Botón para probar las alertas meteorológicas
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            tooltip: 'Probar alerta meteorológica',
            onPressed: _showTestAlert,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            onPressed: _getCurrentLocationWeather,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _getCurrentLocationWeather,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          CitySearch(
            onCitySelected: _getCityWeather,
            recentCities: _recentCities,
          ),
          if (_currentWeather != null) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: WeatherCard(weather: _currentWeather!),
            ),
            if (_forecasts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ForecastList(forecasts: _forecasts),
              ),
            if (_alerts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: WeatherAlerts(alerts: _alerts),
              ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
