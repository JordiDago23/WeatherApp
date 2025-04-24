import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/clima_model.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';
import 'package:weather_app_jml/models/ciudad_model.dart';
import 'package:weather_app_jml/models/datos_clima_model.dart';
import 'package:weather_app_jml/services/servicio_api.dart';
import 'package:weather_app_jml/services/shared_preferences_service.dart';
import 'package:weather_app_jml/widgets/clima_actual_card.dart';
import 'package:weather_app_jml/widgets/buscador_ciudad.dart';
import 'package:weather_app_jml/screens/alerta_screen.dart';
import 'package:weather_app_jml/theme/theme_data.dart';
import 'package:weather_app_jml/widgets/lista_pronostico.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _EstadoHomeScreen();
}

class _EstadoHomeScreen extends State<HomeScreen> {
  final ServicioApi _servicioApi = ServicioApi();
  final SharedPreferencesService _servicioSharedPreferences =
      SharedPreferencesService();

  Clima? _climaActual;
  List<Pronostico> _pronosticos = [];
  List<AlertaMetereologica> _alertas = [];
  List<Ciudad> _ciudadesRecientes = [];
  Pronostico? _pronosticoSeleccionado;
  DatosClima? _datosClima;

  bool _estaCargando = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _cargarCiudadesRecientes();
    _obtenerClimaUbicacionActual();
  }

  Future<void> _cargarCiudadesRecientes() async {
    try {
      final ciudades = await _servicioSharedPreferences.getCiudadesRecientes();
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

      final datos = await _servicioApi.obtenerDatosClimaPorUbicacion(
        posicion.latitude,
        posicion.longitude,
      );

      final alertas = await _servicioApi.obtenerAlertasMeteorologicas(
        posicion.latitude,
        posicion.longitude,
      );

      setState(() {
        _datosClima = datos;
        _climaActual = datos.climaActual;
        _pronosticos = datos.pronosticos;
        _alertas = alertas;
        _estaCargando = false;
      });

      await _servicioSharedPreferences.addCiudadesRecientes(
        datos.climaActual.nombreCiudad,
      );
      await _cargarCiudadesRecientes();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _estaCargando = false;
      });
    }
  }

  Future<void> _obtenerClimaCiudadBuscada(String ciudad) async {
    setState(() {
      _estaCargando = true;
      _error = '';
    });

    try {
      final datos = await _servicioApi.obtenerDatosClimaPorCiudad(ciudad);

      final coordenadas = await _servicioApi.obtenerCoordendasCiudad(ciudad);
      final alertas = await _servicioApi.obtenerAlertasMeteorologicas(
        coordenadas['lat']!,
        coordenadas['lon']!,
      );

      setState(() {
        _datosClima = datos;
        _climaActual = datos.climaActual;
        _pronosticos = datos.pronosticos;
        _alertas = alertas;
        _estaCargando = false;
      });

      await _servicioSharedPreferences.addCiudadesRecientes(ciudad);
      await _cargarCiudadesRecientes();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _estaCargando = false;
      });
    }
  }

  void _actualizarClimaConPronostico(Pronostico pronostico) {
    if (_datosClima == null) return;

    final climaFecha = _datosClima!.obtenerClimaPorFecha(pronostico.fecha);
    if (climaFecha != null) {
      setState(() {
        _pronosticoSeleccionado = pronostico;
        _climaActual = climaFecha;
      });
    }
  }

  Widget _buildClimaActual() {
    if (_climaActual == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_pronosticoSeleccionado != null) {
      final pronostico = _pronosticoSeleccionado!;
      final climaTemporal = Clima(
        nombreCiudad: _climaActual!.nombreCiudad,
        temperatura: pronostico.temperatura,
        descripcion: pronostico.descripcion,
        temperaturaMinima: _climaActual!.temperaturaMinima,
        temperaturaMaxima: _climaActual!.temperaturaMaxima,
        humedad: pronostico.humedad,
        velocidadViento: pronostico.velocidadViento,
        icono: pronostico.icono,
        fecha: pronostico.fecha,
      );
      return ClimaActualCard(clima: climaTemporal);
    }

    return ClimaActualCard(clima: _climaActual!);
  }

  Widget _buildListaPronosticos() {
    if (_pronosticos.isEmpty) {
      return const Center(child: Text('No hay pronósticos disponibles'));
    }

    return ListaPronostico(
      pronosticos: _pronosticos,
      onPronosticoSeleccionado: _actualizarClimaConPronostico,
    );
  }

  void _mostrarAlertas() {
    if (_alertas.isEmpty) {
      final alertasPrueba = AlertaMetereologica.crearAlertasPrueba();

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Alertas Meteorológicas'),
            children: [
              ...alertasPrueba.map(
                (alerta) => InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => AlertaScreen(
                              alerta: alerta,
                              onClose: () {
                                Navigator.of(context).pop();
                              },
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.alertColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(alerta.evento)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          );
        },
      );
      return;
    }

    if (_alertas.length == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder:
              (context) => AlertaScreen(
                alerta: _alertas[0],
                onClose: () {
                  Navigator.of(context).pop();
                },
              ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Alertas Meteorológicas'),
            children: [
              ..._alertas.map(
                (alerta) => InkWell(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder:
                            (context) => AlertaScreen(
                              alerta: alerta,
                              onClose: () {
                                Navigator.of(context).pop();
                              },
                            ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.warning_amber_rounded,
                          color: AppTheme.alertColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(alerta.evento)),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16, top: 8),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancelar'),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App JML'),
        actions: [
          IconButton(
            icon: const Icon(Icons.warning_amber_rounded),
            tooltip: 'Ver alertas meteorológicas',
            onPressed: _mostrarAlertas,
          ),
          IconButton(
            icon: const Icon(Icons.my_location),
            tooltip: 'Mi ubicación',
            onPressed: _obtenerClimaUbicacionActual,
          ),
        ],
      ),
      body:
          _estaCargando
              ? const Center(child: CircularProgressIndicator())
              : _error.isNotEmpty
              ? Center(child: Text(_error))
              : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      BuscadorCiudad(
                        onCitySelected: _obtenerClimaCiudadBuscada,
                      ),
                      if (_ciudadesRecientes.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Ciudades recientes',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _ciudadesRecientes.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: ActionChip(
                                  label: Text(_ciudadesRecientes[index].nombre),
                                  backgroundColor: AppTheme.secondaryColor
                                      .withAlpha(50),
                                  labelStyle: TextStyle(
                                    color: AppTheme.primaryColor,
                                  ),
                                  onPressed: () {
                                    _obtenerClimaCiudadBuscada(
                                      _ciudadesRecientes[index].nombre,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildClimaActual(),
                      if (_pronosticos.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Pronóstico de 5 días',
                            style: theme.textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildListaPronosticos(),
                      ],
                    ],
                  ),
                ),
              ),
    );
  }
}
