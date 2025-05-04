import 'package:weather_app_jml/models/clima_model.dart';
import 'package:weather_app_jml/models/pronostico_model.dart';

class DatosClima {
  final Clima climaActual;
  final List<Pronostico> pronosticos;
  final Map<DateTime, Clima> climaPorFecha;

  DatosClima({
    required this.climaActual,
    required this.pronosticos,
    required this.climaPorFecha,
  });

  Clima? obtenerClimaPorFecha(DateTime fecha) {
    final fechaNormalizada = DateTime(fecha.year, fecha.month, fecha.day);
    return climaPorFecha[fechaNormalizada];
  }

  factory DatosClima.fromJson(Map<String, dynamic> jsonPronostico) {
    // Agrupa los items del pronóstico por día
    final Map<String, List<dynamic>> pronosticosPorDia = {};
    if (jsonPronostico['list'] != null) {
      for (var item in jsonPronostico['list']) {
        String fecha = item['dt_txt'].toString().split(' ')[0];
        if (!pronosticosPorDia.containsKey(fecha)) {
          pronosticosPorDia[fecha] = [];
        }
        pronosticosPorDia[fecha]!.add(item);
      }
    }

    // Obtén la fecha de hoy en formato yyyy-MM-dd
    final hoy = DateTime.now();
    final hoyStr =
        '${hoy.year.toString().padLeft(4, '0')}-${hoy.month.toString().padLeft(2, '0')}-${hoy.day.toString().padLeft(2, '0')}';
    Clima climaActual;
    if (pronosticosPorDia.containsKey(hoyStr)) {
      final itemsHoy = pronosticosPorDia[hoyStr]!;
      final pronosticoHoy = Pronostico.fromDailyForecasts(
        itemsHoy.cast<Map<String, dynamic>>(),
      );
      climaActual = Clima(
        nombreCiudad: jsonPronostico['city']['name'],
        temperatura: pronosticoHoy.temperatura,
        descripcion: pronosticoHoy.descripcion,
        temperaturaMinima: pronosticoHoy.temperaturaMinima,
        temperaturaMaxima: pronosticoHoy.temperaturaMaxima,
        humedad: pronosticoHoy.humedad,
        velocidadViento: pronosticoHoy.velocidadViento,
        icono: pronosticoHoy.icono,
        fecha: pronosticoHoy.fecha,
      );
    } else {
      // Si no hay datos para hoy, usa el primer item disponible
      final primerItem = jsonPronostico['list'][0];
      climaActual = Clima(
        nombreCiudad: jsonPronostico['city']['name'],
        temperatura: primerItem['main']['temp'].toDouble(),
        descripcion: primerItem['weather'][0]['description'],
        temperaturaMinima: primerItem['main']['temp_min'].toDouble(),
        temperaturaMaxima: primerItem['main']['temp_max'].toDouble(),
        humedad: primerItem['main']['humidity'],
        velocidadViento: primerItem['wind']['speed'].toDouble(),
        icono: primerItem['weather'][0]['icon'],
        fecha: DateTime.parse(primerItem['dt_txt']),
      );
    }
    final pronosticos = <Pronostico>[];
    final climaPorFecha = <DateTime, Clima>{};

    if (jsonPronostico['list'] != null) {
      pronosticosPorDia.forEach((fecha, items) {
        if (pronosticos.length < 5) {
          double tempMin = double.infinity;
          double tempMax = double.negativeInfinity;
          String descripcion = items[0]['weather'][0]['description'];
          String icono = items[0]['weather'][0]['icon'];
          int humedad = 0;
          double velocidadViento = 0;
          double tempPromedio = 0;

          for (var item in items) {
            double temp = item['main']['temp'].toDouble();
            tempMin = temp < tempMin ? temp : tempMin;
            tempMax = temp > tempMax ? temp : tempMax;
            tempPromedio += temp;
            humedad += item['main']['humidity'] as int;
            velocidadViento += item['wind']['speed'].toDouble();
          }

          tempPromedio /= items.length;
          humedad = (humedad / items.length).round();
          velocidadViento /= items.length;

          final pronostico = Pronostico.fromDailyForecasts(
            items.cast<Map<String, dynamic>>(),
          );
          pronosticos.add(pronostico);

          final fechaObj = DateTime.parse(fecha);
          final fechaNormalizada = DateTime(
            fechaObj.year,
            fechaObj.month,
            fechaObj.day,
          );

          if (fechaNormalizada.year == climaActual.fecha.year &&
              fechaNormalizada.month == climaActual.fecha.month &&
              fechaNormalizada.day == climaActual.fecha.day) {
            climaPorFecha[fechaNormalizada] = climaActual;
          } else {
            climaPorFecha[fechaNormalizada] = Clima(
              nombreCiudad: climaActual.nombreCiudad,
              temperatura: tempPromedio,
              descripcion: descripcion,
              temperaturaMinima: tempMin,
              temperaturaMaxima: tempMax,
              humedad: humedad,
              velocidadViento: velocidadViento,
              icono: icono,
              fecha: fechaObj,
            );
          }
        }
      });
    }

    return DatosClima(
      climaActual: climaActual,
      pronosticos: pronosticos,
      climaPorFecha: climaPorFecha,
    );
  }

  List<MapEntry<DateTime, double>> obtenerTemperaturasPorHora(
    DateTime dia,
    Map<String, dynamic> jsonPronostico,
  ) {
    final List<MapEntry<DateTime, double>> temperaturas = [];
    if (jsonPronostico['list'] != null) {
      for (var item in jsonPronostico['list']) {
        final fecha = DateTime.parse(item['dt_txt']);
        if (fecha.year == dia.year &&
            fecha.month == dia.month &&
            fecha.day == dia.day) {
          final temp = item['main']['temp'].toDouble();
          temperaturas.add(MapEntry(fecha, temp));
        }
      }
    }
    return temperaturas;
  }
}
