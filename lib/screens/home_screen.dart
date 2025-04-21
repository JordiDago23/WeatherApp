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
  State<HomeScreen> createState() => _EstadoHomeScreen();
}

class _EstadoHomeScreen extends State<HomeScreen> {
  final ServicioApi _servicioApi = ServicioApi();
  final StorageService _servicioAlmacenamiento = StorageService();

  Weather? _climaActual;
  List<Forecast> _pronosticos = [];
  List<WeatherAlert> _alertas = [];
  List<City> _ciudadesRecientes = [];

  bool _estaCargando = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarCiudadesRecientes();
    _obtenerClimaUbicacionActual();
  }

  void _mostrarAlertaPrueba() {
    final alertaPrueba = WeatherAlert.createTestAlert();

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AlertScreen(
              alert: alertaPrueba,
              onClose: () {
                Navigator.of(context).pop();
              },
            ),
      ),
    );
  }

  Future<void> _cargarCiudadesRecientes() async {
    try {
      final ciudades = await _servicioAlmacenamiento.getRecentCities();
      setState(() {
        _ciudadesRecientes = ciudades;
      });
    } catch (e) {
      setState(() {
        _ciudadesRecientes = [];
      });
    }
  }

  Future<void> _obtenerClimaUbicacionActual() async {
    setState(() {
      _estaCargando = true;
      _error = '';
    });

    try {
      final posicion = await _servicioApi.obtenerUbicacionActual();

      final clima = await _servicioApi.obtenerClimaPorUbicacion(
        posicion.latitude,
        posicion.longitude,
      );

      final pronosticos = await _servicioApi.obtenerPronosticoPorUbicacion(
        posicion.latitude,
        posicion.longitude,
      );

      final alertas = await _servicioApi.obtenerAlertasMeteorologicas(
        posicion.latitude,
        posicion.longitude,
      );

      setState(() {
        _climaActual = clima;
        _pronosticos = pronosticos;
        _alertas = alertas;
        _estaCargando = false;
      });

      await _servicioAlmacenamiento.addRecentCity(clima.cityName);
      await _cargarCiudadesRecientes();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _estaCargando = false;
      });
    }
  }

  Future<void> _obtenerClimaCiudad(String ciudad) async {
    setState(() {
      _estaCargando = true;
      _error = '';
    });

    try {
      final clima = await _servicioApi.obtenerClimaPorCiudad(ciudad);

      final pronosticos = await _servicioApi.obtenerPronosticoPorCiudad(ciudad);

      setState(() {
        _climaActual = clima;
        _pronosticos = pronosticos;
        _estaCargando = false;
      });

      await _servicioAlmacenamiento.addRecentCity(ciudad);
      await _cargarCiudadesRecientes();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _estaCargando = false;
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
            onPressed: _mostrarAlertaPrueba,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Mi ubicación',
            onPressed: _obtenerClimaUbicacionActual,
          ),
        ],
      ),
      body: _buildBody(theme),
    );
  }

  Widget _buildBody(ThemeData theme) {
    if (_estaCargando) {
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
              onPressed: _obtenerClimaUbicacionActual,
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
            child: CitySearch(onCitySelected: _obtenerClimaCiudad),
          ),

          if (_ciudadesRecientes.isNotEmpty) ...[
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
                  itemCount: _ciudadesRecientes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(_ciudadesRecientes[index].name),
                        backgroundColor: AppTheme.secondaryColor.withAlpha(50),
                        labelStyle: TextStyle(color: AppTheme.primaryColor),
                        onPressed: () {
                          _obtenerClimaCiudad(_ciudadesRecientes[index].name);
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],

          const SizedBox(height: 8),
          if (_climaActual != null) ...[
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
              child: WeatherCard(weather: _climaActual!),
            ),
            if (_pronosticos.isNotEmpty) ...[
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
                child: ForecastList(forecasts: _pronosticos),
              ),
            ],
            if (_alertas.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: WeatherAlerts(alerts: _alertas),
              ),
            const SizedBox(height: 40),
          ],
        ],
      ),
    );
  }
}
