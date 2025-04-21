import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/weather_model.dart';
import 'package:weather_app_jml/models/forecast_model.dart';
import 'package:weather_app_jml/models/alert_model.dart';
import 'package:weather_app_jml/models/city_model.dart';
import 'package:weather_app_jml/services/api_service.dart';
import 'package:weather_app_jml/services/storage_service.dart';
import 'package:weather_app_jml/widgets/weather_card.dart';
import 'package:weather_app_jml/widgets/forecast_card.dart';
import 'package:weather_app_jml/widgets/weather_alerts.dart';
import 'package:weather_app_jml/widgets/city_search.dart';
import 'package:weather_app_jml/screens/alert_screen.dart';
import 'package:weather_app_jml/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
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

  void _showTestAlert() {
    final testAlert = WeatherAlert.createTestAlert();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AlertScreen(
              alert: testAlert,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }

  Future<void> _loadRecentCities() async {
    try {
      final cities = await _storageService.getRecentCities();
      setState(() {
        _recentCities = cities;
      });
    } catch (e) {
      setState(() {
        _recentCities = [];
      });
    }
  }

  Future<void> _getCurrentLocationWeather() async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final position = await _apiService.getCurrentLocation();

      final weather = await _apiService.getWeatherByLocation(
        position.latitude,
        position.longitude,
      );

      final forecasts = await _apiService.getForecastByLocation(
        position.latitude,
        position.longitude,
      );

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

      await _storageService.addRecentCity(weather.cityName);
      await _loadRecentCities();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _getCityWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final weather = await _apiService.getWeatherByCity(city);

      final forecasts = await _apiService.getForecastByCity(city);

      setState(() {
        _currentWeather = weather;
        _forecasts = forecasts;
        _isLoading = false;
      });

      await _storageService.addRecentCity(city);
      await _loadRecentCities();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi App del Clima'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            tooltip: 'Probar alerta',
            onPressed: _showTestAlert,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Mi ubicación',
            onPressed: _getCurrentLocationWeather,
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AppTheme.errorColor),
            const SizedBox(height: 16),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge,
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: CitySearch(onCitySelected: _getCityWeather),
          ),

          if (_recentCities.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ciudades recientes',
                  style: theme.textTheme.titleLarge,
                ),
              ),
            ),
            SizedBox(
              height: 40,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _recentCities.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(_recentCities[index].name),
                        backgroundColor: AppTheme.secondaryColor.withAlpha(50),
                        labelStyle: TextStyle(color: AppTheme.primaryColor),
                        onPressed: () {
                          _getCityWeather(_recentCities[index].name);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),
          if (_currentWeather != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Clima actual',
                  style: theme.textTheme.displaySmall,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: WeatherCard(weather: _currentWeather!),
            ),
            if (_forecasts.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pronóstico de 5 días',
                    style: theme.textTheme.displaySmall,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ForecastList(forecasts: _forecasts),
              ),
            ],
            if (_alerts.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: WeatherAlerts(alerts: _alerts),
              ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
}
