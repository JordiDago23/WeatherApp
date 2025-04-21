import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import '../models/clima_model.dart';
import '../models/pronostico_model.dart';
import '../models/alerta_metereologica_model.dart';

class ServicioApi {
  static final String _claveApi = dotenv.env['OPENWEATHERAPIKEY'] ?? '';
  static const String _urlBase = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> obtenerClimaYPronosticoPorCiudad(
    String ciudad,
  ) async {
    final respuesta = await http.get(
      Uri.parse(
        '$_urlBase/forecast?q=$ciudad&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    if (respuesta.statusCode == 200) {
      final datos = jsonDecode(respuesta.body);
      final List<dynamic> listaPronostico = datos['list'];
      final Map<String, dynamic> datosCiudad = datos['city'];

      List<Pronostico> pronosticos = [];
      String fechaActual = "";

      for (var item in listaPronostico) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        if (fecha != fechaActual) {
          fechaActual = fecha;
          pronosticos.add(Pronostico.fromJson(item));
        }
        if (pronosticos.length >= 5) break;
      }

      final datosPronosticoPrimero = listaPronostico[0];
      final clima = Clima(
        nombreCiudad: datosCiudad['name'],
        temperatura: datosPronosticoPrimero['main']['temp'].toDouble(),
        descripcion: datosPronosticoPrimero['weather'][0]['description'],
        temperaturaMinima:
            datosPronosticoPrimero['main']['temp_min'].toDouble(),
        temperaturaMaxima:
            datosPronosticoPrimero['main']['temp_max'].toDouble(),
        humedad: datosPronosticoPrimero['main']['humidity'],
        velocidadViento: datosPronosticoPrimero['wind']['speed'].toDouble(),
        icono: datosPronosticoPrimero['weather'][0]['icon'],
        fecha: DateTime.parse(datosPronosticoPrimero['dt_txt']),
      );

      return {'weather': clima, 'forecasts': pronosticos};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${respuesta.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> obtenerClimaYPronosticoPorUbicacion(
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
      final List<dynamic> listaPronostico = datos['list'];
      final Map<String, dynamic> datosCiudad = datos['city'];

      List<Pronostico> pronosticos = [];
      String fechaActual = "";

      for (var item in listaPronostico) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        if (fecha != fechaActual) {
          fechaActual = fecha;
          pronosticos.add(Pronostico.fromJson(item));
        }
        if (pronosticos.length >= 5) break;
      }

      final datosPronosticoPrimero = listaPronostico[0];
      final clima = Clima(
        nombreCiudad: datosCiudad['name'],
        temperatura: datosPronosticoPrimero['main']['temp'].toDouble(),
        descripcion: datosPronosticoPrimero['weather'][0]['description'],
        temperaturaMinima:
            datosPronosticoPrimero['main']['temp_min'].toDouble(),
        temperaturaMaxima:
            datosPronosticoPrimero['main']['temp_max'].toDouble(),
        humedad: datosPronosticoPrimero['main']['humidity'],
        velocidadViento: datosPronosticoPrimero['wind']['speed'].toDouble(),
        icono: datosPronosticoPrimero['weather'][0]['icon'],
        fecha: DateTime.parse(datosPronosticoPrimero['dt_txt']),
      );

      return {'weather': clima, 'forecasts': pronosticos};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${respuesta.statusCode}',
      );
    }
  }

  Future<Clima> obtenerClimaPorCiudad(String ciudad) async {
    final resultado = await obtenerClimaYPronosticoPorCiudad(ciudad);
    return resultado['weather'];
  }

  Future<List<Pronostico>> obtenerPronosticoPorCiudad(String ciudad) async {
    final resultado = await obtenerClimaYPronosticoPorCiudad(ciudad);
    return resultado['forecasts'];
  }

  Future<Clima> obtenerClimaPorUbicacion(
    double latitud,
    double longitud,
  ) async {
    final resultado = await obtenerClimaYPronosticoPorUbicacion(
      latitud,
      longitud,
    );
    return resultado['weather'];
  }

  Future<List<Pronostico>> obtenerPronosticoPorUbicacion(
    double latitud,
    double longitud,
  ) async {
    final resultado = await obtenerClimaYPronosticoPorUbicacion(
      latitud,
      longitud,
    );
    return resultado['forecasts'];
  }

  Future<List<AlertaMetereologica>> obtenerAlertasMeteorologicas(
    double latitud,
    double longitud,
  ) async {
    try {
      final respuesta = await http.get(
        Uri.parse(
          'https://api.openweathermap.org/data/3.0/onecall?lat=$latitud&lon=$longitud&exclude=current,minutely,hourly,daily&appid=$_claveApi&lang=es',
        ),
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        List<AlertaMetereologica> alertas = [];

        if (datos.containsKey('alerts')) {
          final List<dynamic> listaAlertas = datos['alerts'];
          for (var alerta in listaAlertas) {
            alertas.add(AlertaMetereologica.fromJson(alerta));
          }
        }

        return alertas;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  Future<Position> obtenerUbicacionActual() async {
    bool servicioHabilitado = await Geolocator.isLocationServiceEnabled();
    if (!servicioHabilitado) {
      throw Exception('Servicios de ubicación desactivados');
    }

    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
    }

    if (permiso == LocationPermission.denied ||
        permiso == LocationPermission.deniedForever) {
      throw Exception('Permisos de ubicación denegados');
    }

    return await Geolocator.getCurrentPosition();
  }
}
