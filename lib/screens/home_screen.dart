import 'package:flutter/material.dart';
import 'package:weather_app_jml/models/clima_model.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';
import 'package:weather_app_jml/models/ciudad_model.dart';
import 'package:weather_app_jml/models/datos_clima_model.dart';
import 'package:weather_app_jml/services/servicio_api.dart';
import 'package:weather_app_jml/services/shared_preferences_service.dart';
import 'package:weather_app_jml/widgets/clima_card.dart';
import 'package:weather_app_jml/widgets/buscador_ciudad.dart';
import 'package:weather_app_jml/screens/alerta_screen.dart';
import 'package:weather_app_jml/theme/theme_data.dart';
import 'package:weather_app_jml/widgets/pronostico_card.dart';
import 'package:weather_app_jml/services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(ThemeMode.light);

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _EstadoHomeScreen();
}

class _EstadoHomeScreen extends State<HomeScreen> {
  final ServicioApi _servicioApi = ServicioApi();
  final SharedPreferencesService _servicioSharedPreferences =
      SharedPreferencesService();

  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _pronosticoKeys = [];

  Clima? _climaActual;
  List<Pronostico> _pronosticos = [];
  List<AlertaMetereologica> _alertas = [];
  List<Ciudad> _ciudadesRecientes = [];
  Pronostico? _pronosticoSeleccionado;
  DatosClima? _datosClima;
  Map<String, dynamic>? _datosClimaRawPronostico;

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

      final resultado = await _servicioApi.obtenerDatosClimaPorUbicacionConJson(
        posicion.latitude,
        posicion.longitude,
      );
      final respuestaClima = resultado['modelo'] as DatosClima;
      final datosPronostico =
          resultado['jsonPronostico'] as Map<String, dynamic>;

      setState(() {
        _datosClima = respuestaClima;
        _climaActual = respuestaClima.climaActual;
        _pronosticos = respuestaClima.pronosticos;
        _alertas = [];
        _estaCargando = false;
        _datosClimaRawPronostico = datosPronostico;
      });
      await _servicioSharedPreferences.addCiudadesRecientes(
        respuestaClima.climaActual.nombreCiudad,
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

      final climaActual = datos.obtenerClimaPorFecha(DateTime.now());

      setState(() {
        _datosClima = datos;
        _climaActual = climaActual ?? datos.climaActual;
        _pronosticos = datos.pronosticos;
        _alertas = alertas;
        _estaCargando = false;
      });

      // Notificaciones para alertas reales
      for (int i = 0; i < alertas.length; i++) {
        final alerta = alertas[i];
        await NotificationService.mostrarNotificacionAlertaMeteorologica(
          _climaActual?.nombreCiudad ?? ciudad,
          alerta.evento,
          alerta.descripcion,
          id: i + 1,
        );
      }

      await _servicioSharedPreferences.addCiudadesRecientes(ciudad);
      await _cargarCiudadesRecientes();
    } catch (e) {
      setState(() {
        _error = 'Error al obtener datos del clima: $e';
        _estaCargando = false;
      });
    }
  }

  void _actualizarClimaConPronostico(Pronostico pronostico, int index) async {
    setState(() {
      if (_pronosticoSeleccionado == pronostico) {
        _pronosticoSeleccionado = null;
      } else {
        _pronosticoSeleccionado = pronostico;
      }
    });
    if (_pronosticoSeleccionado == pronostico) {
      final keyContext = _pronosticoKeys[index].currentContext;
      if (keyContext != null) {
        await Future.delayed(const Duration(milliseconds: 100));
        Scrollable.ensureVisible(
          keyContext,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  Widget _buildClimaActual() {
    if (_datosClima == null || _pronosticos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final hoy = DateTime.now();
    final temperaturasPorHora =
        _datosClimaRawPronostico != null
            ? _datosClima!.obtenerTemperaturasPorHora(
              hoy,
              _datosClimaRawPronostico!,
            )
            : <MapEntry<DateTime, double>>[];
    return ClimaCard(
      clima: _climaActual!,
      temperaturasPorHora: temperaturasPorHora,
    );
  }

  Widget _buildPronosticoExpandido() {
    if (_pronosticoSeleccionado == null || _datosClima == null) {
      return const SizedBox.shrink();
    }

    final pronostico = _pronosticoSeleccionado!;
    final climaTemporal = Clima(
      nombreCiudad: _climaActual!.nombreCiudad,
      temperatura: pronostico.temperatura,
      descripcion: pronostico.descripcion,
      temperaturaMinima: pronostico.temperaturaMinima,
      temperaturaMaxima: pronostico.temperaturaMaxima,
      humedad: pronostico.humedad,
      velocidadViento: pronostico.velocidadViento,
      icono: pronostico.icono,
      fecha: pronostico.fecha,
    );
    final temperaturasPorHora =
        _datosClimaRawPronostico != null
            ? _datosClima!.obtenerTemperaturasPorHora(
              pronostico.fecha,
              _datosClimaRawPronostico!,
            )
            : <MapEntry<DateTime, double>>[];
    return Column(
      children: [
        const SizedBox(height: 8),
        ClimaCard(
          clima: climaTemporal,
          temperaturasPorHora: temperaturasPorHora,
        ),
      ],
    );
  }

  Widget _buildListaPronosticos() {
    if (_pronosticos.isEmpty) {
      return const Center(child: Text('No hay pronósticos disponibles'));
    }

    final pronosticosFiltrados =
        _pronosticos.where((pronostico) {
          final fechaActual = DateTime.now();
          final fechaPronostico = pronostico.fecha;
          return !(fechaPronostico.year == fechaActual.year &&
              fechaPronostico.month == fechaActual.month &&
              fechaPronostico.day == fechaActual.day);
        }).toList();

    if (_pronosticoKeys.length != pronosticosFiltrados.length) {
      _pronosticoKeys.clear();
      _pronosticoKeys.addAll(
        List.generate(pronosticosFiltrados.length, (_) => GlobalKey()),
      );
    }

    if (pronosticosFiltrados.isEmpty) {
      return const Center(child: Text('No hay pronósticos disponibles'));
    }

    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: pronosticosFiltrados.length,
      itemBuilder: (context, index) {
        final pronostico = pronosticosFiltrados[index];
        return Column(
          key: _pronosticoKeys[index],
          children: [
            PronosticoCard(
              pronostico: pronostico,
              onTap: () => _actualizarClimaConPronostico(pronostico, index),
            ),
            AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              transitionBuilder:
                  (child, animation) =>
                      ScaleTransition(scale: animation, child: child),
              child:
                  _pronosticoSeleccionado == pronostico
                      ? _buildPronosticoExpandido()
                      : SizedBox.shrink(),
            ),
          ],
        );
      },
    );
  }

  void _mostrarAlertas() {
    if (_alertas.isEmpty) {
      final alertasPrueba = AlertaMetereologica.crearAlertasPrueba();

      // Notificaciones para alertas de prueba
      for (int i = 0; i < alertasPrueba.length; i++) {
        final alerta = alertasPrueba[i];
        NotificationService.mostrarNotificacionAlertaMeteorologica(
          alerta.remitente,
          alerta.evento,
          alerta.descripcion,
          id: i + 1000, // Para evitar colisión con las reales
        );
      }

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
    final Gradient fondo =
        _climaActual != null
            ? _obtenerFondoPorIcono(_climaActual!.icono)
            : LinearGradient(
              colors: [
                AppTheme.backgroundColor,
                AppTheme.primaryColor.withAlpha(80),
              ],
            );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App JML'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: themeModeNotifier,
            builder: (context, mode, _) {
              return IconButton(
                icon: Icon(
                  mode == ThemeMode.dark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny,
                ),
                tooltip: mode == ThemeMode.dark ? 'Modo claro' : 'Modo oscuro',
                onPressed: () {
                  final nuevoModo =
                      mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                  themeModeNotifier.value = nuevoModo;
                  SharedPreferencesService.guardarTema(nuevoModo);
                },
              );
            },
          ),
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
      body: Container(
        decoration: BoxDecoration(gradient: fondo),
        child:
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
                              'Busquedas recientes',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: _colorTituloPorIcono(
                                  _climaActual?.icono ?? '',
                                ),
                              ),
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
                                    label: Text(
                                      _ciudadesRecientes[index].nombre,
                                      style: TextStyle(
                                        color:
                                            Theme.of(
                                              context,
                                            ).chipTheme.labelStyle?.color ??
                                            Theme.of(
                                              context,
                                            ).colorScheme.onSurface,
                                      ),
                                    ),
                                    backgroundColor:
                                        Theme.of(
                                          context,
                                        ).chipTheme.backgroundColor,
                                    side: BorderSide(
                                      color: Theme.of(context).cardColor,
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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Clima actual',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: _colorTituloPorIcono(
                                _climaActual?.icono ?? '',
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildClimaActual(),
                        if (_pronosticos.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Pronóstico próximos 4 días',
                              style: theme.textTheme.displaySmall?.copyWith(
                                color: _colorTituloPorIcono(
                                  _climaActual?.icono ?? '',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildListaPronosticos(),
                        ],
                      ],
                    ),
                  ),
                ),
      ),
    );
  }

  Gradient _obtenerFondoPorIcono(String icono) {
    switch (icono) {
      case '01d': // Soleado día
        return const LinearGradient(
          colors: [Color(0xFF56CCF2), Color(0xFFB2FEFA)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '01n': // Soleado noche
        return const LinearGradient(
          colors: [Color(0xFF232526), Color(0xFF485563)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '02d': // Parcialmente nublado día
      case '03d':
      case '04d':
        return const LinearGradient(
          colors: [Color(0xFFD7DDE8), Color(0xFF757F9A)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '02n': // Parcialmente nublado noche
      case '03n':
      case '04n':
        return const LinearGradient(
          colors: [Color(0xFF434C5E), Color(0xFF232526)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '09d': // Lluvia
      case '09n':
      case '10d':
      case '10n':
        return const LinearGradient(
          colors: [Color(0xFF5D7697), Color(0xFFB0BEC5)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '11d': // Tormenta
      case '11n':
        return const LinearGradient(
          colors: [Color(0xFF373B44), Color(0xFF5F72BD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '13d': // Nieve
      case '13n':
        return const LinearGradient(
          colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      case '50d': // Niebla
      case '50n':
        return const LinearGradient(
          colors: [Color(0xFFd7dde8), Color(0xFFb8c6db)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
      default:
        return const LinearGradient(
          colors: [Color(0xFFB2FEFA), Color(0xFFE0EAFC)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        );
    }
  }

  Color _colorTituloPorIcono(String icono) {
    switch (icono) {
      case '01d':
      case '13d':
      case '13n':
      case '50d':
      case '50n':
      case '09d':
      case '09n':
      case '10d':
      case '10n':
        return AppTheme.textColorPrimary;
      default:
        return Colors.white;
    }
  }
}
