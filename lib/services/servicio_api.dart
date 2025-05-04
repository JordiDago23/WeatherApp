import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';
import 'package:weather_app_jml/models/datos_clima_model.dart';
import 'package:weather_app_jml/models/ciudad_sugerida_model.dart';

class ServicioApi {
  static final String _claveApi = dotenv.env['OPENWEATHERAPIKEY'] ?? '';
  static const String _urlBase = 'https://api.openweathermap.org/data/2.5';
  static const String _urlGeo = 'http://api.openweathermap.org/geo/1.0';

  final Map<String, DatosClima> _cacheDatosClima = {};

  Future<List<CiudadSugerida>> buscarCiudades(String consulta) async {
    if (consulta.isEmpty) return [];

    final respuesta = await http.get(
      Uri.parse('$_urlGeo/direct?q=$consulta&limit=5&appid=$_claveApi'),
    );

    if (respuesta.statusCode == 200) {
      final List<dynamic> datos = jsonDecode(respuesta.body);
      return datos.map((json) => CiudadSugerida.fromJson(json)).toList();
    }
    return [];
  }

  Future<Map<String, double>> obtenerCoordendasCiudad(String ciudad) async {
    final ciudades = await buscarCiudades(ciudad);
    if (ciudades.isNotEmpty) {
      return {'lat': ciudades[0].latitud, 'lon': ciudades[0].longitud};
    }
    throw Exception('No se pudieron obtener las coordenadas de la ciudad');
  }

  Future<DatosClima> obtenerDatosClimaPorCiudad(String ciudad) async {
    if (_cacheDatosClima.containsKey(ciudad)) {
      return _cacheDatosClima[ciudad]!;
    }

    final coordenadas = await obtenerCoordendasCiudad(ciudad);
    final resultado = await obtenerDatosClimaPorUbicacionConJson(
      coordenadas['lat']!,
      coordenadas['lon']!,
    );
    return resultado['modelo'] as DatosClima;
  }

  Future<Map<String, dynamic>> obtenerDatosClimaPorUbicacionConJson(
    double latitud,
    double longitud,
  ) async {
    final respuestaPronostico = await http.get(
      Uri.parse(
        '$_urlBase/forecast?lat=$latitud&lon=$longitud&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    if (respuestaPronostico.statusCode == 200) {
      final datosPronostico = jsonDecode(respuestaPronostico.body);

      final datosCompletos = DatosClima.fromJson(datosPronostico);

      _cacheDatosClima[datosCompletos.climaActual.nombreCiudad] =
          datosCompletos;

      return {'modelo': datosCompletos, 'jsonPronostico': datosPronostico};
    } else {
      throw Exception('Error al obtener datos meteorológicos');
    }
  }

  Future<Position> obtenerUbicacionActual() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('Los servicios de ubicación están deshabilitados.');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        throw Exception('Los permisos de ubicación fueron denegados');
      }
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<List<AlertaMetereologica>> obtenerAlertasMeteorologicas(
    double latitud,
    double longitud,
  ) async {
    final respuesta = await http.get(
      Uri.parse(
        '$_urlBase/forecast?lat=$latitud&lon=$longitud&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final List<AlertaMetereologica> alertas = [];

      if (datos['list'] != null) {
        for (var item in datos['list']) {
          final temp = item['main']['temp'].toDouble();
          final velocidadViento = item['wind']['speed'].toDouble();
          final descripcion =
              item['weather'][0]['description'].toString().toLowerCase();
          final dt = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);

          if (temp > 35) {
            alertas.add(
              AlertaMetereologica(
                evento: 'Temperatura extremadamente alta',
                descripcion: 'La temperatura superará los 35°C',
                inicio: dt.toString(),
                fin: dt.add(const Duration(hours: 1)).toString(),
                remitente: 'Sistema de Alertas Meteorológicas',
                tipo: 'Temperatura',
              ),
            );
          } else if (temp < 0) {
            alertas.add(
              AlertaMetereologica(
                evento: 'Temperatura bajo cero',
                descripcion: 'La temperatura descenderá por debajo de 0°C',
                inicio: dt.toString(),
                fin: dt.add(const Duration(hours: 1)).toString(),
                remitente: 'Sistema de Alertas Meteorológicas',
                tipo: 'Temperatura',
              ),
            );
          }

          if (velocidadViento > 20) {
            alertas.add(
              AlertaMetereologica(
                evento: 'Vientos fuertes',
                descripcion:
                    'Se esperan vientos con velocidades superiores a 20 m/s',
                inicio: dt.toString(),
                fin: dt.add(const Duration(hours: 1)).toString(),
                remitente: 'Sistema de Alertas Meteorológicas',
                tipo: 'Viento',
              ),
            );
          }

          if (descripcion.contains('tormenta') ||
              descripcion.contains('lluvia fuerte') ||
              descripcion.contains('granizo')) {
            alertas.add(
              AlertaMetereologica(
                evento: 'Condiciones severas',
                descripcion: 'Se esperan ${item['weather'][0]['description']}',
                inicio: dt.toString(),
                fin: dt.add(const Duration(hours: 1)).toString(),
                remitente: 'Sistema de Alertas Meteorológicas',
                tipo: 'Tormenta',
              ),
            );
          }
        }
      }

      return alertas;
    } else {
      throw Exception('Error al obtener alertas meteorológicas');
    }
  }
}
