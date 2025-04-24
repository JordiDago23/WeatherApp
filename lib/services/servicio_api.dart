import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_jml/models/clima_model.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';
import 'package:weather_app_jml/models/alerta_metereologica_model.dart';

class ServicioApi {
  static final String _claveApi = dotenv.env['OPENWEATHERAPIKEY'] ?? '';
  static const String _urlBase = 'https://api.openweathermap.org/data/2.5';

  Future<Map<String, dynamic>> obtenerClimaYPronosticoPorCiudad(
    String ciudad,
  ) async {
    final respuestaClima = await http.get(
      Uri.parse(
        '$_urlBase/weather?q=$ciudad&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    final respuestaPronostico = await http.get(
      Uri.parse(
        '$_urlBase/forecast?q=$ciudad&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    if (respuestaClima.statusCode == 200 &&
        respuestaPronostico.statusCode == 200) {
      final datosClima = jsonDecode(respuestaClima.body);

      final datosPronostico = jsonDecode(respuestaPronostico.body);
      final List<dynamic> listaPronostico = datosPronostico['list'];
      final Map<String, dynamic> datosCiudad = datosPronostico['city'];

      List<Pronostico> pronosticos = [];
      String fechaActual = "";

      double tempMin = double.infinity;
      double tempMax = double.negativeInfinity;
      String fechaHoy = listaPronostico[0]['dt_txt'].toString().split(' ')[0];

      for (var item in listaPronostico) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        double temperatura = item['main']['temp'].toDouble();

        if (fecha == fechaHoy) {
          if (temperatura < tempMin) {
            tempMin = temperatura;
          }
          if (temperatura > tempMax) {
            tempMax = temperatura;
          }
        }

        if (fecha != fechaActual) {
          fechaActual = fecha;
          pronosticos.add(Pronostico.fromJson(item));
        }
        if (pronosticos.length >= 5) break;
      }

      if (tempMin == double.infinity) tempMin = 0;
      if (tempMax == double.negativeInfinity) tempMax = 0;

      double temperaturaActual = datosClima['main']['temp'].toDouble();
      if ((tempMax - temperaturaActual).abs() < 0.5) {
        tempMax += 1.0;
      }

      final clima = Clima(
        nombreCiudad: datosCiudad['name'],
        temperatura: temperaturaActual,
        descripcion: datosClima['weather'][0]['description'],
        temperaturaMinima: tempMin,
        temperaturaMaxima: tempMax,
        humedad: datosClima['main']['humidity'],
        velocidadViento: datosClima['wind']['speed'].toDouble(),
        icono: datosClima['weather'][0]['icon'],
        fecha: DateTime.fromMillisecondsSinceEpoch(datosClima['dt'] * 1000),
      );

      return {'weather': clima, 'forecasts': pronosticos};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${respuestaPronostico.statusCode}',
      );
    }
  }

  Future<Map<String, dynamic>> obtenerClimaYPronosticoPorUbicacion(
    double latitud,
    double longitud,
  ) async {
    final respuestaClima = await http.get(
      Uri.parse(
        '$_urlBase/weather?lat=$latitud&lon=$longitud&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    final respuestaPronostico = await http.get(
      Uri.parse(
        '$_urlBase/forecast?lat=$latitud&lon=$longitud&units=metric&appid=$_claveApi&lang=es',
      ),
    );

    if (respuestaClima.statusCode == 200 &&
        respuestaPronostico.statusCode == 200) {
      final datosClima = jsonDecode(respuestaClima.body);

      final datosPronostico = jsonDecode(respuestaPronostico.body);
      final List<dynamic> listaPronostico = datosPronostico['list'];
      final Map<String, dynamic> datosCiudad = datosPronostico['city'];

      List<Pronostico> pronosticos = [];
      String fechaActual = "";

      double tempMin = double.infinity;
      double tempMax = double.negativeInfinity;
      String fechaHoy = listaPronostico[0]['dt_txt'].toString().split(' ')[0];

      for (var item in listaPronostico) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        double temperatura = item['main']['temp'].toDouble();

        if (fecha == fechaHoy) {
          if (temperatura < tempMin) {
            tempMin = temperatura;
          }
          if (temperatura > tempMax) {
            tempMax = temperatura;
          }
        }

        if (fecha != fechaActual) {
          fechaActual = fecha;
          pronosticos.add(Pronostico.fromJson(item));
        }
        if (pronosticos.length >= 5) break;
      }

      if (tempMin == double.infinity) tempMin = 0;
      if (tempMax == double.negativeInfinity) tempMax = 0;

      double temperaturaActual = datosClima['main']['temp'].toDouble();
      if ((tempMax - temperaturaActual).abs() < 0.5) {
        tempMax += 1.0;
      }

      final clima = Clima(
        nombreCiudad: datosCiudad['name'],
        temperatura: temperaturaActual,
        descripcion: datosClima['weather'][0]['description'],
        temperaturaMinima: tempMin,
        temperaturaMaxima: tempMax,
        humedad: datosClima['main']['humidity'],
        velocidadViento: datosClima['wind']['speed'].toDouble(),
        icono: datosClima['weather'][0]['icon'],
        fecha: DateTime.fromMillisecondsSinceEpoch(datosClima['dt'] * 1000),
      );

      return {'weather': clima, 'forecasts': pronosticos};
    } else {
      throw Exception(
        'Error al obtener datos meteorológicos: ${respuestaPronostico.statusCode}',
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

  Future<Map<String, double>> obtenerCoordendasCiudad(String ciudad) async {
    try {
      final respuesta = await http.get(
        Uri.parse('$_urlBase/weather?q=$ciudad&appid=$_claveApi'),
      );

      if (respuesta.statusCode == 200) {
        final datos = jsonDecode(respuesta.body);
        final Map<String, dynamic> coordenadas = datos['coord'];
        return {
          'lat': coordenadas['lat'].toDouble(),
          'lon': coordenadas['lon'].toDouble(),
        };
      } else {
        throw Exception(
          'Error al obtener coordenadas: ${respuesta.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error al obtener coordenadas: $e');
    }
  }
}
